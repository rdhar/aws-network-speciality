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

variable "trusted_ips" {
  description = "Trusted IP addresses for bastion host access"
  type        = set(string)
}

variable "ssh_key" {
  description = "Trusted keys for bastion host access"
  type        = string
}
