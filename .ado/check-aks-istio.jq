def creates_release($address; $name; $namespace):
  any(.[]; .address == $address
    and .change.actions == ["create"]
    and .change.after.name == $name
    and .change.after.namespace == $namespace);

[.resource_changes[] |
  select(.mode == "managed" and (.change.actions != ["no-op"] or .previous_address != null))
]
| if any(.[]; .previous_address != null) then
    error("Unexpected resource move in the Istio plan")
  elif $phase == "gateway" then
    if length != 1
      or .[0].address != "helm_release.dev_istio_gateway[0]"
      or .[0].change.actions != ["update"]
      or .[0].change.after.name != "cbd-dev-istio-gateway"
      or .[0].change.after.namespace != "cbd-nonprod-dev" then
      error("Expected only an in-place update to the non-prod Istio gateway Helm release")
    else
      "Verified non-prod Istio ingress Helm update"
    end
  elif $phase != "mesh"
    or length != 3
    or (creates_release("helm_release.istio_base[0]"; "istio-base"; "istio-system") | not)
    or (creates_release("helm_release.istiod[0]"; "istiod"; "istio-system") | not)
    or (creates_release("helm_release.dev_istio_gateway[0]"; "cbd-dev-istio-gateway"; "cbd-nonprod-dev") | not)
    or any(.[]; .change.after.namespace == "istio-system" and .change.after.version != "1.32.0") then
    error("Expected only the new non-prod Istio control plane and ingress Helm releases")
  else
    "Verified non-prod Istio 1.32.0 control-plane and ingress releases"
  end
