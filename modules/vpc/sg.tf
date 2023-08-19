# Create security group for the load balancer
resource "aws_security_group" "lb-sg" {
    name = "${var.project}-lb-SG"
    vpc_id = aws_vpc.name.id

    dynamic "ingress" {
        for_each = var.lg_ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]
        }
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }    
}