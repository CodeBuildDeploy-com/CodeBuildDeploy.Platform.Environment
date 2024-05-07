# login with service Principal
az login --service-principal \
  --username <APP_ID> \
  --password <PASSWORD> \
  --tenant <TENANT> \
  --allow-no-subscriptions

# select subscription
$ENTERPRISE_SUBSCRIPTION='b170b9e9-4ea8-400d-9348-bff06abbba1e'
az account set --subscription $ENTERPRISE_SUBSCRIPTION

$RESOURCE_GROUP_NAME='cbd-tfstate-rg'
$STORAGE_ACCOUNT_NAME="tfstatecbdnpd"
$BLOB_CONTAINER_NAME='tfstate-codebuilddeploy-blobc'
$LOCATION='uksouth'

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --location $LOCATION --sku Standard_LRS

# Get storage account key
$AccountKey=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $BLOB_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $AccountKey