# ----- root/outputs.tf-----------

output "PublicIP" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.project_front_end[*].public_ip
}


output "ALB_DNS" {
  description = "The ALBs DNS"
  value       = aws_lb.project_lb.dns_name
}
