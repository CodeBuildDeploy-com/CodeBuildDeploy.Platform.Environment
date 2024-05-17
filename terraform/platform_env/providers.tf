terraform {
  required_version = ">= 1.8.2"

  required_providers {
    #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.101.0"
    }
    #https://registry.terraform.io/providers/Azure/azapi/latest/docs
    azapi = {
      source = "Azure/azapi"
      version = "~>1.13.1"
    }
    #https://registry.terraform.io/providers/hashicorp/azuread/latest/docs
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
    #https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
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

provider "azapi" { }

provider "azuread" { }