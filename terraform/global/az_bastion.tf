resource "azurerm_public_ip" "cbd_global_bastion_ip" {
  name                = "cbd-global-bastion-ip"
  resource_group_name = azurerm_resource_group.cbd_global_rg.name
  location            = azurerm_resource_group.cbd_global_rg.location
  allocation_method   = "Static"

  tags = local.tags
}

resource "azurerm_network_interface" "cbd_global_bastion_nic" {
  name                = "cbd-global-bastion-nic"
  location            = azurerm_resource_group.cbd_global_rg.location
  resource_group_name = azurerm_resource_group.cbd_global_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cbd_global_bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cbd_global_bastion_ip.id
  }

  tags = local.tags
}

data "azurerm_key_vault_secret" "cbd_global_bastion_ssh_key" {
  name         = "cbd-global-bastion-ssh-key"
  key_vault_id = azurerm_key_vault.cbd_global_kv.id
}

resource "azurerm_linux_virtual_machine" "cbd_global_bastion_vm" {
  name                  = "cbd-global-bastion-vm"
  resource_group_name   = azurerm_resource_group.cbd_global_rg.name
  location              = azurerm_resource_group.cbd_global_rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.cbd_global_bastion_nic.id]

  custom_data = filebase64("templates/customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = data.azurerm_key_vault_secret.cbd_global_bastion_ssh_key.value
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