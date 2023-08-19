# Create a new load balancer
resource "aws_lb" "bar" {
  name               = "${var.project}-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.lb-sg.id ]
  subnets = [ for subnet in aws_subnet.public_subnet : subnet.id ]

  tags = local.tags
}

# create a target group
resource "aws_lb_target_group" "test" {
  name     = "${var.project}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.name.id
}

#create a listener on HTTPS
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.bar.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:651611223190:certificate/16b08c07-e93a-43f2-a88c-6000abb1f40c"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

# redirect HTTP to HTTPS
resource "aws_lb_listener" "front_end_redirect" {
  load_balancer_arn = aws_lb.bar.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "redirect"
    
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

