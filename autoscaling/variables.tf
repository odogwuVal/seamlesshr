variable "cidr_block" {
  type    = string
  default = ""
}

variable "lg_ports" {
  type    = list(number)
  default = []
}

variable "certificate_arn" {
  type = string
}

variable "allowed_cidrs" {
  type = string
}