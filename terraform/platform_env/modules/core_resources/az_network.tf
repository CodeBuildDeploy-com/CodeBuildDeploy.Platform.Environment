# Create the Platform VNet
resource "azurerm_virtual_network" "cbd_plat_vnet" {
  name                = "cbd-${var.platform_env}-vnet"
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
  location            = azurerm_resource_group.cbd_plat_rg.location
  address_space       = var.address_prefixes_platform_vnet

  tags = local.tags
}

# Peer with the Global VNet
data "azurerm_virtual_network" "cbd_global_vnet" {
  name                = "cbd-global-vnet"
  resource_group_name = "cbd-global-rg"
}

resource "azurerm_virtual_network_peering" "cbd_vnet_peer_global_plat" {
  name                      = "cbd-vnet-peer-global-${var.platform_env}"
  resource_group_name       = data.azurerm_virtual_network.cbd_global_vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.cbd_global_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.cbd_plat_vnet.id
}

resource "azurerm_virtual_network_peering" "cbd_vnet_peer_plat_global" {
  name                      = "cbd-vnet-peer-${var.platform_env}-global"
  resource_group_name       = azurerm_resource_group.cbd_plat_rg.name
  virtual_network_name      = azurerm_virtual_network.cbd_plat_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.cbd_global_vnet.id
}

# Create the Security Group
resource "azurerm_network_security_group" "cbd_plat_sg" {
  name                = "cbd-${var.platform_env}-sg"
  location            = azurerm_resource_group.cbd_plat_rg.location
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name

  tags = local.tags
}

resource "azurerm_network_security_rule" "cbd_plat_sec_rule" {
  name                        = "cbd-${var.platform_env}-sec-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cbd_plat_rg.name
  network_security_group_name = azurerm_network_security_group.cbd_plat_sg.name
}