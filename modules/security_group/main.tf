resource "aws_security_group" "allow-web" {
  description = "Allow web"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow all Http Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] // since its a webserver allow all the traffic
  }
  //TODO: For debugging purposes. Will remove 
  ingress {
    description      = "Allow all ssh Traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" // all the protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.name
  }
}