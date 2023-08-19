variable "cidr_block" {
  type    = string
  default = ""
}

variable "lg_ports" {
  type    = list(number)
  default = []
}