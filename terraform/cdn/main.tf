locals {
  #* Bucket name is shared between the resource and the policy. This overcomes cycle dependancy between the two
  bucket_name = "ans-cdn-top10cats-demo-${random_string.random.result}"
  #* Do not create the CNAME when the demo domain name is not specified
  alternate_cname = var.demo_domain_name != null ? "merlin.${var.demo_domain_name}" : null
  #* Use the default CloudFront certificate when the demo domain name is not specified
  use_default_cert = var.demo_domain_name == null
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowPublicAccessToS3Bucket"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject", ]
    resources = ["arn:aws:s3:::${local.bucket_name}/*", ]
  }
}

data "aws_iam_policy_document" "bucket_policy_with_oai" {
  statement {
    sid = "AllowAccessFromCloudFrontToS3Bucket"
    principals {
      type        = "AWS"
      identifiers = module.cdn[0].cloudfront_origin_access_identity_iam_arns
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.bucket_name}/*"]
  }
}

data "aws_iam_policy_document" "bucket_policy_combined" {
  source_policy_documents = [(
    var.secure_s3_bucket ?
    data.aws_iam_policy_document.bucket_policy_with_oai.json :
    data.aws_iam_policy_document.bucket_policy.json
    )
  ]
}

resource "random_string" "random" {
  length  = 12
  special = false
  upper   = false
}

module "template_files" {
  source  = "hashicorp/dir/template"
  version = "~> v1.0.2"

  base_dir = "${path.module}/static"
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> v3.3.0"

  bucket        = local.bucket_name
  force_destroy = true

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy_combined.json

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
}

module "s3_bucket_object" {
  for_each = module.template_files.files
  source   = "terraform-aws-modules/s3-bucket/aws//modules/object"
  version  = "~> v3.3.0"

  bucket       = module.s3_bucket.s3_bucket_id
  key          = each.key
  content_type = each.value.content_type
  file_source  = each.value.source_path
}

data "aws_cloudfront_cache_policy" "this" {
  count = var.enable_cloudfront ? 1 : 0
  name  = "Managed-CachingOptimized"
}

module "cdn" {
  count   = var.enable_cloudfront ? 1 : 0
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 2.9.3"

  aliases = var.demo_domain_name != null ? [local.alternate_cname] : null

  comment     = "Top 10 Cats CDN"
  enabled     = true
  price_class = "PriceClass_All"

  origin = {
    top10cats = {
      domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name

      #? Can s3_origin_config be added dynamically based on the value of var.secure_s3_bucket
      #* Uncomment to associated the OAI with the cloudfront distribution and secure the S3 bucket
      # s3_origin_config = {
      #   origin_access_identity = "top-10-cats-bucket"
      # }
    }
  }

  create_origin_access_identity = var.secure_s3_bucket ? true : false
  origin_access_identities = {
    top-10-cats-bucket = "top-10-cats-bucket"
  }

  default_root_object = "index.html"

  default_cache_behavior = {
    use_forwarded_values   = false
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.this[0].id
    target_origin_id       = "top10cats"
  }

  viewer_certificate = {
    acm_certificate_arn            = local.use_default_cert ? null : module.acm[0].acm_certificate_arn
    mminimum_protocol_version      = local.use_default_cert ? null : "TLSv1.2_2021"
    ssl_support_method             = local.use_default_cert ? null : "sni-only"
    cloudfront_default_certificate = local.use_default_cert
  }
}

data "aws_route53_zone" "demo" {
  count = var.demo_domain_name != null ? 1 : 0
  name  = var.demo_domain_name
}

module "acm" {
  count   = var.demo_domain_name != null ? 1 : 0
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0.1"

  domain_name         = local.alternate_cname
  zone_id             = data.aws_route53_zone.demo[0].zone_id
  wait_for_validation = true
}

module "cname_record" {
  count   = var.demo_domain_name != null ? 1 : 0
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.9.0"

  zone_id = data.aws_route53_zone.demo[0].zone_id
  records = [
    {
      name = "merlin"
      type = "A"
      alias = {
        name    = module.cdn[0].cloudfront_distribution_domain_name
        zone_id = module.cdn[0].cloudfront_distribution_hosted_zone_id
      }
    }
  ]
}
