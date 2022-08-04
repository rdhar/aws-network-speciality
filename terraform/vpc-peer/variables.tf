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
