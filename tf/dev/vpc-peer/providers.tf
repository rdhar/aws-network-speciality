provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      "3ware:project-id"       = "aws-network-speciality"
      "3ware:environment-type" = "dev"
      "3ware:service"          = "vpc-peer"
      "3ware:tofu"             = true
    }
  }
}

terraform {
  required_version = ">= 1.8.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
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
      name = "aws-net-spec-vpc-peer"
    }
  }
}
