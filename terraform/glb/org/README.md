# AWS Advanced Network CloudTrail Demo

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.8.2 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.0.0 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 5.66.0  |

## Modules

| Name                                                                                      | Source                                                                                          | Version                                  |
| ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ---------------------------------------- |
| <a name="module_iam_assumable_role"></a> [iam_assumable_role](#module_iam_assumable_role) | git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role | 89fe17a6549728f1dc7e7a8f7b707486dfb45d89 |
| <a name="module_iam_policy"></a> [iam_policy](#module_iam_policy)                         | git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-policy         | 89fe17a6549728f1dc7e7a8f7b707486dfb45d89 |
| <a name="module_log_group"></a> [log_group](#module_log_group)                            | git::https://github.com/terraform-aws-modules/terraform-aws-cloudwatch.git//modules/log-group   | 235046ca1ff83ada5f9265583ed96c8b675b0468 |
| <a name="module_s3_bucket"></a> [s3_bucket](#module_s3_bucket)                            | git::https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git                       | 8a0b697adfbc673e6135c70246cff7f8052ad95a |

## Resources

| Name                                                                                                                                                | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail)                                       | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                       | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)         | data source |
| [aws_iam_policy_document.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |
| [aws_organizations_organization.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                         | data source |

## Inputs

No inputs.

## Outputs

No outputs.

<!-- END_TF_DOCS -->
