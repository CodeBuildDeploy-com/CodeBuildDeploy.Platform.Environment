# AzureRM manages the mesh profile. AzAPI manages the Gateway API installation.
resource "azapi_update_resource" "aks_gateway_api" {
  count = var.aks_gateway_api_enabled ? 1 : 0

  type        = "Microsoft.ContainerService/managedClusters@2026-03-01"
  resource_id = module.cbd_plat_aks_cluster.cbd_plat_aks_cluster_id
  body = {
    properties = {
      ingressProfile = {
        gatewayAPI = {
          installation = "Standard"
        }
      }
    }
  }
}

resource "helm_release" "dev_istio_gateway" {
  count = var.aks_istio_gateway_enabled ? 1 : 0

  name      = "cbd-dev-istio-gateway"
  namespace = "cbd-nonprod-dev"
  chart     = "${path.module}/helm/dev-istio-gateway"
  atomic    = true
  timeout   = 600

  depends_on = [azapi_update_resource.aks_gateway_api]
}
