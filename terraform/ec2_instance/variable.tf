variable "region" {
  description = "region of the vpc"
  default = "ap-south-1"
}
variable "availability_zones" {
  description = "availability zone of subnet public"
}

variable "cidr_block" {
  description = "cidr blocks of all the subnets"
  default = ["10.0.0.0/16","10.0.24.0/24","10.0.26.0/24","0.0.0.0/0","0.0.0.0/0"]
}

variable "ami" {
  description = "ami for the 2 instanses"
}
variable "instance_type" {
  default = "type of the instanses"
}

variable "key_name" {
  description = "key name of the instance"
}