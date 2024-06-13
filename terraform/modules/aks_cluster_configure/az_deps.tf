data "azurerm_resource_group" "cbd_subscription_rg" {
  name = "cbd-${var.subscription_friendly_name}-rg"
}

data "azurerm_key_vault" "cbd_subscription_kv" {
  name                = "cbd-${var.subscription_friendly_name}-kv"
  resource_group_name = data.azurerm_resource_group.cbd_subscription_rg.name
}

data "azurerm_key_vault_secret" "cbd_global_acr_access_key" {
  name         = "cbd-global-acr-access-key"
  key_vault_id = data.azurerm_key_vault.cbd_subscription_kv.id
}

data "azurerm_resource_group" "cbd_plat_rg" {
  name = "cbd-${var.platform_env}-rg"
}

data "azurerm_kubernetes_cluster" "cbd_plat_aks_cluster" {
  name                = "cbd-${var.platform_env}-aks-cluster"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
}