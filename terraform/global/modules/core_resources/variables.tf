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

variable "address_prefixes_global_vnet" {
  description = "Address Prefixes for the Global VNet"
  type        = list(string)
}