# Resource Group
resource "azurerm_resource_group" "cbd_plat_bastion_rg" {
  name     = "cbd-${var.platform_env}-bastion-rg"
  location = var.default_location
  tags     = local.tags
}

# Network
resource "azurerm_subnet" "cbd_plat_bastion_subnet" {
  name                 = "cbd-${var.platform_env}-bastion-subnet"
  resource_group_name  = data.azurerm_resource_group.cbd_plat_rg.name
  virtual_network_name = data.azurerm_virtual_network.cbd_plat_vnet.name
  address_prefixes     = var.address_prefixes_bastion_subnet
}

resource "azurerm_subnet_network_security_group_association" "cbd_plat_bastion_sga" {
  subnet_id                 = azurerm_subnet.cbd_plat_bastion_subnet.id
  network_security_group_id = data.azurerm_network_security_group.cbd_plat_sg.id
}

resource "azurerm_public_ip" "cbd_plat_bastion_ip" {
  name                = "cbd-${var.platform_env}-bastion-ip"
  resource_group_name = azurerm_resource_group.cbd_plat_bastion_rg.name
  location            = azurerm_resource_group.cbd_plat_bastion_rg.location
  allocation_method   = "Static"

  tags = local.tags
}

resource "azurerm_network_interface" "cbd_plat_bastion_nic" {
  name                = "cbd-${var.platform_env}-bastion-nic"
  location            = azurerm_resource_group.cbd_plat_bastion_rg.location
  resource_group_name = azurerm_resource_group.cbd_plat_bastion_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cbd_plat_bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cbd_plat_bastion_ip.id
  }

  tags = local.tags
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "cbd_plat_bastion_vm" {
  name                  = "cbd-${var.platform_env}-bastion-vm"
  resource_group_name   = azurerm_resource_group.cbd_plat_bastion_rg.name
  location              = azurerm_resource_group.cbd_plat_bastion_rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.cbd_plat_bastion_nic.id]

  custom_data = filebase64("${path.module}/templates/customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = data.azurerm_key_vault_secret.cbd_plat_bastion_ssh_key.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = local.tags
}