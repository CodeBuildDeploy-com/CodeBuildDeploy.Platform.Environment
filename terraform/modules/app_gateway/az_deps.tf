data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "cbd_subscription_rg" {
  name = "cbd-${var.subscription_friendly_name}-rg"
}

data "azurerm_key_vault" "cbd_subscription_kv" {
  name                = "cbd-${var.subscription_friendly_name}-kv"
  resource_group_name = data.azurerm_resource_group.cbd_subscription_rg.name
}

data "azurerm_key_vault_certificate" "cbd_plat_appgateway_cert" {
  name         = "cbd-${var.platform_env}-cert-pfx"
  key_vault_id = data.azurerm_key_vault.cbd_subscription_kv.id
}

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