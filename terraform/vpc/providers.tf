provider "aws" {
  profile = "ans-gen"
  region  = "us-east-1"

  default_tags {
    tags = {
      "Project"     = "aws-network-specialty"
      "Environment" = "general"
      "Demo"        = "VPC"
      "Terraform"   = true
    }
  }
}

terraform {
  required_version = ">= 1.7.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.71.0"
    }
  }

  backend "remote" {
    organization = "3ware"
    workspaces {
      name = "aws-net-spec-vpc"
    }
  }
}
