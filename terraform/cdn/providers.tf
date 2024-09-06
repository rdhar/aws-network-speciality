provider "aws" {
  profile = "ans-gen"
  region  = "us-east-1"

  default_tags {
    tags = {
      "3ware:project-id"       = "aws-network-speciality"
      "3ware:environment-type" = "dev"
      "3ware:service"          = "cdn"
      "3ware:tofu"             = true
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
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.2"
    }
  }

  cloud {
    organization = "3ware"
    hostname     = "app.terraform.io"
    workspaces {
      name = "aws-net-spec-cdn"
    }
  }
}
