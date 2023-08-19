# Route table to route public instance to the internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.name.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = local.tags
}

# Route table to route private instance to the nat-gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.name.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }


  tags = local.tags
}

# explicit association of public subnet to public route table
resource "aws_route_table_association" "pubrt_asociation" {
  for_each = aws_subnet.public_subnet
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public.id
}

# explicit association of private subnet to private route table
resource "aws_route_table_association" "privrt_asociation" {
  for_each = aws_subnet.private_subnet
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private.id
}