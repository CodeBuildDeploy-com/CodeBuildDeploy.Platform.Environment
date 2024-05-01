variable "product" {
  type        = string
  description = "This variable defines the Product"
  default     = "CodeBuildDeploy"
}

variable "location" {
  type        = string
  description = "Azure Region where all the resources will be provisioned"
  default     = "uksouth"
}

variable "environment" {
  type        = string
  description = "This variable defines the overarching environment, including common infrastructure"
  default     = "non-prod"
}

variable "environment_spoke" {
  type        = string
  description = "This variable defines the environment spoke, nested spokes of the environment"
  default     = "non-prod"
}