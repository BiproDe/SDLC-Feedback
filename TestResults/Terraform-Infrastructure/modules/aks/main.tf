# Azure Kubernetes Service (AKS) Module
# This module creates and manages AKS cluster with multiple node pools and security configurations

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

# Random password for AKS admin
resource "random_password" "aks_admin_password" {
  length  = 32
  special = true
}

# Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false

  # Network access rules
  public_network_access_enabled = false
  network_rule_bypass_option   = "AzureServices"

  # Geo-replication for disaster recovery
  georeplications {
    location                = var.secondary_location
    zone_redundancy_enabled = true
    tags                    = var.tags
  }

  # Enable vulnerability scanning and trust policy
  trust_policy {
    enabled = true
  }

  retention_policy {
    enabled = true
    days    = 30
  }

  tags = var.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = var.kubernetes_version

  # Network profile
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    dns_service_ip      = "10.2.0.10"
    service_cidr        = "10.2.0.0/24"
    pod_subnet_id       = var.pod_subnet_id
    load_balancer_sku   = "standard"
  }

  # Default node pool
  default_node_pool {
    name                         = "system"
    vm_size                     = var.node_pools.system.vm_size
    node_count                  = var.node_pools.system.node_count
    min_count                   = var.node_pools.system.min_count
    max_count                   = var.node_pools.system.max_count
    enable_auto_scaling         = true
    enable_host_encryption      = true
    enable_node_public_ip       = false
    only_critical_addons_enabled = true
    orchestrator_version        = var.kubernetes_version
    os_disk_size_gb            = 128
    os_disk_type               = "Managed"
    os_sku                     = "Ubuntu"
    type                       = "VirtualMachineScaleSets"
    vnet_subnet_id             = var.subnet_id
    zones                      = ["1", "2", "3"]

    # Node labels
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.environment
      "nodepool"      = "system"
    }

    # Node taints for system workloads only
    node_taints = ["CriticalAddonsOnly=true:NoSchedule"]

    upgrade_settings {
      max_surge = "10%"
    }
  }

  # Service Principal or Managed Identity
  identity {
    type = "SystemAssigned"
  }

  # RBAC and Azure AD integration
  role_based_access_control_enabled = true
  
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = true
  }

  # Add-ons
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  microsoft_defender {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  workload_autoscaler_profile {
    keda_enabled                    = true
    vertical_pod_autoscaler_enabled = true
  }

  # HTTP application routing (disabled for production)
  http_application_routing_enabled = false

  # Private cluster configuration
  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = false

  # Upgrade configuration
  automatic_channel_upgrade = "patch"
  
  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [2, 3, 4]
    }
    not_allowed {
      start = "2024-12-25T00:00:00Z"
      end   = "2024-12-26T00:00:00Z"
    }
  }

  # Storage profile
  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  # API server access profile
  api_server_access_profile {
    vnet_integration_enabled = var.private_cluster_enabled
    subnet_id               = var.api_server_subnet_id
  }

  tags = var.tags

  depends_on = [
    azurerm_container_registry.acr
  ]
}

# User Node Pool for application workloads
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size              = var.node_pools.user.vm_size
  node_count           = var.node_pools.user.node_count
  min_count            = var.node_pools.user.min_count
  max_count            = var.node_pools.user.max_count
  enable_auto_scaling  = true
  enable_host_encryption = true
  enable_node_public_ip = false
  orchestrator_version  = var.kubernetes_version
  os_disk_size_gb      = 128
  os_disk_type         = "Managed"
  os_sku               = "Ubuntu"
  os_type              = "Linux"
  priority             = "Regular"
  spot_max_price       = -1
  vnet_subnet_id       = var.subnet_id
  zones                = ["1", "2", "3"]

  node_labels = {
    "nodepool-type" = "user"
    "environment"   = var.environment
    "nodepool"      = "user"
  }

  node_taints = []

  upgrade_settings {
    max_surge = "33%"
  }

  tags = var.tags
}

# Spot Instance Node Pool for cost optimization
resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  count = var.enable_spot_instances ? 1 : 0
  
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size              = var.node_pools.spot.vm_size
  node_count           = var.node_pools.spot.node_count
  min_count            = var.node_pools.spot.min_count
  max_count            = var.node_pools.spot.max_count
  enable_auto_scaling  = true
  enable_host_encryption = true
  enable_node_public_ip = false
  orchestrator_version  = var.kubernetes_version
  os_disk_size_gb      = 128
  os_disk_type         = "Managed"
  os_sku               = "Ubuntu"
  os_type              = "Linux"
  priority             = "Spot"
  spot_max_price       = var.node_pools.spot.spot_max_price
  eviction_policy      = "Delete"
  vnet_subnet_id       = var.subnet_id
  zones                = ["1", "2", "3"]

  node_labels = {
    "nodepool-type"    = "spot"
    "environment"      = var.environment
    "nodepool"         = "spot"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  upgrade_settings {
    max_surge = "33%"
  }

  tags = var.tags
}

# Role assignment for AKS to pull from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                           = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# Role assignment for AKS to manage network
resource "azurerm_role_assignment" "aks_network_contributor" {
  principal_id                     = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name             = "Network Contributor"
  scope                           = var.vnet_id
  skip_service_principal_aad_check = true
}

# Key Vault secrets for sensitive configurations
resource "azurerm_key_vault_secret" "aks_admin_password" {
  name         = "aks-admin-password"
  value        = random_password.aks_admin_password.result
  key_vault_id = var.key_vault_id
  content_type = "password"

  tags = var.tags
}

# Private endpoint for Container Registry
resource "azurerm_private_endpoint" "acr_endpoint" {
  count = var.enable_private_endpoints ? 1 : 0
  
  name                = "${var.acr_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.acr_name}-psc"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "acr-dns-zone-group"
    private_dns_zone_ids = [var.acr_private_dns_zone_id]
  }

  tags = var.tags
}
