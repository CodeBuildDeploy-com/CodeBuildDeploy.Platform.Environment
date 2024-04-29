resource "azurerm_resource_group" "code-build-deploy-common-rg" {
  name     = "code-build-deploy-common-resources"
  location = var.location
}

resource "azurerm_resource_group" "code-build-deploy-environment-rg" {
  name     = "code-build-deploy-${var.environment}-resources"
  location = var.location
  tags     = local.environment-resource-tags
}

resource "azurerm_log_analytics_workspace" "code-build-deploy-environment-law" {
  name                = "code-build-deploy-${var.environment}-law"
  resource_group_name = azurerm_resource_group.code-build-deploy-environment-rg.name
  location            = azurerm_resource_group.code-build-deploy-environment-rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = local.environment-resource-tags
}