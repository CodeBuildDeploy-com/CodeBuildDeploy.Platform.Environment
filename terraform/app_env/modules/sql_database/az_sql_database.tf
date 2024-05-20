resource "azurerm_mssql_database" "cbd_app_sql_database" {
  name           = "cbd-${var.platform_env}-${var.app_env}-sql-database"
  server_id      = data.azurerm_mssql_server.cbd_plat_sql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "Basic"
  max_size_gb    = 2

  tags = local.tags
}