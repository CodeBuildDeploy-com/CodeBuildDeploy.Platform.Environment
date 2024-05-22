# Mark Pollard
resource "azurerm_role_assignment" "cbd_global_subscription_owner_role_assignment_mark_pollard" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.mark_pollard.object_id
}

resource "azurerm_role_assignment" "cbd_global_subscription_aks_cluster_admin_role_assignment_mark_pollard" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = data.azuread_user.mark_pollard.object_id
}

resource "azurerm_role_assignment" "cbd_plat_subscription_aks_cluster_rbac_admin_role_assignment_mark_pollard" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azuread_user.mark_pollard.object_id
}

# Andrew White
resource "azurerm_role_assignment" "cbd_global_subscription_owner_role_assignment_andrew_white" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.andrew_white.object_id
}

resource "azurerm_role_assignment" "cbd_global_subscription_aks_cluster_admin_role_assignment_andrew_white" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = data.azuread_user.andrew_white.object_id
}

resource "azurerm_role_assignment" "cbd_plat_subscription_aks_cluster_rbac_admin_role_assignment_andrew_white" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azuread_user.andrew_white.object_id
}