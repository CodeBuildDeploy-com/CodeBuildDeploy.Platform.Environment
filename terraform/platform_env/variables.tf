variable "product" {
  type        = string
  description = "This variable defines the Product"
  default     = "CodeBuildDeploy"
}

variable "default_location" {
  type        = string
  description = "Azure Region where resources will default to be provisioned to"
  default     = "uksouth"
}

variable "platform_env" {
  type        = string
  description = "This variable defines the overarching platform environment, including common infrastructure"
  default     = "non-prod"
}

variable "address_prefixes_platform_vnet" {
  description = "Address Prefixes for the Platform Env VNet"
  type        = list(string)
}

variable "address_prefixes_aks_subnet" {
  description = "Address Prefixes for the AKS subnet"
  type        = list(string)
}

variable "address_prefixes_sqldb_subnet" {
  description = "Address Prefixes for the Azure SQL subnet"
  type        = list(string)
}