$ENTERPRISE_SUBSCRIPTION='b170b9e9-4ea8-400d-9348-bff06abbba1e'

# login to Azure
az login --use-device-code

# select subscription
az account set --subscription $ENTERPRISE_SUBSCRIPTION

$RESOURCE_GROUP_NAME='tfstate-code-build-deploy-rg'
$STORAGE_ACCOUNT_NAME="tfstatecodebuilddeploysa"
$BLOB_CONTAINER_NAME='tfstate-code-build-deploy-blobc'
$LOCATION='uksouth'

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --location $LOCATION --sku Standard_LRS --encryption-services blob

# Get storage account key
$AccountKey=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $BLOB_CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $AccountKey