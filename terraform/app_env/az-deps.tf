resource "azurerm_resource_group" "cbd-app-environment-rg" {
  name     = "cbd-${var.platform_env}-${var.app_env}-rg"
  location = var.default_location
  tags     = local.tags
}