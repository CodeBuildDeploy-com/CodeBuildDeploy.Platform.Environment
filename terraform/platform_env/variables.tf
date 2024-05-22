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
}

variable "address_prefixes_platform_vnet" {
  description = "Address Prefixes for the Platform Env VNet"
  type        = list(string)
}

variable "address_prefixes_appgateway_subnet" {
  description = "Address Prefixes for the App gateway subnet"
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

variable "aks_service_cidr" {
  type        = string
  description = "The Network Range used by the Kubernetes service."
}

variable "aks_dns_service_ip" {
  type        = string
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)"
}

variable "container_registry" {
  type        = string
  description = "The name of the container registry e.g. codebuilddeploy.azurecr.io"
}

variable "container_registry_username" {
  type        = string
  description = "The name of the user to access the container registry"
}