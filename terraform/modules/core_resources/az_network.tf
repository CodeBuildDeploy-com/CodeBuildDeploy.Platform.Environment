# Create the Platform VNet
resource "azurerm_virtual_network" "cbd_plat_vnet" {
  name                = "cbd-${var.platform_env}-vnet"
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
  location            = azurerm_resource_group.cbd_plat_rg.location
  address_space       = var.address_prefixes_platform_vnet

  tags                = local.tags
}

# Create the Security Group
resource "azurerm_network_security_group" "cbd_plat_sg" {
  name                = "cbd-${var.platform_env}-sg"
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
  location            = azurerm_resource_group.cbd_plat_rg.location

  tags                = local.tags
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