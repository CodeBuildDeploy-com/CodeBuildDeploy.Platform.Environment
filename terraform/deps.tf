resource "azurerm_resource_group" "codebuilddeploy-environment-rg" {
  name     = "codebuilddeploy-${var.environment}-resources"
  location = var.default_location
  tags     = local.tags
}