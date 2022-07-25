provider "aws" {
  profile = "aws-net-spec-creds"
  region  = "us-east-1"

  default_tags {
    tags = {
      "Project"     = "aws-net-spec"
      "Environment" = "org"
      "Terraform"   = true
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.71.0"
    }
  }
  required_version = ">= 1.2.0"

  backend "remote" {
    organization = "3ware"
    workspaces {
      name = "aws-net-spec"
    }
  }
}
