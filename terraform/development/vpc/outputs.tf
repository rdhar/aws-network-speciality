output "bastion_hostname" {
  description = "DNS name of the bastion host"
  value       = "ec2-user@${aws_instance.a4l_bastion.public_dns}"
}

output "internal_host_ip" {
  description = "IP of the host deployed to private subnet"
  value       = "ec2-user@${aws_instance.a4l_internal.private_ip}"
}
