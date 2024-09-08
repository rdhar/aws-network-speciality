# AWS Advanced Network VPC Peering Demo

Use this terraform code to create all the resources for the vpc peering demo. Please note that the peering connections are not enabled by default. You can toggle these on and off by adjusting the relevant variables.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_endpoints"></a> [endpoints](#module\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | ~> 3.14.0 |
| <a name="module_iam_assumable_role"></a> [iam\_assumable\_role](#module\_iam\_assumable\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | ~>5.2.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.14.0 |
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | grem11n/vpc-peering/aws | ~> 4.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_instance.a4l_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc"></a> [vpc](#input\_vpc) | A map of VPCs to create | <pre>map(object({<br>    cidr            = string<br>    azs             = list(string)<br>    private_subnets = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_vpc_peers"></a> [vpc\_peers](#input\_vpc\_peers) | A map of VPC peers to create | <pre>map(object({<br>    this_vpc_id = string<br>    that_vpc_id = string<br>    enabled     = bool<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rules_per_vpc"></a> [rules\_per\_vpc](#output\_rules\_per\_vpc) | Print the output of complex rule definition expressions |
| <a name="output_vpc_peers_enabled"></a> [vpc\_peers\_enabled](#output\_vpc\_peers\_enabled) | Print the VPC peers enabled |
<!-- END_TF_DOCS -->
