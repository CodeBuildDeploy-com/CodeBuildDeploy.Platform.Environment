resource "azurerm_resource_group" "cbd_subscription_rg" {
  name     = "cbd-${var.subscription_short_name}-rg"
  location = var.default_location
  tags     = local.tags
}