resource "kubernetes_secret" "cbd_plat_kubernetes_pull_secret" {
  metadata {
    name = "cbd-pull-secret"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.container_registry}" = {
          "username" = var.container_registry_username
          "password" = data.azurerm_key_vault_secret.cbd_global_acr_access_key.value
          "email"    = var.container_registry_email
          "auth"     = base64encode("${var.container_registry_username}:${data.azurerm_key_vault_secret.cbd_global_acr_access_key.value}")
        }
      }
    })
  }
}