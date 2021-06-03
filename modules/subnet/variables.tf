variable "vpc_id" {
  type = string
}

variable "cidr" {
  type = string
}

variable "az" {
  type = string
}

variable "name" {
  type = string
}

variable "tag" {
  default = "RackSpace Assignment - Subnet"
}