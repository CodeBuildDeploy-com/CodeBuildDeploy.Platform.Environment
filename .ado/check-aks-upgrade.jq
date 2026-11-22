[.resource_changes[] |
  select(.mode == "managed" and (.change.actions != ["no-op"] or .previous_address != null))
] as $changes
| if ($changes | length) != 1 then
    error("Expected exactly one managed resource change in the AKS upgrade plan")
  else . end
| $changes[0]
| if .address != "module.cbd_plat_aks_cluster.azurerm_kubernetes_cluster.cbd_plat_aks_cluster"
    or .change.actions != ["update"] then
    error("Expected an in-place update of only the AKS cluster")
  else .change end
| if .after.name != "cbd-nonprod-aks-cluster"
    or .after.kubernetes_version != $version
    or .after.default_node_pool[0].orchestrator_version != $version then
    error("The non-prod control plane and system pool must both target " + $version)
  else . end
# Ignore values Terraform will only learn during the update, plus the two version pins.
| ([.after_unknown | paths(. == true)] +
    [["kubernetes_version"], ["default_node_pool", 0, "orchestrator_version"]]) as $omitted
| if (.before | delpaths($omitted)) != (.after | delpaths($omitted)) then
    error("The plan contains additional AKS configuration changes")
  else
    "Verified the in-place non-prod AKS upgrade from " + .before.kubernetes_version + " to " + $version
  end
