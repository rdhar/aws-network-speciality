variable "environment" {
  description = "(Required) The AWS environment to deploy resources to"
  type        = string
  default     = "development"
  nullable    = false
}

variable "service" {
  description = "(Required) The AWS service being deployed"
  type        = string
  default     = "vpc"
  nullable    = false
}

# variable "trusted_ips" {
#   description = "Trusted IP addresses for bastion host access"
#   type        = set(string)
# }

# variable "ssh_key" {
#   description = "Trusted keys for bastion host access"
#   type        = string
# }
