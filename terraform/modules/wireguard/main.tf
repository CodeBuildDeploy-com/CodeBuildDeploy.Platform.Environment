locals {
  ssh_public_key_format = "^(ssh-ed25519|ssh-rsa)[ \\t]+([A-Za-z0-9+/]+={0,2})(?:[ \\t]+[^\\r\\n]+)?$"
}

resource "azurerm_subnet" "wireguard" {
  name                            = "${var.name}-subnet"
  resource_group_name             = var.resource_group_name
  virtual_network_name            = var.virtual_network_name
  address_prefixes                = [var.subnet_cidr]
  default_outbound_access_enabled = false
}

resource "azurerm_network_security_group" "wireguard" {
  name                = "${var.name}-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  security_rule {
    name                       = "DenyOtherInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "wireguard" {
  subnet_id                 = azurerm_subnet.wireguard.id
  network_security_group_id = azurerm_network_security_group.wireguard.id
}

resource "azurerm_public_ip" "wireguard" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "wireguard" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet_network_security_group_association.wireguard.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.subnet_cidr, 4)
    public_ip_address_id          = azurerm_public_ip.wireguard.id
  }
}

resource "azurerm_linux_virtual_machine" "wireguard" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  network_interface_ids           = [azurerm_network_interface.wireguard.id]
  admin_username                  = "azureuser"
  disable_password_authentication = true
  tags                            = var.tags

  admin_ssh_key {
    username   = "azureuser"
    public_key = join(" ", regex(local.ssh_public_key_format, trimspace(var.admin_ssh_public_key)))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 32
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = var.image_sku
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml.tftpl", {
    peer_endpoint    = var.peer_endpoint
    peer_public_key  = var.peer_public_key
    tunnel_address   = var.tunnel_address
    peer_tunnel_cidr = var.peer_tunnel_cidr
    aks_subnet_cidrs = join(", ", var.aks_subnet_cidrs)
  }))
}

output "egress_ip" {
  value = azurerm_public_ip.wireguard.ip_address
}
