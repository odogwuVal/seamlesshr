# Create a new load balancer
resource "aws_lb" "bar" {
  name               = "${var.project}-lb"
  internal = var.internal == "true" ? true : false
  load_balancer_type = var.load_balancer_type == "" ? "application" : var.load_balancer_type
  security_groups = [var.security_groups]
  subnets = var.lb_subnets
  # [ for subnet in aws_subnet.public_subnet : subnet.id ]

  tags = local.tags
}

# create a target group
resource "aws_lb_target_group" "test" {
  name     = "${var.project}-lb-tg"
  port     = var.target_port == "" ? 80 : var.target_port
  protocol = var.target_protocol == "" ? "HTTP" : var.target_protocol
  vpc_id   = var.vpc_id
}

#create a listener on HTTPS
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.bar.arn
  port              = var.listener_port == "" ? "443" : var.listener_port
  protocol          = var.listener_protocol == "" ? "HTTPS" : var.listener_protocol
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  # "arn:aws:acm:us-east-1:651611223190:certificate/16b08c07-e93a-43f2-a88c-6000abb1f40c"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

# redirect HTTP to HTTPS
resource "aws_lb_listener" "front_end_redirect" {
  load_balancer_arn = aws_lb.bar.arn
  port              = var.target_port == "" ? 80 : var.target_port
  protocol          = var.target_protocol == "" ? "HTTP" : var.target_protocol
  
  default_action {
    type             = "redirect"
    
    redirect {
      port = var.listener_port == "" ? "443" : var.listener_port
      protocol = var.listener_protocol == "" ? "HTTPS" : var.listener_protocol
      status_code = "HTTP_301"
    }
  }
}

