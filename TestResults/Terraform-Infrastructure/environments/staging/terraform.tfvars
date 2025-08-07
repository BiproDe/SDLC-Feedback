# Staging Environment Configuration  
# This file contains staging-specific settings for the e-commerce platform

# Core Configuration
project_name = "ecommerce"
environment  = "staging"
location     = "East US 2"
secondary_location = "West US 2"

# Networking Configuration
vnet_address_space = ["10.2.0.0/16"]

subnet_configurations = {
  "application-gateway" = {
    address_prefixes  = ["10.2.1.0/24"]
    service_endpoints = ["Microsoft.Web"]
  }
  "aks-nodes" = {
    address_prefixes  = ["10.2.2.0/23"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
  }
  "aks-pods" = {
    address_prefixes  = ["10.2.4.0/22"]
    service_endpoints = []
  }
  "database" = {
    address_prefixes  = ["10.2.8.0/24"]
    service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
  }
  "private-endpoints" = {
    address_prefixes  = ["10.2.9.0/24"]
    service_endpoints = []
  }
}

# AKS Configuration (Mid-size for staging)
kubernetes_version = "1.28.5"

aks_node_pools = {
  system = {
    vm_size             = "Standard_D4s_v3"
    node_count          = 2
    min_count          = 2
    max_count          = 4
    max_pods           = 30
    availability_zones  = ["1", "2"]
    node_taints        = ["CriticalAddonsOnly=true:NoSchedule"]
    node_labels        = { "workload" = "system" }
  }
  user = {
    vm_size             = "Standard_D8s_v3"
    node_count          = 3
    min_count          = 2
    max_count          = 10
    max_pods           = 50
    availability_zones  = ["1", "2"]
    node_taints        = []
    node_labels        = { "workload" = "user" }
  }
}

# Database Configuration (Standard tier for staging)
sql_databases = {
  users = {
    edition                    = "Standard"
    service_objective_name    = "S1"
    max_size_gb              = 50
    zone_redundant           = false
    backup_retention_days    = 14
    geo_backup_enabled       = true
    threat_detection_enabled = true
  }
  orders = {
    edition                    = "Standard"
    service_objective_name    = "S2"
    max_size_gb              = 100
    zone_redundant           = false
    backup_retention_days    = 14
    geo_backup_enabled       = true
    threat_detection_enabled = true
  }
  payments = {
    edition                    = "Standard"
    service_objective_name    = "S3"
    max_size_gb              = 100
    zone_redundant           = false
    backup_retention_days    = 14
    geo_backup_enabled       = true
    threat_detection_enabled = true
  }
  inventory = {
    edition                    = "Standard"
    service_objective_name    = "S1"
    max_size_gb              = 50
    zone_redundant           = false
    backup_retention_days    = 14
    geo_backup_enabled       = true
    threat_detection_enabled = true
  }
}

# Cosmos DB Configuration (Provisioned throughput for staging)
cosmosdb_configurations = {
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
        zone_redundant    = false
      },
      {
        location          = "West US 2"
        failover_priority = 1
        zone_redundant    = false
      }
    ]
    capabilities = ["EnableAggregationPipeline"]
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
    capabilities = []
  }
}

# Redis Cache Configuration (Standard/Premium for staging)
redis_configurations = {
  session = {
    capacity                      = 1
    family                       = "C"
    sku_name                     = "Standard"
    enable_non_ssl_port          = false
    minimum_tls_version          = "1.2"
    public_network_access_enabled = false
    redis_version                = "6"
    zones                        = []
  }
  cache = {
    capacity                      = 1
    family                       = "P"
    sku_name                     = "Premium"
    enable_non_ssl_port          = false
    minimum_tls_version          = "1.2"
    public_network_access_enabled = false
    redis_version                = "6"
    zones                        = ["1", "2"]
  }
}

# Front Door Configuration
front_door_sku = "Premium_AzureFrontDoor"

# Monitoring Configuration
log_analytics_retention_days = 90
enable_application_insights  = true

# Security Configuration
key_vault_sku              = "premium"
enable_rbac_authorization  = true

key_vault_network_acls = {
  default_action = "Deny"
  bypass         = "AzureServices"
  ip_rules       = [] # Add your IP addresses for staging access
}

# Feature Flags (Production-like for staging)
enable_api_management     = false  # Can enable for API testing
enable_private_endpoints  = true   # Test private networking
enable_ddos_protection   = false   # Cost optimization, but test in prod
enable_waf               = true
enable_auto_scaling      = true
enable_spot_instances    = false   # Not recommended for staging
enable_disaster_recovery = true    # Test DR procedures

# Cost Optimization (Limited auto-shutdown for staging)
schedule_shutdown = {
  enabled   = false  # Keep staging running for integration testing
  time_zone = "Eastern Standard Time" 
  shutdown  = "22:00"
  startup   = "06:00"
}

# Backup Configuration (Mid-tier for staging)
backup_configurations = {
  vault_redundancy_type = "GeoRedundant"
  backup_policies = {
    daily_retention_days     = 14
    weekly_retention_weeks   = 8
    monthly_retention_months = 6
    yearly_retention_years   = 2
  }
}

# Common Tags for Staging
tags = {
  BusinessOwner    = "E-Commerce Team"
  TechnicalOwner   = "Platform Team"
  CostCenter      = "E-Commerce Staging"
  ProjectCode     = "ECOM-STG-2024"
  MaintenanceWindow = "Sunday 01:00-04:00 EST"
  BackupRequired  = "true"
  MonitoringLevel = "Standard"
  ComplianceLevel = "Staging"
  SLA             = "99.5%"
}
