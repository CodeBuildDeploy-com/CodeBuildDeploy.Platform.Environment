def creates_release($address; $name; $namespace):
  any(.[]; .address == $address
    and .change.actions == ["create"]
    and .change.after.name == $name
    and .change.after.namespace == $namespace);

[.resource_changes[] |
  select(.mode == "managed" and (.change.actions != ["no-op"] or .previous_address != null))
]
| if $phase != "mesh"
    or any(.[]; .previous_address != null)
    or length != 3
    or (creates_release("helm_release.istio_base[0]"; "istio-base"; "istio-system") | not)
    or (creates_release("helm_release.istiod[0]"; "istiod"; "istio-system") | not)
    or (creates_release("helm_release.dev_istio_gateway[0]"; "cbd-dev-istio-gateway"; "cbd-nonprod-dev") | not)
    or any(.[]; .change.after.namespace == "istio-system" and .change.after.version != "1.32.0") then
    error("Expected only the new non-prod Istio control plane and ingress Helm releases")
  else
    "Verified non-prod Istio 1.32.0 control-plane and ingress releases"
  end
