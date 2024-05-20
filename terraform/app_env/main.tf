module "cbd_app_core_resources" {
  source = "./modules/core_resources"

  platform_env = var.platform_env
  app_env      = var.app_env
}

module "cbd_app_sql_database" {
  source = "./modules/sql_database"
 
  platform_env = var.platform_env
  app_env      = var.app_env
}

