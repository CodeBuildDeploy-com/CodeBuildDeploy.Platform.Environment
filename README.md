# Introduction 
Repository for provissioning the CodeBuildDeploy platform in Azure

# azinit
This folder contains a few powershell scripts for creating the terraform build ad account and creating the terraform state storage account blobs

# azureDevOps
This folder contains the Azure DevOps (ADO) pipelines

# terraform
This folder contains the terraform used to provission the acual environments and all its associated infrastructure.

# Key Vault Manual Secrets
## Secrets
```bash
az keyvault secret set --vault-name "cbd-enterprise-kv" --name "cbd-nonprod-bastion-ssh-key" --file "id_rsa.pub"
az keyvault secret set --vault-name "cbd-enterprise-kv" --name "cbd-nonprod-aks-ssh-key" --file "id_rsa.pub"
az keyvault secret set --vault-name "cbd-enterprise-kv" --name "cbd-global-acr-access-key" --value "Admin_Access_Key_Of_ACR"
az keyvault secret set --vault-name "cbd-enterprise-kv" --name "cbd-global-terraform-user-client-secret" --value "Terraform_Service_Principal_Secret"
az keyvault secret set --vault-name "cbd-enterprise-kv" --name "cbd-nonprod-tls-cert" --file "cert.pem"
az keyvault secret set --vault-name "cbd-enterprise-kv" --name "cbd-nonprod-tls-key" --file "privkey.pem"
```

## Certificates
```bash
cbd-nonprod-cert-pfx = Lets_Encrypt_Certificate
```