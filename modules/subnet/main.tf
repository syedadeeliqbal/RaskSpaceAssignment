resource "aws_subnet" "rs-subnet" {
   vpc_id = var.vpc_id
   cidr_block = var.cidr
   availability_zone = var.az

  tags = {
    Name = var.tag
  }
}