resource "azurerm_resource_group" "cbd_app_rg" {
  name     = "cbd-${var.platform_env}-${var.app_env}-rg"
  location = var.default_location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "cbd_app_law" {
  name                = "cbd-${var.platform_env}-${var.app_env}-law"
  resource_group_name = azurerm_resource_group.cbd_app_rg.name
  location            = azurerm_resource_group.cbd_app_rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}