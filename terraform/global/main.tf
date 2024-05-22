module "cbd_global_core_resources" {
  source = "./modules/core_resources"

  address_prefixes_global_vnet = var.address_prefixes_global_vnet
}

module "cbd_global_bastion" {
  depends_on = [module.cbd_global_core_resources] 
  source     = "./modules/bastion"
 
  address_prefixes_bastion_subnet = var.address_prefixes_bastion_subnet
}