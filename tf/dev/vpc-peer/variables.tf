variable "environment" {
  description = "The AWS environment to deploy resources to"
  type        = string
  default     = "dev"
  nullable    = false

  validation {
    condition     = contains(["dev", "prd"], var.environment)
    error_message = "Invalid environment specified. Valid values are: \"dev\" and \"prd\""
  }
}

variable "service" {
  description = "The AWS service being deployed"
  type        = string
  nullable    = false
}

variable "vpc" {
  description = "A map of VPCs to create"
  type = map(object({
    cidr            = string
    azs             = list(string)
    private_subnets = list(string)
  }))
}

variable "vpc_peers" {
  description = "A map of VPC peers to create"
  type = map(object({
    this_vpc_id = string
    that_vpc_id = string
    enabled     = bool
  }))
}
