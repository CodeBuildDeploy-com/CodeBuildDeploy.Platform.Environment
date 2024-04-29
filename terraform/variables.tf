variable "location" {
  type        = string
  description = "Azure Region where all the resources will be provisioned"
  default     = "uksouth"
}

variable "environment" {
  type        = string
  description = "This variable defines the Environment"
  default     = "non-prod"
}

variable "product" {
  type        = string
  description = "This variable defines the Product"
  default     = "CodeBuildDeploy"
}

variable "description" {
  type        = string
  description = "This variable defines the description"
  default     = "The CodeBuildDeploy Components"
}