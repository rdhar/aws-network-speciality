variable "trusted_ips" {
  description = "Trusted IP addresses for bastion host access"
  type        = list(string)
}

variable "ssh_key" {
  description = "Trusted keys for bastion host access"
  type        = string
}
