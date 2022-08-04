# ------------- root/outputs.tf

output "PublicIP" {
  description = "Public IP of EC2 instance"
  value       = module.compute.instance_public_ip
}

output "ALB_DNS" {
  description = "The ALBs DNS"
  value       = module.loadbalancing
}

