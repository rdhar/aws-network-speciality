terraform {
  # Must be above 1.9.0 to allow cross-object referencing for input variable validations
  required_version = ">=1.9.0, <2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.69.0"
    }
  }
  cloud {
    organization = "3ware"

    workspaces {
      name    = "vpc-us-east-1-development"
      project = "aws-network-speciality"
    }
  }
}
