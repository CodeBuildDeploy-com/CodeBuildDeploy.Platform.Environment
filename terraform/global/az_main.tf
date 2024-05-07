resource "azurerm_resource_group" "cbd_global_rg" {
  name     = "cbd-global-rg"
  location = var.default_location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "cbd_global_law" {
  name                = "cbd-global-law"
  resource_group_name = azurerm_resource_group.cbd_global_rg.name
  location            = azurerm_resource_group.cbd_global_rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

data "azurerm_client_config" "current" {}