resource "aws_internet_gateway" "rs-igw" {
  vpc_id = var.vpc_id
}