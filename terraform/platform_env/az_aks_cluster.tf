# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = azurerm_resource_group.cbd_plat_rg.location
  include_preview = false
}

# Azure AKS Version
output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

# Create Azure AD Group in Active Directory for AKS Admins
resource "azuread_group" "cbd_plat_aks_administrators" {
  display_name     = "cbd-${var.platform_env}-aks-administrators"
  security_enabled = true
  description      = "Azure AKS Kubernetes administrators for the cbd-${var.platform_env}-aks-cluster."
}

# Azure AD Group Object Id
output "azure_ad_group_id" {
  value = azuread_group.cbd_plat_aks_administrators.id
}
output "azure_ad_group_objectid" {
  value = azuread_group.cbd_plat_aks_administrators.object_id
}

data "azurerm_key_vault" "cbd_global_kv" {
  name                = "cbd-global-kv1"
  resource_group_name = "cbd-global-rg"
}

data "azurerm_key_vault_secret" "cbd_plat_aks_ssh_key" {
  name         = "cbd-${var.platform_env}-aks-ssh-key"
  key_vault_id = data.azurerm_key_vault.cbd_global_kv.id
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "cbd_plat_aks_cluster" {
  name                = "cbd-${var.platform_env}-aks-cluster"
  location            = azurerm_resource_group.cbd_plat_rg.location
  resource_group_name = azurerm_resource_group.cbd_plat_rg.name
  dns_prefix          = "cbd-${var.platform_env}-aks-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "cbd-${var.platform_env}-nrg"

  default_node_pool {
    name                 = "systempool"
    vm_size              = "Standard_D2_v3"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    zones                = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
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

  # Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

  # Set Log Analytics Workspace
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.cbd_plat_law.id
  }

  # RBAC and Azure AD Integration Block
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    managed                = true
    admin_group_object_ids = [azuread_group.cbd_plat_aks_administrators.id]
  }

  # Linux Profile
  linux_profile {
    admin_username = "adminuser"
    ssh_key {
      key_data = data.azurerm_key_vault_secret.cbd_plat_aks_ssh_key.value
    }
  }

  # Network Profile
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

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

resource "azurerm_kubernetes_cluster_node_pool" "cbd_plat_aks_cluster_nodepool1" {
  zones                 = [1, 2, 3]
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cbd_plat_aks_cluster.id
  max_count             = 2
  min_count             = 0
  mode                  = "User"
  name                  = "nodepool1"
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 30
  os_type               = "Linux"
  vm_size               = "Standard_D2_v3"
  priority              = "Regular"
  node_labels = {
    "nodepool-type" = "user"
    "environment"   = "${var.platform_env}"
    "nodepoolos"    = "linux"
    "app"           = "dotnet-apps"
  }
  tags = {
    "product"       = var.product
    "platform_env"  = var.platform_env
    "nodepool-type" = "user"
    "nodepoolos"    = "linux"
    "app"           = "dotnet-apps"
  }
}