# Production Environment Variables
# Copy and customize these values for your production deployment

# Core Configuration
project_name = "ecommerce"
environment  = "prod"
location     = "East US 2"
secondary_location = "West US 2"

# Resource Group (leave empty for auto-generation)
resource_group_name = ""

# Networking Configuration
vnet_address_space = ["10.0.0.0/16"]

subnet_configurations = {
  "application-gateway" = {
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Web"]
  }
  "aks-nodes" = {
    address_prefixes  = ["10.0.2.0/23"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
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

# AKS Configuration
kubernetes_version = "1.28.5"

aks_node_pools = {
  system = {
    vm_size             = "Standard_D4s_v3"
    node_count          = 3
    min_count          = 3
    max_count          = 6
    max_pods           = 30
    availability_zones  = ["1", "2", "3"]
    node_taints        = ["CriticalAddonsOnly=true:NoSchedule"]
    node_labels        = { "workload" = "system" }
  }
  user = {
    vm_size             = "Standard_D8s_v3"
    node_count          = 9
    min_count          = 6
    max_count          = 50
    max_pods           = 50
    availability_zones  = ["1", "2", "3"]
    node_taints        = []
    node_labels        = { "workload" = "user" }
  }
  memory_optimized = {
    vm_size             = "Standard_E8s_v3"
    node_count          = 3
    min_count          = 0
    max_count          = 10
    max_pods           = 30
    availability_zones  = ["1", "2", "3"]
    node_taints        = ["workload=memory-intensive:NoSchedule"]
    node_labels        = { "workload" = "memory-intensive" }
  }
}

# Database Configuration
sql_server_version = "12.0"

sql_databases = {
  users = {
    edition                    = "Premium"
    service_objective_name    = "P2"
    max_size_gb              = 500
    zone_redundant           = true
    backup_retention_days    = 35
    geo_backup_enabled       = true
    threat_detection_enabled = true
  }
  orders = {
    edition                    = "Premium"
    service_objective_name    = "P4"
    max_size_gb              = 1000
    zone_redundant           = true
    backup_retention_days    = 35
    geo_backup_enabled       = true
    threat_detection_enabled = true
  }
  payments = {
    edition                    = "Premium"
    service_objective_name    = "P6"
    max_size_gb              = 1000
    zone_redundant           = true
    backup_retention_days    = 35
    geo_backup_enabled       = true
    threat_detection_enabled = true
  }
  inventory = {
    edition                    = "Standard"
    service_objective_name    = "S3"
    max_size_gb              = 250
    zone_redundant           = false
    backup_retention_days    = 35
    geo_backup_enabled       = true
    threat_detection_enabled = true
  }
}

# Cosmos DB Configuration
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
        zone_redundant    = true
      },
      {
        location          = "West US 2"
        failover_priority = 1
        zone_redundant    = true
      },
      {
        location          = "West Europe"
        failover_priority = 2
        zone_redundant    = false
      }
    ]
    capabilities = ["EnableAggregationPipeline", "mongoEnableDocLevelTTL"]
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
        zone_redundant    = true
      },
      {
        location          = "West US 2"
        failover_priority = 1
        zone_redundant    = false
      }
    ]
    capabilities = []
  }
  analytics = {
    consistency_policy = {
      consistency_level       = "Eventual"
      max_interval_in_seconds = 86400
      max_staleness_prefix    = 1000000
    }
    geo_locations = [
      {
        location          = "East US 2"
        failover_priority = 0
        zone_redundant    = false
      }
    ]
    capabilities = ["EnableAnalyticalStorage"]
  }
}

# Redis Cache Configuration
redis_configurations = {
  session = {
    capacity                      = 3
    family                       = "P"
    sku_name                     = "Premium"
    enable_non_ssl_port          = false
    minimum_tls_version          = "1.2"
    public_network_access_enabled = false
    redis_version                = "6"
    zones                        = ["1", "2", "3"]
  }
  cache = {
    capacity                      = 5
    family                       = "P"
    sku_name                     = "Premium"
    enable_non_ssl_port          = false
    minimum_tls_version          = "1.2"
    public_network_access_enabled = false
    redis_version                = "6"
    zones                        = ["1", "2", "3"]
  }
}

# Front Door Configuration
front_door_sku = "Premium_AzureFrontDoor"

# Monitoring Configuration
log_analytics_retention_days = 365
enable_application_insights  = true

# Security Configuration
key_vault_sku              = "premium"
enable_rbac_authorization  = true

key_vault_network_acls = {
  default_action = "Deny"
  bypass         = "AzureServices"
  ip_rules       = [] # Add your IP addresses for initial access
}

# Feature Flags
enable_api_management     = false  # Set to true if you need API Management ($2,800/month additional cost)
enable_private_endpoints  = true
enable_ddos_protection   = true
enable_waf               = true
enable_auto_scaling      = true
enable_spot_instances    = false   # Not recommended for production
enable_disaster_recovery = true

# Cost Optimization
schedule_shutdown = {
  enabled   = false  # Never enable for production
  time_zone = "Eastern Standard Time"
  shutdown  = "22:00"
  startup   = "06:00"
}

# Backup Configuration
backup_configurations = {
  vault_redundancy_type = "GeoRedundant"
  backup_policies = {
    daily_retention_days     = 30
    weekly_retention_weeks   = 52
    monthly_retention_months = 12
    yearly_retention_years   = 10
  }
}

# Common Tags
tags = {
  BusinessOwner    = "E-Commerce Team"
  TechnicalOwner   = "Platform Team"
  CostCenter      = "E-Commerce Production"
  ProjectCode     = "ECOM-2024"
  MaintenanceWindow = "Sunday 02:00-05:00 EST"
  BackupRequired  = "true"
  MonitoringLevel = "Critical"
  ComplianceLevel = "PCI-DSS"
  SLA             = "99.95%"
}
