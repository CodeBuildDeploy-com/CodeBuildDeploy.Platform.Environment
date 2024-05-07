resource "azurerm_resource_group" "cbd-global-rg" {
  name     = "cbd-global-rg"
  location = var.default_location
  tags     = local.tags
}