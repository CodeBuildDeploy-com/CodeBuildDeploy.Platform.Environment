resource "azurerm_resource_group" "cbd-env-rg" {
  name     = "cbd-${var.platform_env}-rg"
  location = var.default_location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "cbd-env-law" {
  name                = "cbd-${var.platform_env}-law"
  resource_group_name = azurerm_resource_group.cbd-env-rg.name
  location            = azurerm_resource_group.cbd-env-rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = local.tags
}