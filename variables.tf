
variable "cidr-main-vpc" {
  default = "10.0.0.0/16"
}

variable "cidr-subnet-1" {
  default = "10.0.1.0/24"
}

variable "cidr-subnet-2" {
  default = "10.0.2.0/24"
}

variable "default_az-1" { 
  default = "ca-central-1a"
  type = string
}

variable "default_az-2" { 
  default = "ca-central-1b"
  type = string
}