# Create two public subnets
resource "aws_subnet" "public_subnet" {
    for_each = var.public-subnets
    vpc_id = aws_vpc.name.id
    cidr_block = each.value["cidr"]
    availability_zone_id = each.value["az"]

    tags = {
      "Name" = "${each.key}"
    }
}

# Create two private subnets
resource "aws_subnet" "private_subnet" {
    for_each = var.private-subnets
    vpc_id = aws_vpc.name.id
    cidr_block = each.value["cidr"]
    availability_zone_id = each.value["az"]

    tags = {
      "Name" = "${each.key}"
    }
}