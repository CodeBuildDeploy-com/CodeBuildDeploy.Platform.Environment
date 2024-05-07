resource "azurerm_network_watcher" "cbd-global-traffic-watcher" {
  name                = "cbd-global-NetworkWatcher"
  location            = azurerm_resource_group.cbd-global-rg.location
  resource_group_name = azurerm_resource_group.cbd-global-rg.name
}

resource "azurerm_virtual_network" "cbd-global-vnet" {
  name                = "cbd-global-vnet"
  resource_group_name = azurerm_resource_group.cbd-global-rg.name
  location            = azurerm_resource_group.cbd-global-rg.location
  address_space       = ["10.0.0.0/24"]

  tags = local.tags
}

resource "azurerm_subnet" "cbd-global-subnet1" {
  name                 = "cbd-global-subnet1"
  resource_group_name  = azurerm_resource_group.cbd-global-rg.name
  virtual_network_name = azurerm_virtual_network.cbd-global-vnet.name
  address_prefixes     = ["10.0.0.0/26"]
}

resource "azurerm_network_security_group" "cbd-global-sg" {
  name                = "cbd-global-sg"
  location            = azurerm_resource_group.cbd-global-rg.location
  resource_group_name = azurerm_resource_group.cbd-global-rg.name

  tags = local.tags
}

resource "azurerm_network_security_rule" "cbd-global-sec-rule" {
  name                        = "cbd-global-sec-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cbd-global-rg.name
  network_security_group_name = azurerm_network_security_group.cbd-global-sg.name
}

resource "azurerm_subnet_network_security_group_association" "cbd-global-sga" {
  subnet_id                 = azurerm_subnet.cbd-global-subnet1.id
  network_security_group_id = azurerm_network_security_group.cbd-global-sg.id
}