resource "aws_lb" "this" {
  name            = "Contree-ALB"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = merge(local.common_tags, { Name = "Contree ALB" })
}

resource "aws_lb_target_group" "this" {
  name     = "contree-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.this.id

  health_check {
    path              = "/api/v1/healthcheck"
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
