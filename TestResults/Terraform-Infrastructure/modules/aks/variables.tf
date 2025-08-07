# AKS Module Variables

# Basic Configuration
variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "secondary_location" {
  description = "The secondary Azure region for geo-replication"
  type        = string
}

variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

# AKS Configuration
variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use"
  type        = string
  default     = "1.28.3"
}

variable "subnet_id" {
  description = "The subnet ID where AKS nodes will be deployed"
  type        = string
}

variable "pod_subnet_id" {
  description = "The subnet ID for pod networking (CNI overlay)"
  type        = string
}

variable "api_server_subnet_id" {
  description = "The subnet ID for API server VNet integration"
  type        = string
  default     = null
}

variable "vnet_id" {
  description = "The VNet ID for role assignments"
  type        = string
}

# Container Registry
variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
}

# Node Pools Configuration
variable "node_pools" {
  description = "Configuration for AKS node pools"
  type = object({
    system = object({
      vm_size    = string
      node_count = number
      min_count  = number
      max_count  = number
    })
    user = object({
      vm_size    = string
      node_count = number
      min_count  = number
      max_count  = number
    })
    spot = object({
      vm_size        = string
      node_count     = number
      min_count      = number
      max_count      = number
      spot_max_price = number
    })
  })
  default = {
    system = {
      vm_size    = "Standard_D4s_v3"
      node_count = 3
      min_count  = 3
      max_count  = 10
    }
    user = {
      vm_size    = "Standard_D4s_v3"
      node_count = 3
      min_count  = 3
      max_count  = 20
    }
    spot = {
      vm_size        = "Standard_D4s_v3"
      node_count     = 0
      min_count      = 0
      max_count      = 10
      spot_max_price = 0.5
    }
  }
}

variable "enable_spot_instances" {
  description = "Whether to enable spot instance node pool"
  type        = bool
  default     = true
}

# Security Configuration
variable "admin_group_object_ids" {
  description = "List of Azure AD group object IDs that will have admin access to the cluster"
  type        = list(string)
  default     = []
}

variable "private_cluster_enabled" {
  description = "Whether to create a private AKS cluster"
  type        = bool
  default     = true
}

variable "private_dns_zone_id" {
  description = "The private DNS zone ID for the AKS cluster"
  type        = string
  default     = "System"
}

# Monitoring
variable "log_analytics_workspace_id" {
  description = "The Log Analytics workspace ID for monitoring"
  type        = string
}

# Key Vault
variable "key_vault_id" {
  description = "The Key Vault ID for storing secrets"
  type        = string
}

# Private Endpoints
variable "enable_private_endpoints" {
  description = "Whether to enable private endpoints"
  type        = bool
  default     = true
}

variable "private_endpoint_subnet_id" {
  description = "The subnet ID for private endpoints"
  type        = string
  default     = null
}

variable "acr_private_dns_zone_id" {
  description = "The private DNS zone ID for ACR"
  type        = string
  default     = null
}
