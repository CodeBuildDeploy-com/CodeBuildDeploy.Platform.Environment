# The AzureRM cluster resource does not expose the Managed Gateway API setting.
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

resource "helm_release" "istio_base" {
  count = var.aks_istio_version == null ? 0 : 1

  name             = "istio-base"
  chart            = "base"
  repository       = "https://blob.istio.io/istio-release/charts"
  version          = var.aks_istio_version
  namespace        = "istio-system"
  create_namespace = true
  take_ownership   = true
  atomic           = true

  depends_on = [azapi_update_resource.aks_gateway_api]
}

resource "helm_release" "istiod" {
  count = var.aks_istio_version == null ? 0 : 1

  name       = "istiod"
  chart      = "istiod"
  repository = "https://blob.istio.io/istio-release/charts"
  version    = var.aks_istio_version
  namespace  = "istio-system"
  atomic     = true
  values = [yamlencode({
    autoscaleEnabled = false
    replicaCount     = 1
    resources = {
      requests = {
        cpu    = "200m"
        memory = "512Mi"
      }
    }
    global = {
      defaultPodDisruptionBudget = { enabled = false }
    }
  })]

  depends_on = [helm_release.istio_base]
}

# Platform.App upgrades the existing Helm release directly.
removed {
  from = helm_release.dev_istio_gateway

  lifecycle {
    destroy = false
  }
}
