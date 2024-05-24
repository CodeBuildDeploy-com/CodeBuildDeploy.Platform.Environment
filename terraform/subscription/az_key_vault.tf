resource "azurerm_key_vault" "cbd_subscription_kv" {
  name                            = "cbd-${var.subscription_short_name}-kv"
  resource_group_name             = azurerm_resource_group.cbd_subscription_rg.name
  location                        = var.default_location
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false
  soft_delete_retention_days      = 30
  public_network_access_enabled   = true
  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "cbd_subscription_kvp_principal" {
  key_vault_id = azurerm_key_vault.cbd_subscription_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore"]
  key_permissions         = ["Get", "List", "Create", "Import", "Delete", "Backup", "Restore", "GetRotationPolicy"]
  certificate_permissions = ["Get", "List", "Delete", "Create", "Update", "Purge"]
}