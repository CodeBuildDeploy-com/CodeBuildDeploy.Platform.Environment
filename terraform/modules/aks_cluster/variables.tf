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

variable "address_prefixes_aks_subnet" {
  description = "Address Prefixes for the AKS subnet"
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