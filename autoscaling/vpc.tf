module "vpc" {
  source = "../modules/vpc"
  project = "seamless_HR"
  createdby = "Madu Valentine"
  cidr_block = "172.30.0.0/16"
}