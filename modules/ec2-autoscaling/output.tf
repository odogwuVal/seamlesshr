output "lb_arn" {
  value = aws_lb.bar.id
  description = "arn of the alb"
}

output "lb_name" {
  value = aws_lb.bar.dns_name
  description = "dns name of the alb"
}