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

variable "environment" {
  type        = string
  description = "This variable defines the overarching environment, including common infrastructure"
  default     = "nonprod"
}

variable "environment_spoke" {
  type        = string
  description = "This variable defines the environment spoke, nested spokes of the environment"
  default     = "non-prod"
}