resource "azurerm_resource_group" "cbd_plat_rg" {
  name     = "cbd-${var.platform_env}-rg"
  location = var.default_location
  tags     = local.tags
}

#resource "azurerm_log_analytics_workspace" "cbd_plat_law" {
#  name                = "cbd-${var.platform_env}-law"
#  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
#  location            = azurerm_resource_group.cbd_plat_rg.location
#  sku                 = "PerGB2018"
#  retention_in_days   = 90
#  tags                = local.tags
#}

data "azurerm_client_config" "current" {}