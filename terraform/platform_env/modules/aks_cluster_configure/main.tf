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

#resource "kubernetes_namespace" "cbd_plat_aks_ingress_nginx_namespace" {
#  metadata {
#    name = "ingress-nginx"
#  }
#}

resource "helm_release" "cbd_plat_helm_nginx" {
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  #version          = "4.10.1"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path\""
    value = "/healthz"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
}