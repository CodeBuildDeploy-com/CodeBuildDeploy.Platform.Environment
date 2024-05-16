resource "azurerm_virtual_network" "cbd_plat_vnet" {
  name                = "cbd-${var.platform_env}-vnet"
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
  location            = azurerm_resource_group.cbd_plat_rg.location
  address_space       = var.address_prefixes_platform_vnet

  tags = local.tags
}

resource "azurerm_subnet" "cbd_plat_subnet_aks" {
  name                 = "cbd-${var.platform_env}-subnet-aks"
  resource_group_name  = azurerm_resource_group.cbd_plat_rg.name
  virtual_network_name = azurerm_virtual_network.cbd_plat_vnet.name
  address_prefixes     = var.address_prefixes_aks_subnet
}

resource "azurerm_subnet" "cbd_plat_subnet_sqldb" {
  name                 = "cbd-${var.platform_env}-subnet-sqldb"
  resource_group_name  = azurerm_resource_group.cbd_plat_rg.name
  virtual_network_name = azurerm_virtual_network.cbd_plat_vnet.name
  address_prefixes     = var.address_prefixes_sqldb_subnet
}

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

resource "azurerm_subnet_network_security_group_association" "cbd_plat_aks_sga" {
  subnet_id                 = azurerm_subnet.cbd_plat_subnet_aks.id
  network_security_group_id = azurerm_network_security_group.cbd_plat_sg.id
}

resource "azurerm_subnet_network_security_group_association" "cbd_plat_sqldb_sga" {
  subnet_id                 = azurerm_subnet.cbd_plat_subnet_sqldb.id
  network_security_group_id = azurerm_network_security_group.cbd_plat_sg.id
}

resource "azurerm_private_dns_zone" "cbd_plat_sqldb_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
}

resource "azurerm_private_endpoint" "cbd_plat_sqldb_pe" {
  name                          = "cbd-${var.platform_env}-sqldb-pe"
  location                      = azurerm_resource_group.cbd_plat_rg.location
  resource_group_name           = azurerm_resource_group.cbd_plat_rg.name
  subnet_id                     = azurerm_subnet.cbd_plat_subnet_sqldb.id
  custom_network_interface_name = "cbd-${var.platform_env}-sqldb-pe-nic"

  private_service_connection {
    name                           = "cbd-${var.platform_env}-sqldb-pe-psc"
    private_connection_resource_id = azurerm_mssql_server.cbd_plat_sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "cbd-${var.platform_env}-sqldb-pe-dzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.cbd_plat_sqldb_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "cbd_plat_sqldb_vnet_link" {
  name                  = "cbd-${var.platform_env}-sqldb-vnet-link"
  resource_group_name   = azurerm_resource_group.cbd_plat_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.cbd_plat_sqldb_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.cbd_plat_vnet.id
}