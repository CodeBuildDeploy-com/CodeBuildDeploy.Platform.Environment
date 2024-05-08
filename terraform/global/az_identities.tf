resource "azurerm_user_assigned_identity" "cbd_global_agw_identity" {
  name                = "cbd-global-agw-identity"
  resource_group_name = azurerm_resource_group.cbd_global_rg.name
  location            = azurerm_resource_group.cbd_global_rg.location
}

resource "azurerm_role_assignment" "cbd_global_agw_identity_assignment_kv" {
  scope                = azurerm_key_vault.cbd_global_kv.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cbd_global_agw_identity.principal_id
}