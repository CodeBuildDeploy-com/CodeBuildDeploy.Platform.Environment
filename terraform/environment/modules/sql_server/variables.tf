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

variable "subscription_short_name" {
  type        = string
  description = "This variable is a short name version of the subscription being used for the platform"
}

variable "platform_env" {
  type        = string
  description = "This variable defines the overarching platform environment, including common infrastructure"
}

variable "address_prefixes_sqldb_subnet" {
  description = "Address Prefixes for the Azure SQL subnet"
  type        = list(string)
}