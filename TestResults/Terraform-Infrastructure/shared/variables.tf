# Shared Variables for E-Commerce Platform
# This file contains common variables used across all environments

variable "project_name" {
  description = "Name of the project/application"
  type        = string
  default     = "ecommerce"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Primary Azure region"
  type        = string
  default     = "East US 2"
}

variable "secondary_location" {
  description = "Secondary Azure region for disaster recovery"
  type        = string
  default     = "West US 2"
}

variable "resource_group_name" {
  description = "Resource group name (will be auto-generated if not provided)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

# Networking Variables
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_configurations" {
  description = "Subnet configurations"
  type = map(object({
    address_prefixes = list(string)
    service_endpoints = list(string)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  }))
  
  default = {
    "application-gateway" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = []
    }
    "aks-nodes" = {
      address_prefixes  = ["10.0.2.0/23"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
    }
    "aks-pods" = {
      address_prefixes  = ["10.0.4.0/22"]
      service_endpoints = []
    }
    "database" = {
      address_prefixes  = ["10.0.8.0/24"]
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
    "private-endpoints" = {
      address_prefixes  = ["10.0.9.0/24"]
      service_endpoints = []
    }
  }
}

# AKS Variables
variable "kubernetes_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
  default     = "1.28.5"
}

variable "aks_node_pools" {
  description = "AKS node pool configurations"
  type = map(object({
    vm_size             = string
    node_count          = number
    min_count          = number
    max_count          = number
    max_pods           = number
    availability_zones = list(string)
    node_taints        = list(string)
    node_labels        = map(string)
  }))
  
  default = {
    system = {
      vm_size             = "Standard_D4s_v3"
      node_count          = 3
      min_count          = 3
      max_count          = 5
      max_pods           = 30
      availability_zones  = ["1", "2", "3"]
      node_taints        = ["CriticalAddonsOnly=true:NoSchedule"]
      node_labels        = { "workload" = "system" }
    }
    user = {
      vm_size             = "Standard_D8s_v3"
      node_count          = 6
      min_count          = 3
      max_count          = 50
      max_pods           = 50
      availability_zones  = ["1", "2", "3"]
      node_taints        = []
      node_labels        = { "workload" = "user" }
    }
  }
}

# Database Variables
variable "sql_server_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "sql_databases" {
  description = "SQL Database configurations"
  type = map(object({
    edition                     = string
    service_objective_name     = string
    max_size_gb               = number
    zone_redundant            = bool
    backup_retention_days     = number
    geo_backup_enabled        = bool
    threat_detection_enabled  = bool
  }))
  
  default = {
    users = {
      edition                    = "Standard"
      service_objective_name    = "S2"
      max_size_gb              = 250
      zone_redundant           = false
      backup_retention_days    = 7
      geo_backup_enabled       = true
      threat_detection_enabled = true
    }
    orders = {
      edition                    = "Standard" 
      service_objective_name    = "S3"
      max_size_gb              = 500
      zone_redundant           = false
      backup_retention_days    = 35
      geo_backup_enabled       = true
      threat_detection_enabled = true
    }
    payments = {
      edition                    = "Premium"
      service_objective_name    = "P2"
      max_size_gb              = 500
      zone_redundant           = true
      backup_retention_days    = 35
      geo_backup_enabled       = true
      threat_detection_enabled = true
    }
  }
}

# Cosmos DB Variables
variable "cosmosdb_configurations" {
  description = "Cosmos DB configurations"
  type = map(object({
    consistency_policy = object({
      consistency_level       = string
      max_interval_in_seconds = number
      max_staleness_prefix    = number
    })
    geo_locations = list(object({
      location          = string
      failover_priority = number
      zone_redundant    = bool
    }))
    capabilities = list(string)
  }))
  
  default = {
    products = {
      consistency_policy = {
        consistency_level       = "Session"
        max_interval_in_seconds = 86400
        max_staleness_prefix    = 200000
      }
      geo_locations = [
        {
          location          = "East US 2"
          failover_priority = 0
          zone_redundant    = true
        },
        {
          location          = "West US 2"
          failover_priority = 1
          zone_redundant    = true
        }
      ]
      capabilities = ["EnableServerless"]
    }
    sessions = {
      consistency_policy = {
        consistency_level       = "Strong"
        max_interval_in_seconds = 300
        max_staleness_prefix    = 100000
      }
      geo_locations = [
        {
          location          = "East US 2"
          failover_priority = 0
          zone_redundant    = false
        }
      ]
      capabilities = ["EnableServerless"]
    }
  }
}

