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
cbd-global-bastion-ssh-key              - SSH_Public_Key
cbd-nonprod-aks-ssh-key                 - SSH_Public_Key
cbd-global-acr-access-key               - Admin_Access_Key_Of_ACR
cbd-global-terraform-user-client-secret - Terraform_Service_Principal_Secret
```

## Certificates
```bash
cbd-nonprod-cert-pfx = Lets_Encrypt_Certificate
```