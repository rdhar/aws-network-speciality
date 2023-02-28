# AWS Advanced Network Terraform Module

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.2.0  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.71.0 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 4.23.0  |

## Modules

| Name                                         | Source                        | Version   |
| -------------------------------------------- | ----------------------------- | --------- |
| <a name="module_vpc"></a> [vpc](#module_vpc) | terraform-aws-modules/vpc/aws | ~> 3.12.0 |

## Resources

| Name                                                                                                                                        | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_instance.a4l_bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                            | resource |
| [aws_instance.a4l_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                           | resource |
| [aws_key_pair.a4l](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)                                    | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                    | resource |
| [aws_security_group.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                   | resource |
| [aws_security_group_rule.bastion_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)   | resource |
| [aws_security_group_rule.bastion_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)  | resource |
| [aws_security_group_rule.internal_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)  | resource |
| [aws_security_group_rule.internal_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name                                                               | Description                                  | Type           | Default | Required |
| ------------------------------------------------------------------ | -------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_ssh_key"></a> [ssh_key](#input_ssh_key)             | Trusted keys for bastion host access         | `string`       | n/a     |   yes    |
| <a name="input_trusted_ips"></a> [trusted_ips](#input_trusted_ips) | Trusted IP addresses for bastion host access | `list(string)` | n/a     |   yes    |

## Outputs

| Name                                                                                | Description                               |
| ----------------------------------------------------------------------------------- | ----------------------------------------- |
| <a name="output_bastion_hostname"></a> [bastion_hostname](#output_bastion_hostname) | DNS name of the bastion host              |
| <a name="output_internal_host_ip"></a> [internal_host_ip](#output_internal_host_ip) | IP of the host deployed to private subnet |

<!-- END_TF_DOCS -->
