output "rules_per_vpc" {
  description = "Print the output of complex rule definition expressions"
  value       = local.ingress_rules_per_vpc
}

output "vpc_peers_enabled" {
  description = "Print the VPC peers enabled"
  value       = local.vpc_peers_enabled
}
