# Development Environment Configuration
# This file contains development-specific settings for the e-commerce platform

# Core Configuration
project_name = "ecommerce"
environment  = "dev"
location     = "East US 2" 
secondary_location = "West US 2"

# Networking Configuration  
vnet_address_space = ["10.1.0.0/16"]

subnet_configurations = {
  "application-gateway" = {
    address_prefixes  = ["10.1.1.0/24"]
    service_endpoints = []
  }
  "aks-nodes" = {
    address_prefixes  = ["10.1.2.0/23"] 
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
  }
  "aks-pods" = {
    address_prefixes  = ["10.1.4.0/22"]
    service_endpoints = []
  }
  "database" = {
    address_prefixes  = ["10.1.8.0/24"]
    service_endpoints = ["Microsoft.Sql"]
  }
  "private-endpoints" = {
    address_prefixes  = ["10.1.9.0/24"]
    service_endpoints = []
  }
}

# AKS Configuration (Smaller for dev)
kubernetes_version = "1.28.5"

aks_node_pools = {
  system = {
    vm_size             = "Standard_D2s_v3"
    node_count          = 1
    min_count          = 1
    max_count          = 3
    max_pods           = 30
    availability_zones  = ["1"]
    node_taints        = ["CriticalAddonsOnly=true:NoSchedule"]
    node_labels        = { "workload" = "system" }
  }
  user = {
    vm_size             = "Standard_D4s_v3"
    node_count          = 2
    min_count          = 1
    max_count          = 5
    max_pods           = 50
    availability_zones  = ["1"]
    node_taints        = []
    node_labels        = { "workload" = "user" }
  }
}

# Database Configuration (Basic tier for dev)
sql_databases = {
  users = {
    edition                    = "Basic"
    service_objective_name    = "Basic"
    max_size_gb              = 2
    zone_redundant           = false
    backup_retention_days    = 7
    geo_backup_enabled       = false
    threat_detection_enabled = false
  }
  orders = {
    edition                    = "Basic"
    service_objective_name    = "Basic"
    max_size_gb              = 2
    zone_redundant           = false
    backup_retention_days    = 7
    geo_backup_enabled       = false
    threat_detection_enabled = false
  }
  payments = {
    edition                    = "Standard"
    service_objective_name    = "S0"
    max_size_gb              = 10
    zone_redundant           = false
    backup_retention_days    = 7
    geo_backup_enabled       = false
    threat_detection_enabled = true
  }
}

# Cosmos DB Configuration (Serverless for dev)
cosmosdb_configurations = {
  products = {
    consistency_policy = {
      consistency_level       = "Session"
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
  sessions = {
    consistency_policy = {
      consistency_level       = "Session"
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

# Redis Cache Configuration (Basic tier for dev)
redis_configurations = {
  session = {
    capacity                      = 0
    family                       = "C"
    sku_name                     = "Basic"
    enable_non_ssl_port          = false
    minimum_tls_version          = "1.2"
    public_network_access_enabled = true
    redis_version                = "6"
    zones                        = []
  }
  cache = {
    capacity                      = 1
    family                       = "C"
    sku_name                     = "Standard"
    enable_non_ssl_port          = false
    minimum_tls_version          = "1.2"
    public_network_access_enabled = true
    redis_version                = "6"
    zones                        = []
  }
}

# Front Door Configuration (Standard for dev)
front_door_sku = "Standard_AzureFrontDoor"

# Monitoring Configuration  
log_analytics_retention_days = 30
enable_application_insights  = true

# Security Configuration
key_vault_sku              = "standard"
enable_rbac_authorization  = true

key_vault_network_acls = {
  default_action = "Allow"  # More permissive for dev
  bypass         = "AzureServices"
  ip_rules       = []
}

# Feature Flags (Cost optimized for dev)
enable_api_management     = false
enable_private_endpoints  = false  # Disabled for cost savings in dev
enable_ddos_protection   = false   # Disabled for cost savings in dev
enable_waf               = true    # Keep for testing WAF rules
enable_auto_scaling      = true
enable_spot_instances    = false   # Can enable for further cost savings
enable_disaster_recovery = false   # Disabled for dev

# Cost Optimization (Auto-shutdown for dev)
schedule_shutdown = {
  enabled   = true
  time_zone = "Eastern Standard Time"
  shutdown  = "19:00"
  startup   = "08:00"
}

# Backup Configuration (Minimal for dev)
backup_configurations = {
  vault_redundancy_type = "LocallyRedundant"
  backup_policies = {
    daily_retention_days     = 7
    weekly_retention_weeks   = 4
    monthly_retention_months = 3
    yearly_retention_years   = 1
  }
}

# Common Tags for Development
tags = {
  BusinessOwner    = "E-Commerce Dev Team"
  TechnicalOwner   = "Platform Team"
  CostCenter      = "E-Commerce Development"
  ProjectCode     = "ECOM-DEV-2024"
  AutoShutdown    = "true"
  BackupRequired  = "false"
  MonitoringLevel = "Basic"
  ComplianceLevel = "Development"
  SLA             = "99.0%"
}
