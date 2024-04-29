# subscriptions
$PREMIUM_SUBSCRIPTION='a8c29995-b368-4d2a-b32a-db619e53639d'
$ENTERPRISE_SUBSCRIPTION='b170b9e9-4ea8-400d-9348-bff06abbba1e'

# login to Azure
az login --use-device-code

# select subscription
az account set --subscription $ENTERPRISE_SUBSCRIPTION

# create a new Service Principal
$TERRAFORM_PRINCIPAL = az ad sp create-for-rbac --name codebuilddeploy-terraform -o json

# Assign the Contributor role to the SP
# replace <APP_ID> with appId from the newly created SP
az role assignment create --assignee <APP_ID> \
  --role Contributor \
  --scope /subscriptions/$ENTERPRISE_SUBSCRIPTION
az role assignment create --assignee <APP_ID> \
  --role Contributor \
  --scope /subscriptions/$PREMIUM_SUBSCRIPTION

# login with service Principal
az login --service-principal \
  --username <APP_ID> \
  --password <PASSWORD> \
  --tenant <TENANT> \
  --allow-no-subscriptions