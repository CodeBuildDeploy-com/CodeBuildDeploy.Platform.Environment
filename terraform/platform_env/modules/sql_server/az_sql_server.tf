# Key Vault
resource "azurerm_key_vault_access_policy" "cbd_plat_kv_access_sql_server" {
  key_vault_id = data.azurerm_key_vault.cbd_plat_kv.id
  tenant_id    = azurerm_user_assigned_identity.cbd_plat_sql_server_identity.tenant_id
  object_id    = azurerm_user_assigned_identity.cbd_plat_sql_server_identity.principal_id

  key_permissions = ["Get", "WrapKey", "UnwrapKey"]
}

resource "azurerm_key_vault_key" "cbd_plat_sql_server_encryption_key" {
  name         = "cbd-${var.platform_env}-sql-server-encryption-key"
  key_vault_id = data.azurerm_key_vault.cbd_plat_kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = ["unwrapKey", "wrapKey"]
}

resource "random_password" "cbd_plat_sql_server_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*_=+?"
}

resource "azurerm_key_vault_secret" "cbd_plat_sql_server_admin_password" {
  name         = "cbd-${var.platform_env}-sql-server-admin-password"
  value        = random_password.cbd_plat_sql_server_admin_password.result
  key_vault_id = data.azurerm_key_vault.cbd_plat_kv.id
}

# Network
resource "azurerm_subnet" "cbd_plat_subnet_sqldb" {
  name                 = "cbd-${var.platform_env}-subnet-sqldb"
  resource_group_name  = data.azurerm_resource_group.cbd_plat_rg.name
  virtual_network_name = data.azurerm_virtual_network.cbd_plat_vnet.name
  address_prefixes     = var.address_prefixes_sqldb_subnet
}

resource "azurerm_subnet_network_security_group_association" "cbd_plat_sqldb_sga" {
  subnet_id                 = azurerm_subnet.cbd_plat_subnet_sqldb.id
  network_security_group_id = data.azurerm_network_security_group.cbd_plat_sg.id
}

resource "azurerm_private_dns_zone" "cbd_plat_sqldb_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
}

resource "azurerm_private_endpoint" "cbd_plat_sqldb_pe" {
  name                          = "cbd-${var.platform_env}-sqldb-pe"
  location                      = data.azurerm_resource_group.cbd_plat_rg.location
  resource_group_name           = data.azurerm_resource_group.cbd_plat_rg.name
  subnet_id                     = azurerm_subnet.cbd_plat_subnet_sqldb.id
  custom_network_interface_name = "cbd-${var.platform_env}-sqldb-pe-nic"

  private_service_connection {
    name                           = "cbd-${var.platform_env}-sqldb-pe-psc"
    private_connection_resource_id = azurerm_mssql_server.cbd_plat_sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "cbd-${var.platform_env}-sqldb-pe-dzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.cbd_plat_sqldb_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "cbd_plat_sqldb_vnet_link" {
  name                  = "cbd-${var.platform_env}-sqldb-vnet-link"
  resource_group_name   = data.azurerm_resource_group.cbd_plat_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.cbd_plat_sqldb_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.cbd_plat_vnet.id
}

# Managed Identity
resource "azurerm_user_assigned_identity" "cbd_plat_sql_server_identity" {
  name                = "cbd-${var.platform_env}-sql-server-identity"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
  location            = data.azurerm_resource_group.cbd_plat_rg.location
}

# Sql Server
resource "azurerm_mssql_server" "cbd_plat_sql_server" {
  name                         = "cbd-${var.platform_env}-sql-server"
  resource_group_name          = data.azurerm_resource_group.cbd_plat_rg.name
  location                     = data.azurerm_resource_group.cbd_plat_rg.location
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