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

variable "subscription_friendly_name" {
  type        = string
  description = "This variable is a short name version of the subscription being used for the platform"
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

variable "aks_overlay_pod_cidr" {
  type        = string
  description = "Private pod CIDR for Azure CNI Overlay"
  default     = null
}

variable "aks_istio_version" {
  type        = string
  description = "Helm chart version for self-managed Istio"
  default     = null
}

variable "aks_gateway_api_enabled" {
  type        = bool
  description = "Enable the AKS-managed Gateway API definitions"
  default     = false
}

variable "aks_istio_gateway_enabled" {
  type        = bool
  description = "Deploy the CodeBuildDeploy dev routes through the Istio ingress gateway"
  default     = false
}

variable "aks_system_pool_version" {
  type        = string
  description = "Override the system pool version during separate AKS maintenance"
  default     = null
}

variable "aks_system_pool_vm_size" {
  type        = string
  description = "The SKU to be used by the AKS system node pool"
}

variable "aks_system_pool_min_count" {
  type        = number
  description = "The minimum count in the AKS system node pool"
}

variable "aks_system_pool_max_count" {
  type        = number
  description = "The maximum count in the AKS system node pool"
}

variable "container_registry" {
  type        = string
  description = "The name of the container registry e.g. codebuilddeploynonprod.azurecr.io"
}

variable "container_registry_username" {
  type        = string
  description = "The name of the user to access the container registry"
}