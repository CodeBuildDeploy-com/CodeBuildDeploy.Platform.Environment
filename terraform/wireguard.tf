data "azurerm_key_vault_secret" "wireguard_ssh_public_key" {
  name         = "cbd-${var.platform_env}-wireguard-ssh-key"
  key_vault_id = data.azurerm_key_vault.cbd_subscription_kv.id
}

data "azurerm_key_vault_secret" "wireguard_homelab_public_key" {
  name         = "cbd-${var.platform_env}-wireguard-homelab-public-key"
  key_vault_id = data.azurerm_key_vault.cbd_subscription_kv.id
}

module "wireguard" {
  source = "./modules/wireguard"

  name                 = "cbd-${var.platform_env}-wireguard"
  resource_group_name  = data.azurerm_resource_group.cbd_plat_rg.name
  location             = data.azurerm_resource_group.cbd_plat_rg.location
  virtual_network_name = module.cbd_plat_core_resources.virtual_network_name
  subnet_cidr          = var.wireguard.subnet_cidr
  vm_size              = var.wireguard.vm_size
  image_sku            = var.wireguard.image_sku
  peer_endpoint        = var.wireguard.peer_endpoint
  peer_public_key      = trimspace(data.azurerm_key_vault_secret.wireguard_homelab_public_key.value)
  tunnel_address       = var.wireguard.tunnel_address
  peer_tunnel_cidr     = var.wireguard.peer_tunnel_cidr
  aks_subnet_cidrs     = var.address_prefixes_aks_subnet
  admin_ssh_public_key = data.azurerm_key_vault_secret.wireguard_ssh_public_key.value
  tags                 = local.tags
}

output "wireguard_egress_ip" {
  description = "Azure source IPv4 address for the homelab listener's firewall allowlist"
  value       = module.wireguard.egress_ip
}
