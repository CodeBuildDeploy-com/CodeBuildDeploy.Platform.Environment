resource "azurerm_network_watcher" "cbd_global_traffic_watcher" {
  name                = "cbd-global-NetworkWatcher"
  location            = azurerm_resource_group.cbd_global_rg.location
  resource_group_name = azurerm_resource_group.cbd_global_rg.name
}

resource "azurerm_virtual_network" "cbd_global_vnet" {
  name                = "cbd-global-vnet"
  resource_group_name = azurerm_resource_group.cbd_global_rg.name
  location            = azurerm_resource_group.cbd_global_rg.location
  address_space       = var.address_prefixes_global_vnet

  tags = local.tags
}

resource "azurerm_network_security_group" "cbd_global_sg" {
  name                = "cbd-global-sg"
  location            = azurerm_resource_group.cbd_global_rg.location
  resource_group_name = azurerm_resource_group.cbd_global_rg.name

  tags = local.tags
}

resource "azurerm_network_security_rule" "cbd_global_sec_rule" {
  name                        = "cbd-global-sec-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cbd_global_rg.name
  network_security_group_name = azurerm_network_security_group.cbd_global_sg.name
}