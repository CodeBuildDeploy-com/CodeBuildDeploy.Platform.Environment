locals {
  tags = {
    product           = var.product
    environment       = var.environment
    environment_spoke = var.environment_spoke
  }
}