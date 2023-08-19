# to define my locally scoped variables
locals {
  tags = {
    project = var.project
    createdby = var.createdby
    createdon = timestamp()
  }
}