# ---  loadbalancer/main.tf

resource "aws_lb" "test" {
  name            = "test-lb-tf"
  security_groups = [var.security_groups]
  subnets         = var.public_subnets
  idle_timeout    = 400
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  #vpc_id            = var.vpc_id
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }
  health_check {
    healthy_threshold   = var.lb_healthy_thresold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }

}
