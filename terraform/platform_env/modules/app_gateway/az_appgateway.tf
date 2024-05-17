# Network
resource "azurerm_subnet" "cbd_plat_appgateway_subnet" {
  name                 = "cbd-${var.platform_env}-appgateway-subnet"
  resource_group_name  = data.azurerm_resource_group.cbd_plat_rg.name
  virtual_network_name = data.azurerm_virtual_network.cbd_plat_vnet.name
  address_prefixes     = var.address_prefixes_appgateway_subnet
}

resource "azurerm_subnet_network_security_group_association" "cbd_global_appgateway_sga" {
  subnet_id                 = azurerm_subnet.cbd_plat_appgateway_subnet.id
  network_security_group_id = data.azurerm_network_security_group.cbd_plat_sg.id
}

resource "azurerm_public_ip" "cbd_plat_appgateway_ip" {
  name                = "cbd-${var.platform_env}-appgateway-ip"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
  location            = data.azurerm_resource_group.cbd_plat_rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = [1, 2, 3]

  tags                = local.tags
}

# Identity and Access
resource "azurerm_user_assigned_identity" "cbd_plat_agw_identity" {
  name                = "cbd-${var.platform_env}-agw-identity"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
  location            = data.azurerm_resource_group.cbd_plat_rg.location
}

resource "azurerm_role_assignment" "cbd_plat_agw_identity_assignment_kv" {
  scope                = data.azurerm_key_vault.cbd_global_kv.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cbd_plat_agw_identity.principal_id
}

resource "azurerm_key_vault_access_policy" "cbd_plat_kvp_managed_identity_agw" {
  key_vault_id = data.azurerm_key_vault.cbd_global_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.cbd_plat_agw_identity.principal_id

  secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore"]
  key_permissions         = ["Get", "List", "Create", "Import", "Delete", "Backup", "Restore", "GetRotationPolicy"]
  certificate_permissions = ["Get", "List", "Delete", "Create", "Update", "Purge"]
}

# Application Gateway
resource "azurerm_application_gateway" "cbd_plat_appgateway" {
  name                = "cbd-${var.platform_env}-appgateway"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
  location            = data.azurerm_resource_group.cbd_plat_rg.location
  enable_http2        = true
  
  lifecycle {
    # this prevents changes made by aks from being reset on each terraform run
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      redirect_configuration,
      request_routing_rule,
      ssl_certificate,
      tags,
      url_path_map,
    ]
  }

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 0
    max_capacity = 2
  }

  zones = [1, 2, 3]

  gateway_ip_configuration {
    name      = "cbd-plat-appgateway-ip-config"
    subnet_id = azurerm_subnet.cbd_plat_appgateway_subnet.id
  }

  frontend_ip_configuration {
    name                 = "cbd-plat-appgateway-fe-ip"
    public_ip_address_id = azurerm_public_ip.cbd_plat_appgateway_ip.id
  }

  frontend_port {
    name = "cbd-plat-appgateway-fe-port"
    port = 443
  }

  ssl_certificate {
    name                = "cbd-appgateway-ssl-cert"
    key_vault_secret_id = data.azurerm_key_vault_certificate.cbd_plat_appgateway_cert.secret_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.cbd_plat_agw_identity.id ]
  }

  http_listener {
    name                           = "cbd-plat-appgateway-http-lstn"
    frontend_ip_configuration_name = "cbd-plat-appgateway-fe-ip"
    frontend_port_name             = "cbd-plat-appgateway-fe-port"
    protocol                       = "Https"
    ssl_certificate_name           = "cbd-plat-appgateway-ssl-cert"
  }

  backend_address_pool {
    name = "cbd-plat-appgateway-be-ap"
  }

  backend_http_settings {
    name                  = "cbd-plat-appgateway-be-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  request_routing_rule {
    name                       = "cbd-plat-appgateway-req-rt"
    rule_type                  = "Basic"
    http_listener_name         = "cbd-plat-appgateway-http-lstn"
    backend_address_pool_name  = "cbd-plat-appgateway-be-ap"
    backend_http_settings_name = "cbd-plat-appgateway-be-http-settings"
    priority                   = 9
  }

  tags = local.tags
}