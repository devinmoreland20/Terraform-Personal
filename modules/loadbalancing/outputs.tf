#    loadbalancing/output
output "lb_target_group_arn" {
  value = aws_lb_target_group.test.arn
}

output "lb_endpoint" {
  value = aws_lb.test.dns_name
}

