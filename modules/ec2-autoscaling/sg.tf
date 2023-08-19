# Create security group for the Instance
resource "aws_security_group" "ec2-sg" {
    name = "${var.project}-lb-SG"
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.ssh_ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = var.allowed_cidrs
        }
    
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }    
}

resource "aws_security_group_rule" "allow_lb_sg" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  source_security_group_id = var.source_security_group_id
  security_group_id = aws_security_group.ec2-sg.id
}