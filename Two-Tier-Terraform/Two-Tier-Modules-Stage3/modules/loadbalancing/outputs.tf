# ----- modules/loadbalancing/outputs.tf
output "lb_target_group_arn" {
  value = aws_lb_target_group.project_lb_tg.arn
}

output "lb_endpoint" {
  value = aws_lb.project_lb.dns_name
}
