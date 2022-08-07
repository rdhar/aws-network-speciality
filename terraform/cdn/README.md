# AWS Advanced Network Specialty CDN Demo

This module has 3 input variables which create the resources in stages to follow the steps in the demo.

The default values ensure only the S3 bucket is created initially with the required contents uploaded.

To proceed to the next stage of the demo, `enable_cloudfront` can be set to true in `cdn.auto.tfvars`.

Similarly adding a `demo_domain_name` will create an ACM Certificate, DNS records, and update the `viewer_certificate` accordingly.

Finally, setting `secure_s3_bucket` to `true` will create the origin access identity and update the bucket policy.

There is an open [issue](#8) to try and make the OAI to CloudFront association dynamic based on the value of `secure_s3_bucket`. To complete the demo, the `s3_origin_config` must be uncommented.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.71.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.24.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 4.0.1 |
| <a name="module_cdn"></a> [cdn](#module\_cdn) | terraform-aws-modules/cloudfront/aws | ~> 2.9.3 |
| <a name="module_cname_record"></a> [cname\_record](#module\_cname\_record) | terraform-aws-modules/route53/aws//modules/records | ~> 2.9.0 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> v3.3.0 |
| <a name="module_s3_bucket_object"></a> [s3\_bucket\_object](#module\_s3\_bucket\_object) | terraform-aws-modules/s3-bucket/aws//modules/object | ~> v3.3.0 |
| <a name="module_template_files"></a> [template\_files](#module\_template\_files) | hashicorp/dir/template | ~> v1.0.2 |

## Resources

| Name | Type |
|------|------|
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_cloudfront_cache_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_policy_combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_policy_with_oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.demo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_demo_domain_name"></a> [demo\_domain\_name](#input\_demo\_domain\_name) | Route53 domain name registered for the demo | `string` | `null` | no |
| <a name="input_enable_cloudfront"></a> [enable\_cloudfront](#input\_enable\_cloudfront) | Feature toggle for the cloudfront distribution | `bool` | `false` | no |
| <a name="input_secure_s3_bucket"></a> [secure\_s3\_bucket](#input\_secure\_s3\_bucket) | Set to true to restrict access to the S3 bucket to the CloudFront OAI | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alternate_cname"></a> [alternate\_cname](#output\_alternate\_cname) | The CNAME records associated with CloudFront |
| <a name="output_certificat_arn"></a> [certificat\_arn](#output\_certificat\_arn) | The arn of the ACM certificate |
| <a name="output_cloudfront_url"></a> [cloudfront\_url](#output\_cloudfront\_url) | The CloudFront distribution domain name |
| <a name="output_s3_website_url"></a> [s3\_website\_url](#output\_s3\_website\_url) | The S3 Bucket website endpoint |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
