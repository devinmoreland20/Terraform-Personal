#    loadbalancing/output
output "lb_target_group_arn" {
  value = aws_lb_target_group.test.arn
}
