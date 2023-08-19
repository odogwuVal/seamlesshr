provider "aws" {
  region = "us-east-2"
}

module "tfstate_backend" {
  source           = "git@github.com:odogwuVal/terraform-module-aws-tfstate.git?ref=main"
  force_destroy    = true
  bucket_enabled   = true
  dynamodb_enabled = true
  region           = var.region
  context          = module.this.context
}


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
