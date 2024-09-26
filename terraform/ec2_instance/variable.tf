variable "region" {
  description = "region of the vpc"
  default = "ap-south-1"
}
variable "availability_zones" {
  description = "availability zone of subnet public"
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