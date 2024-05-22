data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "cbd_global_rg" {
  name = "cbd-global-rg"
}

data "azurerm_key_vault" "cbd_global_kv" {
  name                = "cbd-global-kv1"
  resource_group_name = data.azurerm_resource_group.cbd_global_rg.name
}

data "azurerm_key_vault_secret" "cbd_plat_aks_ssh_key" {
  name         = "cbd-${var.platform_env}-aks-ssh-key"
  key_vault_id = data.azurerm_key_vault.cbd_global_kv.id
}

data "azurerm_resource_group" "cbd_plat_rg" {
  name = "cbd-${var.platform_env}-rg"
}

data "azurerm_log_analytics_workspace" "cbd_plat_law" {
  name                = "cbd-${var.platform_env}-law"
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

data "azurerm_application_gateway" "cbd_plat_appgateway" {
  name                = "cbd-${var.platform_env}-appgateway"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
}

data "azurerm_subnet" "cbd_plat_appgateway_subnet" {
  name                 = "cbd-${var.platform_env}-appgateway-subnet"
  resource_group_name  = data.azurerm_resource_group.cbd_plat_rg.name
  virtual_network_name = data.azurerm_virtual_network.cbd_plat_vnet.name
}

data "azurerm_user_assigned_identity" "cbd_plat_agw_identity" {
  name                = "cbd-${var.platform_env}-agw-identity"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
}