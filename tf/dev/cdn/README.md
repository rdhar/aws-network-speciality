# AWS Advanced Network Specialty CDN Demo

This module has 3 input variables which create the resources in stages to follow the steps in the demo.

The default values ensure only the S3 bucket is created initially with the required contents uploaded.

To proceed to the next stage of the demo, `enable_cloudfront` can be set to true in `cdn.auto.tfvars`.

Similarly adding a `demo_domain_name` will create an ACM Certificate, DNS records, and update the `viewer_certificate` accordingly.

Finally, setting `secure_s3_bucket` to `true` will create the origin access identity and update the bucket policy.

There is an open [issue](https://github.com/3ware/aws-network-speciality/issues/8) to try and make the OAI to CloudFront association dynamic based on the value of `secure_s3_bucket`. To complete the demo, the `s3_origin_config` must be uncommented.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.8.2  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.40.0 |
| <a name="requirement_random"></a> [random](#requirement_random)          | ~> 3.3.2  |

## Providers

| Name                                                      | Version   |
| --------------------------------------------------------- | --------- |
| <a name="provider_aws"></a> [aws](#provider_aws)          | >= 4.40.0 |
| <a name="provider_random"></a> [random](#provider_random) | ~> 3.3.2  |

## Modules

| Name                                                                                | Source                                                                                    | Version                                  |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------- |
| <a name="module_acm"></a> [acm](#module_acm)                                        | git::https://github.com/terraform-aws-modules/terraform-aws-acm.git                       | 0ca52d1497e5a54ed86f9daac0440d27afc0db8b |
| <a name="module_cdn"></a> [cdn](#module_cdn)                                        | git::https://github.com/terraform-aws-modules/terraform-aws-cloudfront.git                | a0f0506106a4c8815c1c32596e327763acbef2c2 |
| <a name="module_cname_record"></a> [cname_record](#module_cname_record)             | git::https://github.com/terraform-aws-modules/terraform-aws-route53.git//modules/records  | 32613266e7c1f2a3e4e7cd7d5808e31df8c0b81d |
| <a name="module_s3_bucket"></a> [s3_bucket](#module_s3_bucket)                      | git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git                 | 8a0b697adfbc673e6135c70246cff7f8052ad95a |
| <a name="module_s3_bucket_object"></a> [s3_bucket_object](#module_s3_bucket_object) | git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git//modules/object | 8a0b697adfbc673e6135c70246cff7f8052ad95a |
| <a name="module_template_files"></a> [template_files](#module_template_files)       | git::https://github.com/hashicorp/terraform-template-dir.git                              | 556bd64989e7099fabb90c6b883b5d4d92da3ae8 |

## Resources

| Name                                                                                                                                                 | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                        | resource    |
| [aws_cloudfront_cache_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy)           | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)          | data source |
| [aws_iam_policy_document.bucket_policy_combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_policy_with_oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.demo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone)                                 | data source |

## Inputs

| Name                                                                                 | Description                                                           | Type     | Default | Required |
| ------------------------------------------------------------------------------------ | --------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_demo_domain_name"></a> [demo_domain_name](#input_demo_domain_name)    | Route53 domain name registered for the demo                           | `string` | `null`  |    no    |
| <a name="input_enable_cloudfront"></a> [enable_cloudfront](#input_enable_cloudfront) | Feature toggle for the cloudfront distribution                        | `bool`   | `false` |    no    |
| <a name="input_secure_s3_bucket"></a> [secure_s3_bucket](#input_secure_s3_bucket)    | Set to true to restrict access to the S3 bucket to the CloudFront OAI | `bool`   | `false` |    no    |

## Outputs

| Name                                                                             | Description                                  |
| -------------------------------------------------------------------------------- | -------------------------------------------- |
| <a name="output_alternate_cname"></a> [alternate_cname](#output_alternate_cname) | The CNAME records associated with CloudFront |
| <a name="output_certificat_arn"></a> [certificat_arn](#output_certificat_arn)    | The arn of the ACM certificate               |
| <a name="output_cloudfront_url"></a> [cloudfront_url](#output_cloudfront_url)    | The CloudFront distribution domain name      |
| <a name="output_s3_website_url"></a> [s3_website_url](#output_s3_website_url)    | The S3 Bucket website endpoint               |

<!-- END_TF_DOCS -->
