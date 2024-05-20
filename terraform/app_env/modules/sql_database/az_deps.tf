data "azurerm_mssql_server" "cbd_plat_sql_server" {
  name                = "cbd-${var.platform_env}-sql-server"
  resource_group_name = "cbd-${var.platform_env}-rg"
}