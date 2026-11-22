def unchanged_except($paths):
  ([.after_unknown | paths(. == true)] + $paths) as $omitted
  | (.before | delpaths($omitted)) == (.after | delpaths($omitted));

[.resource_changes[] |
  select(.mode == "managed" and (.change.actions != ["no-op"] or .previous_address != null))
] as $changes
| if any($changes[]; .previous_address != null) then
    error("Unexpected resource move in the Istio plan")
  elif $phase == "mesh" then
    ($changes | map(select(.address == "module.cbd_plat_aks_cluster.azurerm_kubernetes_cluster.cbd_plat_aks_cluster" and .change.actions == ["update"])) | .[0].change) as $aks
    | ($changes | map(select(.address == "azapi_update_resource.aks_gateway_api[0]" and .change.actions == ["create"])) | .[0].change.after) as $gateway_api
    | if ($changes | length) != 2
        or $aks.after.name != "cbd-nonprod-aks-cluster"
        or $aks.after.kubernetes_version != "1.35.9"
        or $aks.after.default_node_pool[0].orchestrator_version != "1.35.9"
        or $aks.after.default_node_pool[0].vm_size != "Standard_B2s"
        or ($aks.before.service_mesh_profile // []) != []
        or $aks.after.service_mesh_profile[0].mode != "Istio"
        or $aks.after.service_mesh_profile[0].revisions != ["asm-1-31"]
        or ($aks | unchanged_except([["service_mesh_profile"]]) | not)
        or $gateway_api.body != {"properties":{"ingressProfile":{"gatewayAPI":{"installation":"Standard"}}}} then
        error("Expected only the existing non-prod cluster's Istio and Gateway API enablement")
      else
        "Verified non-prod Istio asm-1-31 and Managed Gateway API enablement"
      end
  elif $phase == "unmesh" then
    $changes[0].change as $aks
    | if ($changes | length) != 1
        or $changes[0].address != "module.cbd_plat_aks_cluster.azurerm_kubernetes_cluster.cbd_plat_aks_cluster"
        or $changes[0].change.actions != ["update"]
        or $aks.after.name != "cbd-nonprod-aks-cluster"
        or $aks.before.service_mesh_profile[0].mode != "Istio"
        or ($aks.after.service_mesh_profile // []) != []
        or ($aks | unchanged_except([["service_mesh_profile"]]) | not) then
        error("Expected only the removal of the managed Istio add-on")
      else
        "Verified removal of non-prod managed Istio"
      end
  elif $phase == "gateway" then
    if ($changes | length) != 1
        or $changes[0].address != "helm_release.dev_istio_gateway[0]"
        or $changes[0].change.actions != ["create"]
        or $changes[0].change.after.name != "cbd-dev-istio-gateway"
        or $changes[0].change.after.namespace != "cbd-nonprod-dev" then
      error("Expected only the addition of the non-prod Istio ingress gateway release")
    else
      "Verified non-prod Istio ingress gateway release"
    end
  else
    error("Unrecognised Istio phase")
  end
