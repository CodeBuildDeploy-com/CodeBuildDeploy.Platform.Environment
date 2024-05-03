resource "azurerm_resource_group" "codebuilddeploy-environment-rg" {
  name     = "codebuilddeploy-${var.platform_env}-resources"
  location = var.default_location
  tags     = local.tags
}