resource "aws_lb" "lamp_web" {
  name                       = "lamp-web"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lamp_alb.id]
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false
  internal                   = false
}

resource "aws_alb_target_group" "lamp_web" {
  name        = "lamp-web"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "4"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.lamp_web.id
  port              = 80
  protocol          = "HTTP"

/*
  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
*/
  default_action {
    target_group_arn = aws_alb_target_group.lamp_web.id
    type             = "forward"
  }

}

/*
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.lamp_web.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
//  certificate_arn = var.alb_tls_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.lamp_web.id
    type             = "forward"
  }
}
*/