resource "azurerm_user_assigned_identity" "cbd_plat_aks_identity" {
  name                = "cbd-${var.platform_env}-aks-identity"
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
  location            = azurerm_resource_group.cbd_plat_rg.location
}

resource "azurerm_role_assignment" "cbd_plat_aks_identity_assignment_cluster" {
  scope                = azurerm_kubernetes_cluster.cbd_plat_aks_cluster.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cbd_plat_aks_identity.principal_id
}

resource "azurerm_role_assignment" "cbd_plat_aks_identity_assignment_cluster_admin" {
  scope                = azurerm_kubernetes_cluster.cbd_plat_aks_cluster.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azurerm_user_assigned_identity.cbd_plat_aks_identity.principal_id
}

resource "azurerm_role_assignment" "cbd_plat_aks_identity_assignment_vnet" {
  scope                = azurerm_virtual_network.cbd_plat_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.cbd_plat_aks_identity.principal_id
}

resource "azurerm_role_assignment" "cbd_plat_aks_identity_assignment_subscription_net" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.cbd_plat_aks_identity.principal_id
}

data "azurerm_subnet" "cbd_global_appgateway_subnet" {
  name                 = "cbd-global-appgateway-subnet"
  virtual_network_name = "cbd-global-vnet"
  resource_group_name  = "cbd-global-rg"
}

resource "azurerm_role_assignment" "cbd_plat_aks_identity_assignment_subnet_apg" {
  scope                = data.azurerm_subnet.cbd_global_appgateway_subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.cbd_plat_aks_identity.principal_id
}

data "azurerm_user_assigned_identity" "cbd_plat_aks_identity_ingress" {
  name                = "ingressapplicationgateway-${azurerm_kubernetes_cluster.cbd_plat_aks_cluster.name}"
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
}

data "azurerm_resource_group" "cbd_global_rg" {
  name     = "cbd-global-rg"
}

resource "azurerm_role_assignment" "cbd_plat_aks_identity_ingress_assignment_rg_nc" {
  scope                = data.azurerm_resource_group.cbd_global_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_user_assigned_identity.cbd_plat_aks_identity_ingress.principal_id
}

resource "azurerm_role_assignment" "cbd_plat_aks_identity_ingress_assignment_rg_read" {
  scope                = data.azurerm_resource_group.cbd_global_rg.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_user_assigned_identity.cbd_plat_aks_identity_ingress.principal_id
}