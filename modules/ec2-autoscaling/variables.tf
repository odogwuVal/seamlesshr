variable "owners" {
  type = string
  default = "651611223190"
}

# key variables
variable "key_name" {
  type = string
}

# autoscaling group
variable "min_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "max_size" {
  type = number
}

variable "vpc_zone_identifier" {}
variable "adjustment_type" {}
variable "scaling_adjustment" {}
variable "cooldown" {}
variable "policy_type" {}
variable "comparison_operator" {}
variable "evaluation_periods" {}
variable "metric_name" {}
variable "period" {}
variable "statistic" {}
variable "threshold" {}
variable "scale_down_scaling_adjustment" {}
variable "scale_down_comparison_operator" {}
variable "scale_down_threshold" {}

variable "internal" {
  type = string
  default = "false"
}

variable "load_balancer_type" {
  type = string
  default = ""
}

variable "security_groups" {}
variable "lb_subnets" {}
variable "target_port" {}
variable "target_protocol" {}
variable "vpc_id" {}
variable "listener_port" {}
variable "listener_protocol" {}
variable "certificate_arn" {}
variable "ssh_ports" {
  type = list(number)
  default = [22]
}
variable "allowed_cidrs" {}
variable "source_security_group_id" {}
variable "project" {}
variable "createdby" {}