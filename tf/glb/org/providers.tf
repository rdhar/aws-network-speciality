provider "aws" {
  #profile = "3ware-org-admin"
  region = "us-east-1"
  default_tags {
    tags = {
      "3ware:project-id"      = "aws-network-speciality"
      "3ware:environment"     = "glb"
      "3ware:service"         = "org"
      "3ware:managed-by-tofu" = true
    }
  }
}
terraform {
  required_version = ">= 1.8.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }

  cloud {
    organization = "3ware"
    hostname     = "app.terraform.io"
    workspaces {
      name = "aws-net-spec-org"
    }
  }
}
