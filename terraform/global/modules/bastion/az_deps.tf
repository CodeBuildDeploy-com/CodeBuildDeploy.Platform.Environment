data "azurerm_resource_group" "cbd_global_rg" {
  name     = "cbd-global-rg"
}

data "azurerm_key_vault" "cbd_global_kv" {
  name                = "cbd-global-kv1"
  resource_group_name = data.azurerm_resource_group.cbd_global_rg.name
}

data "azurerm_key_vault_secret" "cbd_global_bastion_ssh_key" {
  name         = "cbd-global-bastion-ssh-key"
  key_vault_id = data.azurerm_key_vault.cbd_global_kv.id
}

data "azurerm_virtual_network" "cbd_global_vnet" {
  name                = "cbd-global-vnet"
  resource_group_name = data.azurerm_resource_group.cbd_global_rg.name
}

data "azurerm_network_security_group" "cbd_global_sg" {
  name                = "cbd-global-sg"
  resource_group_name = data.azurerm_resource_group.cbd_global_rg.name
}