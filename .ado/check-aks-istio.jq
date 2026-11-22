[.resource_changes[] |
  select(.mode == "managed" and (.change.actions != ["no-op"] or .previous_address != null))
]
| if $phase == "retire" then
    if length != 1
      or .[0].previous_address != null
      or .[0].address != "module.cbd_plat_aks_cluster_configure.helm_release.cbd_plat_helm_nginx"
      or .[0].change.actions != ["delete"]
      or .[0].change.before.name != "ingress-nginx"
      or .[0].change.before.namespace != "ingress-nginx" then
      error("Expected only the removal of the legacy ingress-nginx Helm release")
    else
      "Verified removal of only the legacy ingress-nginx Helm release"
    end
  elif $phase != "handoff"
    or length != 1
    or .[0].previous_address != null
    or .[0].address != "helm_release.dev_istio_gateway[0]"
    or .[0].change.actions != ["forget"]
    or .[0].change.before.name != "cbd-dev-istio-gateway"
    or .[0].change.before.namespace != "cbd-nonprod-dev" then
    error("Expected only the transfer of the existing Istio Helm release out of environment state")
  else
    "Verified non-prod Istio gateway ownership handoff without uninstalling Helm"
  end
