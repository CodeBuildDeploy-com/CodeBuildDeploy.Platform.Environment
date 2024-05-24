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

variable "container_registry" {
  type        = string
  description = "The name of the container registry e.g. codebuilddeploy.azurecr.io"
}

variable "container_registry_username" {
  type        = string
  description = "The name of the user to access the container registry"
}

variable "container_registry_email" {
  type        = string
  description = "The email of the user to access the container registry"
  default     = "ServicePrincipal@AzureRM"
}