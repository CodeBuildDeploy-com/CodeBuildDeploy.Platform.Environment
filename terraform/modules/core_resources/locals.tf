locals {
  tags = {
    product      = var.product
    subscription = var.subscription_short_name
    platform_env = var.platform_env
  }
}