resource "azurerm_resource_group" "cbd-global-rg" {
  name     = "cbd-global-rg"
  location = var.default_location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "cbd-global-law" {
  name                = "cbd-global-law"
  resource_group_name = azurerm_resource_group.cbd-global-rg.name
  location            = azurerm_resource_group.cbd-global-rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}