//TODO: use array instead
variable "subnet1_id" {
  type = string
}

variable "subnet2_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "name" {
  type = string
  default = "rs-alb"
}

//TODO: Add tags in all the resources/modules