# Redis Cache Variables
variable "redis_configurations" {
  description = "Redis Cache configurations"
  type = map(object({
    capacity                      = number
    family                       = string
    sku_name                     = string
    enable_non_ssl_port          = bool
    minimum_tls_version          = string
    public_network_access_enabled = bool
    redis_version                = string
    zones                        = list(string)
  }))
  
  default = {
    session = {
      capacity                      = 1
      family                       = "P"
      sku_name                     = "Premium"
      enable_non_ssl_port          = false
      minimum_tls_version          = "1.2"
      public_network_access_enabled = false
      redis_version                = "6"
      zones                        = ["1", "2", "3"]
    }
    cache = {
      capacity                      = 3
      family                       = "P"
      sku_name                     = "Premium"
      enable_non_ssl_port          = false
      minimum_tls_version          = "1.2"
      public_network_access_enabled = false
      redis_version                = "6"
      zones                        = ["1", "2", "3"]
    }
  }
}

# Front Door Variables
variable "front_door_sku" {
  description = "Front Door SKU"
  type        = string
  default     = "Premium_AzureFrontDoor"
  
  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.front_door_sku)
    error_message = "Front Door SKU must be either Standard_AzureFrontDoor or Premium_AzureFrontDoor."
  }
}

# Monitoring Variables
variable "log_analytics_retention_days" {
  description = "Log Analytics workspace retention in days"
  type        = number
  default     = 30
  
  validation {
    condition     = var.log_analytics_retention_days >= 30 && var.log_analytics_retention_days <= 730
    error_message = "Log Analytics retention must be between 30 and 730 days."
  }
}

variable "enable_application_insights" {
  description = "Enable Application Insights"
  type        = bool
  default     = true
}

# Security Variables
variable "key_vault_sku" {
  description = "Key Vault SKU"
  type        = string
  default     = "premium"
  
  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be either standard or premium."
  }
}

variable "enable_rbac_authorization" {
  description = "Enable RBAC authorization for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_network_acls" {
  description = "Key Vault network ACLs"
  type = object({
    default_action = string
    bypass         = string
    ip_rules       = list(string)
  })
  
  default = {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = []
  }
}

# Cost Optimization Variables
variable "enable_auto_scaling" {
  description = "Enable auto-scaling for applicable services"
  type        = bool
  default     = true
}

variable "enable_spot_instances" {
  description = "Enable spot instances for non-critical workloads"
  type        = bool
  default     = false
}

variable "schedule_shutdown" {
  description = "Schedule for automatic shutdown of dev resources"
  type = object({
    enabled   = bool
    time_zone = string
    shutdown  = string
    startup   = string
  })
  
  default = {
    enabled   = false
    time_zone = "Eastern Standard Time"
    shutdown  = "19:00"
    startup   = "08:00"
  }
}

# Backup and Disaster Recovery Variables
variable "backup_configurations" {
  description = "Backup configurations"
  type = object({
    vault_redundancy_type = string
    backup_policies = object({
      daily_retention_days   = number
      weekly_retention_weeks = number
      monthly_retention_months = number
      yearly_retention_years = number
    })
  })
  
  default = {
    vault_redundancy_type = "GeoRedundant"
    backup_policies = {
      daily_retention_days     = 30
      weekly_retention_weeks   = 12
      monthly_retention_months = 12
      yearly_retention_years   = 7
    }
  }
}

variable "enable_disaster_recovery" {
  description = "Enable disaster recovery setup"
  type        = bool
  default     = true
}

# Feature Flags
variable "enable_api_management" {
  description = "Enable API Management (adds significant cost)"
  type        = bool
  default     = false
}

variable "enable_private_endpoints" {
  description = "Enable private endpoints for PaaS services"
  type        = bool
  default     = true
}

variable "enable_ddos_protection" {
  description = "Enable DDoS Protection Standard"
  type        = bool
  default     = true
}

variable "enable_waf" {
  description = "Enable Web Application Firewall"
  type        = bool
  default     = true
}
