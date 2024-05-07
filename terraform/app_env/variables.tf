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
  description = "This variable defines the overarching environment, including common infrastructure"
  default     = "nonprod"
}

variable "app_env" {
  type        = string
  description = "This variable defines the app environment spoke, nested apps of the platform environment"
  default     = "non-prod"
}