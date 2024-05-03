resource "azurerm_resource_group" "codebuilddeploy-app-environment-rg" {
  name     = "codebuilddeploy-${var.platform_env}-${var.app_env}-resources"
  location = var.default_location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "codebuilddeploy-app-environment-law" {
  name                = "codebuilddeploy-${var.platform_env}-${var.app_env}-law"
  resource_group_name = azurerm_resource_group.codebuilddeploy-app-environment-rg.name
  location            = azurerm_resource_group.codebuilddeploy-app-environment-rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = local.tags
}