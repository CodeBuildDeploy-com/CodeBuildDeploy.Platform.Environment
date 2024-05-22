data "azurerm_client_config" "current" {}

data "azuread_user" "mark_pollard" {
  object_id = "61b2f66f-9557-45be-bd1e-91f9fa7da71f"
}

data "azuread_user" "andrew_white" {
  object_id = "42facefd-9dc4-4937-a71d-09b21e0e7f69"
}