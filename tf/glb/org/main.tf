data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {}

locals {
  prefix               = "3ware-ans-demo"
  bucket_name          = "${local.prefix}-cloudtrail"
  sensitive_account_id = sensitive(data.aws_caller_identity.current.account_id)
  trail_name           = "${local.prefix}-cloudtrail"
  log_streams = [
    "${module.log_group.cloudwatch_log_group_arn}:log-stream:${local.sensitive_account_id}_CloudTrail_${data.aws_region.current.name}*",
    "${module.log_group.cloudwatch_log_group_arn}:log-stream:${data.aws_organizations_organization.current.id}_*"
  ]
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid = "AWSCloudTrailCreateLogStream"

    actions = [
      "logs:CreateLogStream",
    ]
    resources = flatten([
      local.log_streams,
    ])
  }
  statement {
    sid = "AWSCloudTrailPutLogEvents"

    actions = [
      "logs:PutLogEvents",
    ]
    resources = flatten([
      local.log_streams,
    ])
  }
}

module "iam_policy" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-policy?ref=89fe17a6549728f1dc7e7a8f7b707486dfb45d89"

  name        = "${local.prefix}-cloudtrail"
  description = "Policy to permit cloudtrail to write to cloudwatch logs"
  policy      = data.aws_iam_policy_document.cloudwatch.json
}

module "iam_assumable_role" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role?ref=89fe17a6549728f1dc7e7a8f7b707486dfb45d89"

  create_role       = true
  role_requires_mfa = false
  role_name         = "${local.prefix}-cloudtrail-cloudwatch-logs"
  trusted_role_services = [
    "cloudtrail.amazonaws.com"
  ]

  custom_role_policy_arns = [
    module.iam_policy.arn
  ]
}

module "log_group" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudwatch.git//modules/log-group?ref=235046ca1ff83ada5f9265583ed96c8b675b0468"

  name              = local.trail_name
  retention_in_days = 7
}

locals {
  trail_arn = (
    "arn:aws:cloudtrail:${data.aws_region.current.name}:${local.sensitive_account_id}:trail/${local.trail_name}"
  )
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AWSCloudTrailAclCheck"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        local.trail_arn
      ]
    }
  }

  statement {
    sid = "AWSCloudTrailWrite"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        local.trail_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  statement {
    sid = "AWSCloudTrailWriteOrg"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/AWSLogs/${data.aws_organizations_organization.current.id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        local.trail_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

# trunk-ignore(trivy)
module "s3_bucket" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=8a0b697adfbc673e6135c70246cff7f8052ad95a"

  bucket                  = local.bucket_name
  force_destroy           = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  attach_policy           = true
  policy                  = data.aws_iam_policy_document.bucket_policy.json
}

# trunk-ignore(checkov)
# trunk-ignore(trivy)
resource "aws_cloudtrail" "this" {
  name           = "${local.prefix}-cloudtrail"
  enable_logging = true

  s3_bucket_name             = module.s3_bucket.s3_bucket_id
  is_multi_region_trail      = true
  is_organization_trail      = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "${module.log_group.cloudwatch_log_group_arn}:*"
  cloud_watch_logs_role_arn  = module.iam_assumable_role.iam_role_arn
}
