resource "aws_vpc" "name" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"

  tags = local.tags
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.name.id
  # tags = local.tags
}

resource "aws_eip" "nat" {
  vpc = true
  tags = local.tags
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet["pub-subnet-a"].id

  tags = local.tags

  depends_on = [
    aws_internet_gateway.igw
  ]
}
