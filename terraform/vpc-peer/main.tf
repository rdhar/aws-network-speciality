locals {
  admin_port     = 22
  vpc_short_name = { for vpc, v in var.vpc : vpc => upper(trimprefix(vpc, "a4l-")) }
  ingress_rules = [
    {
      description = "ipv4",
      protocol    = "tcp",
      port        = local.admin_port,
      cidr_blocks = ["0.0.0.0/0"],
    },
    {
      description      = "ipv6",
      protocol         = "tcp",
      port             = local.admin_port,
      ipv6_cidr_blocks = ["::/0"]

    },
    #* Cannot use self due to bug in AWS provider
    #* https://github.com/hashicorp/terraform-provider-aws/issues/19179
    # {
    #   description = "self",
    #   from_port   = 0,
    #   to_port     = 0,
    #   protocol    = -1,
    #   self        = true
    # },
  ]
  #* https://stackoverflow.com/questions/58343258/iterate-over-nested-data-with-for-for-each-at-resource-level
  ingress_rules_per_vpc = flatten([
    for vpc_name, v in var.vpc : [
      for ingress_rules in local.ingress_rules : {
        description      = "${vpc_name}-${ingress_rules.description}-${ingress_rules.protocol}-${ingress_rules.port}"
        vpc_name         = vpc_name
        protocol         = ingress_rules.protocol
        port             = ingress_rules.port
        cidr_blocks      = try(ingress_rules.cidr_blocks, [])
        ipv6_cidr_blocks = try(ingress_rules.ipv6_cidr_blocks, [])
      }
    ]
  ])
}

resource "random_string" "random" {
  for_each  = var.vpc
  length    = 13
  special   = false
  min_upper = 13
}

module "vpc" {
  for_each = var.vpc
  source   = "terraform-aws-modules/vpc/aws"
  version  = "~> 3.14.0"

  name = each.key

  cidr            = each.value.cidr
  azs             = each.value.azs
  private_subnets = each.value.private_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "endpoints" {
  for_each = var.vpc
  source   = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version  = "~> 3.14.0"

  vpc_id = module.vpc[each.key].vpc_id

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc[each.key].private_subnets
      security_group_ids  = [aws_security_group.this[each.key].id]
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc[each.key].private_subnets
      security_group_ids  = [aws_security_group.this[each.key].id]
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.vpc[each.key].private_subnets
      security_group_ids  = [aws_security_group.this[each.key].id]
    },
  }
}

#* This combined with the stackoverflow link in locals gives a good description of this functionality
#* https://dev.to/kernelpanicaus/safer-handling-of-resource-multiplicity-in-terraform-2ked
resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in local.ingress_rules_per_vpc : "${rule.description}-${rule.protocol}" => rule
  }
  type              = "ingress"
  from_port         = lookup(each.value, "port")
  to_port           = lookup(each.value, "port")
  protocol          = lookup(each.value, "protocol")
  cidr_blocks       = lookup(each.value, "cidr_blocks", [])
  ipv6_cidr_blocks  = lookup(each.value, "ipv6_cidr_blocks", [])
  security_group_id = aws_security_group.this[each.value.vpc_name].id
}


#* Seperate self rule required due to bug in AWS terraform provider. See link in locals
resource "aws_security_group_rule" "self" {
  for_each          = var.vpc
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.this[each.key].id
}

resource "aws_security_group_rule" "egress" {
  for_each          = var.vpc
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this[each.key].id
}

resource "aws_security_group" "this" {
  for_each    = var.vpc
  name        = "A4LPEERING-${local.vpc_short_name[each.key]}SecurityGroup-${random_string.random[each.key].result}"
  description = "Enable SSH access via port 22 IPv4 & v6"
  vpc_id      = module.vpc[each.key].vpc_id

  #* Disabling this due to bug with dynamic content in tags
  #* https://github.com/hashicorp/terraform-provider-aws/issues/19583#issuecomment-1125728202
  # tags = {
  #   Name = "A4LPEERING-${local.vpc_short_name[each.key]}SecurityGroup-${random_string.random[each.key].result}"
  # }
}

module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~>5.2.0"

  role_name               = "A4LPEERING-EC2Role"
  create_role             = true
  create_instance_profile = true
  role_requires_mfa       = false

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]
}

#* Inline policy not currently supported in the iam_assumable_role module so using seperate resource for now
#* https://github.com/terraform-aws-modules/terraform-aws-iam/issues/261
resource "aws_iam_role_policy" "inline_policy" {
  name   = "inline_policy"
  role   = module.iam_assumable_role.iam_role_name
  policy = data.aws_iam_policy_document.ec2_role.json
}

#! tfsec:ignore:aws-ec2-enable-at-rest-encryption #! tfsec:ignore:aws-ec2-enforce-http-token-imds
resource "aws_instance" "a4l_peering" {
  for_each               = var.vpc
  ami                    = "ami-0cabc39acf991f4f1"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc[each.key].private_subnets[0]
  vpc_security_group_ids = [aws_security_group.this[each.key].id]
  iam_instance_profile   = module.iam_assumable_role.iam_instance_profile_name

  tags = {
    Name = "A4L-EC2${local.vpc_short_name[each.key]}"
  }
}
