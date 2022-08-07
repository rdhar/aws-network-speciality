provider "aws" {
  profile = "ans-gen"
  region  = "us-east-1"

  default_tags {
    tags = {
      "Project"     = "aws-network-specialty"
      "Environment" = "general"
      "Demo"        = "CDN"
      "Terraform"   = true
    }
  }
}

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.71.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.2"
    }
  }

  backend "remote" {
    organization = "3ware"
    workspaces {
      name = "aws-net-spec-cdn"
    }
  }
}
