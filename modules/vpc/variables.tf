#vpc
variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

#subnet
variable "public-subnets" {
  type = map
  default = {
      pub-subnet-a = {
          az = "use2-az1"
          cidr = "10.0.1.0/24"
      }
      pub-subnet-b = {
          az = "use2-az2"
          cidr = "10.0.2.0/24"
      }
  }
}

variable "private-subnets" {
  type = map
  default = {
      priv-subnet-a = {
          az = "use2-az1"
          cidr = "10.0.3.0/24"
      }
  }
}

#security group
variable "lg_ports" {
  type = list(number)
  default = [80, 443]
}


#locals
variable "createdby" {
  type = string
}

variable "project" {}