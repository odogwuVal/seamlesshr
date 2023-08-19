module "vpc" {
  source     = "../modules/vpc"
  project    = "seamless_HR"
  createdby  = "Madu Valentine"
  cidr_block = var.cidr_block
  lg_ports   = var.lg_ports
}