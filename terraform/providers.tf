terraform {
  required_version = ">= 1.12.2"

  required_providers {
    #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.68.0"
    }
    #https://registry.terraform.io/providers/hashicorp/azuread/latest/docs
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.8.0"
    }
    #https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8.1"
    }
    #https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
    #https://registry.terraform.io/providers/hashicorp/helm/latest/docs
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }
  }

  backend "azurerm" { }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

provider "azuread" {
  tenant_id = data.azurerm_client_config.current.tenant_id
}

data "azuread_service_principal" "current" {
  object_id = data.azurerm_client_config.current.object_id
}

data "azurerm_resource_group" "cbd_subscription_rg" {
  name = "cbd-${var.subscription_friendly_name}-rg"
}

data "azurerm_key_vault" "cbd_subscription_kv" {
  name                = "cbd-${var.subscription_friendly_name}-kv"
  resource_group_name = data.azurerm_resource_group.cbd_subscription_rg.name
}

data "azurerm_key_vault_secret" "cbd_global_terraform_user_secret" {
  name         = "cbd-global-terraform-user-client-secret"
  key_vault_id = data.azurerm_key_vault.cbd_subscription_kv.id
}

data "azurerm_key_vault_secret" "cbd_global_terraform_user_certificate" {
  name         = "cbd-global-terraform-user-client-certificate"
  key_vault_id = data.azurerm_key_vault.cbd_subscription_kv.id
}

data "azurerm_resource_group" "cbd_plat_rg" {
  depends_on = [module.cbd_plat_core_resources]

  name       = "cbd-${var.platform_env}-rg"
}

data "azurerm_kubernetes_cluster" "cbd_plat_aks_cluster" {
  depends_on          = [module.cbd_plat_aks_cluster]

  name                = "cbd-${var.platform_env}-aks-cluster"
  resource_group_name = data.azurerm_resource_group.cbd_plat_rg.name
}

provider "kubernetes" {
  host                   = module.cbd_plat_aks_cluster.cbd_plat_aks_cluster_host
  cluster_ca_certificate = base64decode(module.cbd_plat_aks_cluster.cbd_plat_aks_cluster_cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630",
      "--login",
      "spn",
      "--tenant-id",
      data.azurerm_client_config.current.tenant_id,
      "--client-id",
      data.azuread_service_principal.current.client_id,
      "--client-certificate",
      "${path.cwd}/terraform-cert.pem"
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.cbd_plat_aks_cluster.cbd_plat_aks_cluster_host
    cluster_ca_certificate = base64decode(module.cbd_plat_aks_cluster.cbd_plat_aks_cluster_cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args = [
        "get-token",
        "--environment",
        "AzurePublicCloud",
        "--server-id",
        "6dae42f8-4368-4678-94ff-3960e28e3630",
        "--login",
        "spn",
        "--tenant-id",
        data.azurerm_client_config.current.tenant_id,
        "--client-id",
        data.azuread_service_principal.current.client_id,
        "--client-certificate",
        "${path.cwd}/terraform-cert.pem"
      ]
    }
  }
}