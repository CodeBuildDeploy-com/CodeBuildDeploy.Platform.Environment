# Network
resource "azurerm_subnet" "cbd_plat_subnet_aks" {
  name                 = "cbd-${var.platform_env}-subnet-aks"
  resource_group_name  = data.azurerm_resource_group.cbd_plat_rg.name
  virtual_network_name = data.azurerm_virtual_network.cbd_plat_vnet.name
  address_prefixes     = var.address_prefixes_aks_subnet
}

resource "azurerm_subnet_network_security_group_association" "cbd_plat_aks_sga" {
  subnet_id                 = azurerm_subnet.cbd_plat_subnet_aks.id
  network_security_group_id = data.azurerm_network_security_group.cbd_plat_sg.id
}

# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = data.azurerm_resource_group.cbd_plat_rg.location
  include_preview = false
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "cbd_plat_aks_cluster" {
  name                              = "cbd-${var.platform_env}-aks-cluster"
  location                          = data.azurerm_resource_group.cbd_plat_rg.location
  resource_group_name               = data.azurerm_resource_group.cbd_plat_rg.name

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count, # this prevents aks from scaling as we reset the node count every time we deploy so we need to ignore changes to the node count
      default_node_pool.0.upgrade_settings
    ]
  }

  dns_prefix                        = "cbd-${var.platform_env}-aks-cluster"
  kubernetes_version                = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group               = "cbd-${var.platform_env}-nrg"
  role_based_access_control_enabled = true

  default_node_pool {
    name                 = "systempool"
    vm_size              = var.aks_system_pool_vm_size
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    zones                = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = var.aks_system_pool_max_count
    min_count            = var.aks_system_pool_min_count
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    vnet_subnet_id       = azurerm_subnet.cbd_plat_subnet_aks.id
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "${var.platform_env}"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
    tags = {
      "product"       = var.product
      "platform_env"  = var.platform_env
      "nodepool-type" = "system"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
  }

  linux_profile {
    admin_username = "adminuser"
    ssh_key {
      key_data = data.azurerm_key_vault_secret.cbd_plat_aks_ssh_key.value
    }
  }

  #oms_agent {
  #  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.cbd_plat_law.id
  #}

  network_profile {
    network_plugin    = "azure"
    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"
    service_cidr      = var.aks_service_cidr
    dns_service_ip    = var.aks_dns_service_ip
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cbd_plat_aks_identity.id]
  }

  # RBAC and Azure AD Integration Block
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    managed                = true
  }

  #ingress_application_gateway {
  #  gateway_id = data.azurerm_application_gateway.cbd_plat_appgateway.id
  #}

  tags = local.tags
}

# Azure AKS Outputs
output "cbd_plat_aks_cluster_id" {
  value = azurerm_kubernetes_cluster.cbd_plat_aks_cluster.id
}
output "cbd_plat_aks_cluster_name" {
  value = azurerm_kubernetes_cluster.cbd_plat_aks_cluster.name
}
output "aks_cluster_kubernetes_version" {
  value = azurerm_kubernetes_cluster.cbd_plat_aks_cluster.kubernetes_version
}

#resource "azurerm_kubernetes_cluster_node_pool" "cbd_plat_aks_cluster_nodepool1" {
#  name                  = "nodepool1"
#  vm_size               = "Standard_D2_v3"
#  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.cbd_plat_aks_cluster.id
#  vnet_subnet_id        = azurerm_subnet.cbd_plat_subnet_aks.id
#  zones                 = [1, 2, 3]
#  enable_auto_scaling   = true
#  max_count             = 2
#  min_count             = 0
#  mode                  = "User"
#  os_disk_size_gb       = 30
#  os_type               = "Linux"
#  priority              = "Regular"

#  lifecycle {
#    ignore_changes = [
#      node_count, # this prevents aks from scaling as we reset the node count every time we deploy so we need to ignore changes to the node count
#    ]
#  }

#  node_labels = {
#    "nodepool-type" = "user"
#    "environment"   = "${var.platform_env}"
#    "nodepoolos"    = "linux"
#    "app"           = "dotnet-apps"
#  }

#  tags = {
#    "product"       = var.product
#    "platform_env"  = var.platform_env
#    "nodepool-type" = "user"
#    "nodepoolos"    = "linux"
#    "app"           = "dotnet-apps"
#  }
#}