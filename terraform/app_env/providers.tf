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
  }

  backend "azurerm" { }
}

provider "azurerm" {
  features {}
}

provider "azapi" { }