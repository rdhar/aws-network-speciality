# AWS Advanced Network Terraform Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9.0, <2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.69.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.69.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git | e226cc15a7b8f62fd0e108792fea66fa85bcb4b9 |

## Resources

| Name | Type |
|------|------|
| [aws_instance.a4l_bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.a4l_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.a4l](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.bastion_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The AWS environment to deploy resources to | `string` | `"development"` | no |
| <a name="input_service"></a> [service](#input\_service) | (Required) The AWS service being deployed | `string` | `"vpc"` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | Trusted keys for bastion host access | `string` | n/a | yes |
| <a name="input_trusted_ips"></a> [trusted\_ips](#input\_trusted\_ips) | Trusted IP addresses for bastion host access | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_hostname"></a> [bastion\_hostname](#output\_bastion\_hostname) | DNS name of the bastion host |
| <a name="output_internal_host_ip"></a> [internal\_host\_ip](#output\_internal\_host\_ip) | IP of the host deployed to private subnet |
<!-- END_TF_DOCS -->
