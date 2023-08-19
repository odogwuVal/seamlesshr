#key pair
variable "key_name" {
  type = string
  default = ""
}

#security group
variable "lg_ports" {
  type = list(number)
  default = [80, 443]
}

#security group
variable "instance_ports" {
  type = list(number)
  default = [80, 22]
}


#locals
variable "createdby" {
  type = string
}

variable "project" {}


#asg
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}