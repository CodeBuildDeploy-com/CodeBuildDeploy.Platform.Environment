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
  type      = string
  sensitive = true

  validation {
    condition     = can(regex("^[A-Za-z0-9+/]{43}=$", var.peer_public_key))
    error_message = "The WireGuard peer key must be a base64-encoded 32-byte public key."
  }
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
  type      = string
  sensitive = true

  validation {
    condition     = can(regex(local.ssh_public_key_format, trimspace(var.admin_ssh_public_key)))
    error_message = "The SSH key must be a single OpenSSH RSA or Ed25519 public key."
  }
}

variable "tags" {
  type = map(string)
}
