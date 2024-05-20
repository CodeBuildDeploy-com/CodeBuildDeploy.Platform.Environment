resource "azurerm_key_vault" "cbd_plat_kv" {
  name                            = "cbd-${var.platform_env}-kv1"
  location                        = var.default_location
  resource_group_name             = azurerm_resource_group.cbd_plat_rg.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = true
  soft_delete_retention_days      = 7
  public_network_access_enabled   = true

  lifecycle {
    ignore_changes = [
      access_policy, # this prevents removing access policies manually assigned
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Purge", "Backup", "Restore"]
    key_permissions         = ["Get", "List", "Create", "Import", "Delete", "Update", "Recover", "Purge", "Backup", "Restore", "GetRotationPolicy"]
    certificate_permissions = ["Get", "List", "Delete", "Create", "Update", "Purge"]
  }

  tags = local.tags
}