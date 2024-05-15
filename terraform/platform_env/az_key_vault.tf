resource "azurerm_key_vault" "cbd_plat_kv" {
  name                            = "cbd-${var.platform_env}-kv1"
  location                        = var.default_location
  resource_group_name             = azurerm_resource_group.cbd_plat_rg.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false
  soft_delete_retention_days      = 7
  public_network_access_enabled   = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Purge", "Backup", "Restore"]
    key_permissions         = ["Get", "List", "Create", "Import", "Delete", "Update", "Recover", "Purge", "Backup", "Restore", "GetRotationPolicy"]
    certificate_permissions = ["Get", "List", "Delete", "Create", "Update", "Purge"]
  }

  access_policy {
    tenant_id = azurerm_user_assigned_identity.cbd_plat_sql_server_identity.tenant_id
    object_id = azurerm_user_assigned_identity.cbd_plat_sql_server_identity.principal_id

    key_permissions = ["Get", "WrapKey", "UnwrapKey"]
  }

  tags = local.tags
}

resource "azurerm_key_vault_key" "cbd_plat_sql_server_encryption_key" {
  depends_on = [azurerm_key_vault.cbd_plat_kv]

  name         = "cbd-${var.platform_env}-sql-server-encryption-key"
  key_vault_id = azurerm_key_vault.cbd_plat_kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = ["unwrapKey", "wrapKey"]
}

resource "random_password" "cbd_plat_sql_server_admin_password" {
  length = 16
  special = true
  override_special = "!#$%&*_=+?"
}

resource "azurerm_key_vault_secret" "cbd_plat_sql_server_admin_password" {
  depends_on = [azurerm_key_vault.cbd_plat_kv]

  name         = "cbd-${var.platform_env}-sql-server-encryption-key"
  value        = random_password.cbd_plat_sql_server_admin_password.result
  key_vault_id = azurerm_key_vault.cbd_plat_kv.id
}