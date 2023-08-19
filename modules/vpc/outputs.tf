output "vpc_id" {
  value = aws_vpc.name.id
  description = "vpc id"
}

output "private_subnet_id" {
  value = values(aws_subnet.private_subnet)[*].id
  description = "private subnet id"
}

output "public_subnet_id" {
  value = values(aws_subnet.public_subnet)[*].id
  description = "public subnet id"
}

output "sg_id" {
  value = aws_security_group.lb-sg.id
  description = "security group id"
}
