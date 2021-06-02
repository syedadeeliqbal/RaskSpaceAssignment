resource "aws_route_table" "rs-igw-rt" {
  vpc_id = var.vpc_id

  # route {
  #   ipv6_cidr_block = "::/0"
  #   gateway_id      = var.igw_id
  # }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "Public Subnet routetable for VPC"
  }
}