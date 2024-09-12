locals {
  admin_port = 22
}
# trunk-ignore(trivy/AVD-AWS-0178): Flow log not required as demo vpc
module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=e226cc15a7b8f62fd0e108792fea66fa85bcb4b9"

  name = "a4l-vpc1"
  azs  = ["us-east-1a", "us-east-1b", "us-east-1c"]

  cidr = "10.16.0.0/16"
  #reserved = ["10.16.0.0/20", "10.16.64.0/20", "10.16.128.0/20"]
  public_subnets   = ["10.16.48.0/20", "10.16.112.0/20", "10.16.176.0/20"]
  private_subnets  = ["10.16.32.0/20", "10.16.96.0/20", "10.16.160.0/20"]
  database_subnets = ["10.16.16.0/20", "10.16.80.0/20", "10.16.144.0/20"]

  enable_ipv6                                     = true
  public_subnet_assign_ipv6_address_on_creation   = true
  private_subnet_assign_ipv6_address_on_creation  = true
  database_subnet_assign_ipv6_address_on_creation = true
  public_subnet_ipv6_prefixes                     = [3, 7, 11]
  private_subnet_ipv6_prefixes                    = [2, 6, 10] #! 0A Hex to 10 Decimal
  database_subnet_ipv6_prefixes                   = [1, 5, 9]

  create_igw             = true
  create_egress_only_igw = false
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Use for_each to create security group rules to avoid creation of duplicate rules
# If 2 CIDRs are supplied, the provider creates 2 rules as you can only have 1 CIDR per rule
# Any CRUD operations where a CIDR is changed could fail because of duplicate values
# It is simpler to create 1 rule resource per CIDR block using for_each
resource "aws_security_group_rule" "bastion_ingress" {
  for_each          = var.trusted_ips
  description       = "Inbound traffic to bastion hosts"
  type              = "ingress"
  from_port         = local.admin_port
  to_port           = local.admin_port
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = [each.value]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "bastion_egress" {
  for_each          = toset(module.vpc.private_subnets_cidr_blocks)
  description       = "Outbound traffic private subnets"
  type              = "egress"
  from_port         = local.admin_port
  to_port           = local.admin_port
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = [each.value]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "bastion" {
  name        = "A4L-BASTION"
  description = "Security Group for A4L Bastion Host"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "A4L-BASTION"
  }

  # Ensure any "recreate" changes don't disrupt service
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "internal_ingress" {
  description              = "Inbound traffic to internal hosts"
  type                     = "ingress"
  from_port                = local.admin_port
  to_port                  = local.admin_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.internal.id
  source_security_group_id = aws_security_group.bastion.id

  lifecycle {
    create_before_destroy = true
  }
}

# trunk-ignore(trivy/AVD-AWS-0104): Egress rule
resource "aws_security_group_rule" "internal_egress" {
  description       = "Outbound traffic from internal hosts"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  security_group_id = aws_security_group.internal.id
  cidr_blocks       = ["0.0.0.0/0"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "internal" {
  name        = "A4L-INTERNAL"
  description = "Security Group for A4L internal Host"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "A4L-INTERNAL"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "a4l" {
  key_name   = "A4L"
  public_key = var.ssh_key
}

# trunk-ignore(trivy)
# trunk-ignore(checkov)
resource "aws_instance" "a4l_bastion" {
  ami                         = "ami-033b95fb8079dc481"
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = aws_key_pair.a4l.key_name

  tags = {
    Name = "A4L-BASTION"
  }
}

# trunk-ignore(trivy)
# trunk-ignore(checkov)
resource "aws_instance" "a4l_internal" {
  ami                    = "ami-033b95fb8079dc481"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[1]
  vpc_security_group_ids = [aws_security_group.internal.id]
  key_name               = aws_key_pair.a4l.key_name

  tags = {
    Name = "A4L-INTERNAL-TEST"
  }
}
