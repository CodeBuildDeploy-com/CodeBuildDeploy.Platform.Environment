data "azurerm_resource_group" "cbd_plat_rg" {
  name = "cbd-${var.platform_env}-rg"
}

data "azurerm_key_vault" "cbd_plat_kv" {
  name                = "cbd-${var.platform_env}-kv"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
}

data "azurerm_virtual_network" "cbd_plat_vnet" {
  name                = "cbd-${var.platform_env}-vnet"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
}

data "azurerm_network_security_group" "cbd_plat_sg" {
  name                = "cbd-${var.platform_env}-sg"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
}