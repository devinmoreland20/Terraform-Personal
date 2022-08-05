# ------------- root/outputs.tf

output "PublicIP" {
  description = "Public IP of EC2 instance"
  value       = module.compute.instance_public_ip
}

output "ALB_DNS" {
  description = "The ALBs DNS"
  value       = module.loadbalancing
}

output "BastionIP" {
  description = "Public IP of Bastion instance"
  value       = module.compute.instance_bastion_ip
}

output "privateIP" {
  description = "private IP of EC2 instance"
  value       = module.compute.instance_private_ip
}

output "database_endpoint" {
  description = "endpoint of database"
  value       = module.database.database_endpoint
}
