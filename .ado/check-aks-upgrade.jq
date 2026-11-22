def unchanged_except($paths):
  ([.after_unknown | paths(. == true)] + $paths) as $omitted
  | (.before | delpaths($omitted)) == (.after | delpaths($omitted));

[.resource_changes[] |
  select(.mode == "managed" and (.change.actions != ["no-op"] or .previous_address != null))
] as $changes
| if ($changes | length) != 1 then
    error("Expected exactly one managed resource change in the AKS upgrade plan")
  else . end
| $changes[0]
| if .address != "module.cbd_plat_aks_cluster.azurerm_kubernetes_cluster.cbd_plat_aks_cluster"
    or .previous_address != null
    or .change.actions != ["update"] then
    error("Expected an in-place update of only the existing AKS cluster")
  else .change end
| if .after.name != "cbd-nonprod-aks-cluster" then
    error("Expected the non-prod AKS cluster")
  else . end
| if $overlay != "none" then
    if $version != "none"
      or (.before.network_profile[0].network_plugin_mode // "") != ""
      or .before.network_profile[0].network_plugin != "azure"
      or .after.network_profile[0].network_plugin != "azure"
      or .after.network_profile[0].network_plugin_mode != "overlay"
      or .after.network_profile[0].pod_cidr != "10.244.0.0/22"
      or .after.kubernetes_version != "1.34.12"
      or .after.default_node_pool[0].orchestrator_version != "1.33.8"
      or .after.default_node_pool[0].vm_size != "Standard_B2s"
      or .after.default_node_pool[0].name != "systempool"
      or .after.default_node_pool[0].vnet_subnet_id != .before.default_node_pool[0].vnet_subnet_id
      or (unchanged_except([
        ["network_profile", 0, "network_plugin_mode"],
        ["network_profile", 0, "pod_cidr"]
      ]) | not) then
      error("Expected only the approved Overlay settings, with the existing system pool and versions")
    else
      "Verified in-place Azure CNI Overlay conversion to 10.244.0.0/22"
    end
  elif .after.kubernetes_version != $version
    or .after.default_node_pool[0].orchestrator_version != $version then
    error("The non-prod control plane and system pool must both target " + $version)
  elif (unchanged_except([["kubernetes_version"], ["default_node_pool", 0, "orchestrator_version"]]) | not) then
    error("The plan contains additional AKS configuration changes")
  else
    "Verified the in-place non-prod AKS upgrade from " + .before.kubernetes_version + " to " + $version
  end
