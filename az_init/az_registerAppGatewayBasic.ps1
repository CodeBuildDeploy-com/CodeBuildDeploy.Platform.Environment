# https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/preview-features
# https://learn.microsoft.com/en-us/cli/azure/feature
# https://learn.microsoft.com/en-us/azure/application-gateway/overview-v2

# login with service Principal
az login --service-principal \
  --username <APP_ID> \
  --password <PASSWORD> \
  --tenant <TENANT> \
  --allow-no-subscriptions

# select subscription
$ENTERPRISE_SUBSCRIPTION='b170b9e9-4ea8-400d-9348-bff06abbba1e'
az account set --subscription $ENTERPRISE_SUBSCRIPTION

#az feature show --namespace "Microsoft.Network" --name AllowApplicationGatewayBasicSku
az feature register --namespace "Microsoft.Network" --name AllowApplicationGatewayBasicSku
az provider register --namespace "Microsoft.Network"

$PREMIUM_SUBSCRIPTION='a8c29995-b368-4d2a-b32a-db619e53639d'
az account set --subscription $PREMIUM_SUBSCRIPTION

az feature register --namespace "Microsoft.Network" --name AllowApplicationGatewayBasicSku
az provider register --namespace "Microsoft.Network"