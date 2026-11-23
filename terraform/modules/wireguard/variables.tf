variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "peer_endpoint" {
  type = string
}

variable "peer_public_key" {
  type = string
}

variable "tunnel_address" {
  type = string
}

variable "peer_tunnel_cidr" {
  type = string
}

variable "aks_subnet_cidrs" {
  type = list(string)
}

variable "admin_ssh_public_key" {
  type = string
}

variable "tags" {
  type = map(string)
}
