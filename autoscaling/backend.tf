terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    region         = "us-east-2"
    bucket         = "terraform-20230819071902000000000001"
    key            = "terraform.tfstate"
    dynamodb_table = "lock"
    encrypt        = true
  }
}