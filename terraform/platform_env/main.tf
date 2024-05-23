module "cbd_plat_core_resources" {
  source = "./modules/core_resources"

  platform_env                   = var.platform_env
  address_prefixes_platform_vnet = var.address_prefixes_platform_vnet
}

module "cbd_plat_container_registry" {
  depends_on = [module.cbd_plat_core_resources]
  source     = "./modules/container_registry"

  platform_env = var.platform_env
}

#module "cbd_plat_app_gateway" {
#  depends_on = [module.cbd_plat_core_resources]
#  source     = "./modules/app_gateway"
 
#  platform_env                       = var.platform_env
#  address_prefixes_appgateway_subnet = var.address_prefixes_appgateway_subnet
#}

module "cbd_plat_aks_cluster" {
  depends_on = [module.cbd_plat_core_resources]
#  depends_on = [module.cbd_plat_app_gateway]
  source     = "./modules/aks_cluster"
 
  platform_env                = var.platform_env
  address_prefixes_aks_subnet = var.address_prefixes_aks_subnet
  aks_service_cidr            = var.aks_service_cidr
  aks_dns_service_ip          = var.aks_dns_service_ip
  aks_system_pool_vm_size     = var.aks_system_pool_vm_size
  aks_system_pool_min_count   = var.aks_system_pool_min_count
  aks_system_pool_max_count   = var.aks_system_pool_max_count
}

module "cbd_plat_aks_cluster_configure" {
  depends_on = [module.cbd_plat_aks_cluster]
  source     = "./modules/aks_cluster_configure"
 
  platform_env                = var.platform_env
  container_registry          = var.container_registry
  container_registry_username = var.container_registry_username
}

module "cbd_plat_sql_server" {
  depends_on = [module.cbd_plat_core_resources]
  source     = "./modules/sql_server"
 
  platform_env                  = var.platform_env
  address_prefixes_sqldb_subnet = var.address_prefixes_sqldb_subnet
}