variable "name_prefix" {
  type    = string
  default = "rs-asg-lc-ins-"
}

variable "image_id" {
  type    = string
  default = "ami-0101734ab73bd9e15"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "security_group_id" {
  type = string
}

variable "subnet_id" {
  type = string
}
