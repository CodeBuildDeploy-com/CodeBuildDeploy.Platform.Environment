resource "azurerm_public_ip" "cbd_global_appgateway_ip" {
  name                = "cbd-global-appgateway-ip"
  resource_group_name = azurerm_resource_group.cbd_global_rg.name
  location            = azurerm_resource_group.cbd_global_rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = [1, 2, 3]

  tags                = local.tags
}

data "azurerm_key_vault_certificate" "cbd_global_appgateway_cert" {
  name         = "codebuilddeploy-cert-pfx"
  key_vault_id = azurerm_key_vault.cbd_global_kv.id
}

resource "azurerm_application_gateway" "cbd_global_appgateway" {
  name                = "cbd-global-appgateway"
  resource_group_name = azurerm_resource_group.cbd_global_rg.name
  location            = azurerm_resource_group.cbd_global_rg.location
  enable_http2        = true

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
    name      = "cbd-global-appgateway-ip-config"
    subnet_id = azurerm_subnet.cbd_global_appgateway_subnet.id
  }

  frontend_ip_configuration {
    name                 = "cbd-global-appgateway-fe-ip"
    public_ip_address_id = azurerm_public_ip.cbd_global_appgateway_ip.id
  }

  frontend_port {
    name = "cbd-global-appgateway-fe-port"
    port = 443
  }

  ssl_certificate {
    name                = "cbd-global-appgateway-ssl-cert"
    key_vault_secret_id = data.azurerm_key_vault_certificate.cbd_global_appgateway_cert.secret_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.cbd_global_agw_identity.id ]
  }

  http_listener {
    name                           = "cbd-global-appgateway-http-lstn"
    frontend_ip_configuration_name = "cbd-global-appgateway-fe-ip"
    frontend_port_name             = "cbd-global-appgateway-fe-port"
    protocol                       = "Https"
    ssl_certificate_name           = "cbd-global-appgateway-ssl-cert"
  }

  backend_address_pool {
    name = "cbd_global_appgateway-be-ap"
  }

  backend_http_settings {
    name                  = "cbd-global-appgateway-be-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  request_routing_rule {
    name                       = "cbd-global-appgateway-req-rt"
    rule_type                  = "Basic"
    http_listener_name         = "cbd-global-appgateway-http-lstn"
    backend_address_pool_name  = "cbd_global_appgateway-be-ap"
    backend_http_settings_name = "cbd-global-appgateway-be-http-settings"
    priority                   = 9
  }

  tags = local.tags
}