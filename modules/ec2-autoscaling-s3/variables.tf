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
          az = "use1-az1"
          cidr = "10.0.1.0/24"
      }
      pub-subnet-b = {
          az = "use1-az2"
          cidr = "10.0.2.0/24"
      }
  }
}

variable "private-subnets" {
  type = map
  default = {
      priv-subnet-a = {
          az = "use1-az1"
          cidr = "10.0.3.0/24"
      }
      priv-subnet-b = {
          az = "use1-az2"
          cidr = "10.0.4.0/24"
      }
  }
}

#ubuntu image
variable "owners" {
  type = string
  default = "651611223190"
}

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