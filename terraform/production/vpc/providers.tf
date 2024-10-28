provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "3ware:project-id"           = "aws-network-speciality"
      "3ware:environment"          = var.environment
      "3ware:service"              = var.service
      "3ware:managed-by-terraform" = true
      "3ware:workspace"            = terraform.workspace
    }
  }
}
