module "cbd_global_core_resources" {
  source = "./modules/core_resources"

  platform_env = var.platform_env
  address_prefixes_platform_vnet = var.address_prefixes_platform_vnet
}

module "cbd_plat_app_gateway" {
  depends_on          = [module.cbd_global_core_resources] 
  
  source = "./modules/app_gateway"
 
  platform_env = var.platform_env
  address_prefixes_appgateway_subnet = var.address_prefixes_appgateway_subnet
}

module "cbd_plat_aks_cluster" {
  depends_on          = [module.cbd_plat_app_gateway] 

  source = "./modules/aks_cluster"
 
  platform_env = var.platform_env
  address_prefixes_aks_subnet = var.address_prefixes_aks_subnet
  aks_service_cidr = var.aks_service_cidr
  aks_dns_service_ip = var.aks_dns_service_ip
}

module "cbd_plat_sql_server" {
  depends_on          = [module.cbd_global_core_resources]

  source = "./modules/sql_server"
 
  platform_env = var.platform_env
  address_prefixes_sqldb_subnet = var.address_prefixes_sqldb_subnet
}