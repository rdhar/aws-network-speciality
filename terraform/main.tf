locals {
  admin_port = 22
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.12.0"

  name = "a4l-vpc1"
  azs  = ["us-east-1a", "us-east-1b", "us-east-1c"]

  cidr = "10.16.0.0/16"
  #reserved = ["10.16.0.0/20", "10.16.64.0/20", "10.16.128.0/20"]
  public_subnets   = ["10.16.48.0/20", "10.16.112.0/20", "10.16.176.0/20"]
  private_subnets  = ["10.16.32.0/20", "10.16.96.0/20", "10.16.160.0/20"]
  database_subnets = ["10.16.16.0/20", "10.16.80.0/20", "10.16.144.0/20"]

  enable_ipv6                     = true
  assign_ipv6_address_on_creation = true
  public_subnet_ipv6_prefixes     = [3, 7, 11]
  private_subnet_ipv6_prefixes    = [2, 6, 10] #! 0A Hex to 10 Decimal
  database_subnet_ipv6_prefixes   = [1, 5, 9]

  create_igw             = true
  create_egress_only_igw = false
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}


resource "aws_security_group_rule" "bastion_ingress" {
  description       = "Inbound traffic to bastion hosts"
  type              = "ingress"
  from_port         = local.admin_port
  to_port           = local.admin_port
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = var.trusted_ips
}

resource "aws_security_group_rule" "bastion_egress" {
  description       = "Outbound traffic private subnets"
  type              = "egress"
  from_port         = local.admin_port
  to_port           = local.admin_port
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = module.vpc.private_subnets_cidr_blocks
}

resource "aws_security_group" "bastion" {
  name        = "A4L-BASTION"
  description = "Security Group for A4L Bastion Host"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "A4L-BASTION"
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
}

resource "aws_security_group_rule" "internal_egress" {
  description       = "Outbound traffic from internal hosts"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  security_group_id = aws_security_group.internal.id
  cidr_blocks       = ["0.0.0.0/0"] #! tfsec:ignore:aws-vpc-no-public-egress-sgr
}

resource "aws_security_group" "internal" {
  name        = "A4L-INTERNAL"
  description = "Security Group for A4L internal Host"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "A4L-INTERNAL"
  }
}

resource "aws_key_pair" "a4l" {
  key_name   = "A4L"
  public_key = var.ssh_key
}

#! tfsec:ignore:aws-ec2-enable-at-rest-encryption #! tfsec:ignore:aws-ec2-enforce-http-token-imds
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

#! tfsec:ignore:aws-ec2-enforce-http-token-imds #! tfsec:ignore:aws-ec2-enable-at-rest-encryption
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
