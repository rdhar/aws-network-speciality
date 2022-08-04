locals {
  vpc_peers_enabled = (
    { for peer in var.vpc_peers : "${peer.this_vpc_id}-${peer.that_vpc_id}" => peer if peer.enabled }
  )
}

module "vpc_peering" {
  for_each = local.vpc_peers_enabled
  source   = "grem11n/vpc-peering/aws"
  version  = "~> 4.1.0"

  providers = {
    aws.this = aws
    aws.peer = aws
  }

  this_vpc_id = module.vpc["${each.value.this_vpc_id}"].vpc_id
  peer_vpc_id = module.vpc["${each.value.that_vpc_id}"].vpc_id

  auto_accept_peering = true
}

#* The VPC peering must be active prior to adding the security group rule
# resource "aws_security_group_rule" "icmp" {
#   for_each  = local.vpc_peers_enabled
#   type      = "ingress"
#   protocol  = "icmp"
#   from_port = 8
#   to_port   = 0
#   #* Same region can use source_security_group
#   source_security_group_id = aws_security_group.this["${each.value.this_vpc_id}"].id
#   security_group_id        = aws_security_group.this["${each.value.that_vpc_id}"].id
# }
