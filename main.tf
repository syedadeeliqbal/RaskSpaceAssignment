provider "aws" {
  region = "ca-central-1"
  access_key = "AKIAY7OQN23IYLZFG735"
  secret_key = "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"
}

// 1. Create VPC
module "rs-main-vpc" {
  source = "./modules/vpc"
  cidr   = var.cidr-main-vpc
}

//2. Create Internet Gateway
module "rs-igw" {
  source = "./modules/igw"

  vpc_id = module.rs-main-vpc.instance_id
}

//3.a Create Subnet 1
module "rs-subnet-1" {
  source = "./modules/subnet"

  name   = "RS Pub Subnet 1"
  vpc_id = module.rs-main-vpc.instance_id
  cidr   = "10.0.1.0/24"
  az     = var.default_az-1
}

//3.b Create Subnet 2  
module "rs-subnet-2" {
  source = "./modules/subnet"

  name   = "RS Pub Subnet 2"
  vpc_id = module.rs-main-vpc.instance_id
  cidr   = "10.0.2.0/24"
  az     = var.default_az-2
}

//4. Route table
module "vpc-igw-rt" {
  source = "./modules/igw_route_table"

  vpc_id = module.rs-main-vpc.instance_id
  igw_id = module.rs-igw.gateway_id
}

//4.a. Route Table - Subnet association
module "rs-rt-subnet-association-1" {
  source = "./modules/rt_association"

  rt_id     = module.vpc-igw-rt.instance_id
  subnet_id = module.rs-subnet-1.instance_id
  
}

//4.b. Route Table - Subnet association
module "rs-rt-subnet-association-2" {
  source = "./modules/rt_association"

  rt_id     = module.vpc-igw-rt.instance_id
  subnet_id = module.rs-subnet-2.instance_id
}

//5a. Create Security Group for ALB
module "rs-alb-sg" {
  source = "./modules/security_group"

  vpc_id = module.rs-main-vpc.instance_id
  name   = "ALB SG"
}

//5b. Create Security Group for EC2
//TODO: move to a module
resource "aws_security_group" "rs-ec2-sg" {
  description = "Allow web and Http Traffic from ALB security Group"
  vpc_id      = module.rs-main-vpc.instance_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" // all the protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}

//5.b.1 Allow Http traffic from ALB sg to
resource "aws_security_group_rule" "rs-sg-rule" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.rs-alb-sg.instance_id
  security_group_id        = aws_security_group.rs-ec2-sg.id
}

# //6. Launch Template
# module "rs-asg-lt" {
#   source = "./modules/launch_template"

#   security_group_id = aws_security_group.rs-ec2-sg.id
#   subnet_id         = module.rs-subnet-1.instance_id
# }

//6. Launch Configuration
module "rs-asg-lc" {
  source = "./modules/launch_configuration"

  security_group_id = aws_security_group.rs-ec2-sg.id
  subnet_id         = module.rs-subnet-1.instance_id
}

//7. Create ALB
module "rs-alb" {
  source = "./modules/alb"

  subnet1_id        = module.rs-subnet-1.instance_id
  subnet2_id        = module.rs-subnet-2.instance_id
  security_group_id = module.rs-alb-sg.instance_id
}

//8. Create Target for ALB
resource "aws_lb_target_group" "rs-alb-tg" {
  name     = "rs-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.rs-main-vpc.instance_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    path                = "/index.html"
  }
}

//9. Attach Listerner to the ALB
resource "aws_lb_listener" "rs-alb-web-listener" {
  load_balancer_arn = module.rs-alb.instance.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.rs-alb-tg.arn
    type = "forward"
  }
}

//10. Create ASG
module "rs-asg" {
  source     = "./modules/asg"
  tg_arn     = aws_lb_target_group.rs-alb-tg.arn
  subnet1_id = module.rs-subnet-1.instance_id
  subnet2_id = module.rs-subnet-2.instance_id

  //launch_template_id = module.rs-asg-lt.instance_id
    launch_config_name = module.rs-asg-lc.instance.name
}

resource "aws_autoscaling_attachment" "rs-asg_attachment" {
  autoscaling_group_name = module.rs-asg.instance.id
  alb_target_group_arn   = aws_lb_target_group.rs-alb-tg.arn
}

output "vpc_instance" {
  value = module.rs-main-vpc.instance_id
}

output "alb_instance" {
  value = module.rs-alb.instance
}