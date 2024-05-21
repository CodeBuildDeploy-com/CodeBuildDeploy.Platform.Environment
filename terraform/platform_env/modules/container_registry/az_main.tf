resource "azurerm_container_registry" "cbd_global_acr" {
  name                = "codebuilddeploy-${var.platform_env}"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
  location            = data.azurerm_resource_group.cbd_plat_rg.location
  sku                 = "Basic"
  admin_enabled       = true

  tags                = local.tags
}