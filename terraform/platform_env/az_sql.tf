resource "azurerm_mssql_server" "cbd_plat_sql_server" {
  name                         = "cbd-${var.platform_env}-sql-server"
  resource_group_name          = azurerm_resource_group.cbd_plat_rg.name
  location                     = azurerm_resource_group.cbd_plat_rg.location
  version                      = "12.0"
  administrator_login          = "cbd-sql-admin-${var.platform_env}"
  administrator_login_password = sensitive(azurerm_key_vault_secret.cbd_plat_sql_server_admin_password.value)
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = azurerm_user_assigned_identity.cbd_plat_sql_server_identity.name
    object_id      = azurerm_user_assigned_identity.cbd_plat_sql_server_identity.principal_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cbd_plat_sql_server_identity.id]
  }

  primary_user_assigned_identity_id            = azurerm_user_assigned_identity.cbd_plat_sql_server_identity.id
  transparent_data_encryption_key_vault_key_id = azurerm_key_vault_key.cbd_plat_sql_server_encryption_key.id

  tags = local.tags
}