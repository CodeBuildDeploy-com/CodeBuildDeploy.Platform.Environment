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

variable "address_prefixes_appgateway_subnet" {
  description = "Address Prefixes for the App gateway subnet"
  type        = list(string)
}