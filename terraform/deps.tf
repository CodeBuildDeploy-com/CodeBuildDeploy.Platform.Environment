resource "azurerm_resource_group" "codebuilddeploy-environment-rg" {
  name     = "codebuilddeploy-${var.environment}-resources"
  location = var.location
  tags     = local.environment_tags
}

resource "azurerm_resource_group" "codebuilddeploy-environment-spoke-rg" {
  name     = "codebuilddeploy-${var.environment}-${var.environment_spoke}-resources"
  location = var.location
  tags     = local.environment_spoke_tags
}

resource "azurerm_log_analytics_workspace" "codebuilddeploy-environment-spoke-law" {
  name                = "codebuilddeploy-${var.environment}-${var.environment_spoke}-law"
  resource_group_name = azurerm_resource_group.codebuilddeploy-environment-spoke-rg.name
  location            = azurerm_resource_group.codebuilddeploy-environment-spoke-rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = local.environment_spoke_tags
}