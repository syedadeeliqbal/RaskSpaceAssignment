terraform {
  required_version = ">=0.15"
}

resource "aws_vpc" "rs-main-vpc" {
  cidr_block = var.cidr

  tags = {
    type = var.tag
    Name = "RS Main Subnet"
  }
}