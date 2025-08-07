# Core Infrastructure Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group" 
  value       = azurerm_resource_group.main.id
}

output "location" {
  description = "Primary location"
  value       = azurerm_resource_group.main.location
}

# Networking Outputs
output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = module.networking.virtual_network_id
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = module.networking.virtual_network_name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = module.networking.subnet_ids
}

output "application_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = module.networking.application_gateway_public_ip
  sensitive   = false
}

# AKS Outputs
output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

output "aks_node_resource_group" {
  description = "Auto-generated resource group for AKS nodes"
  value       = module.aks.node_resource_group
}

output "aks_identity_principal_id" {
  description = "Principal ID of the AKS managed identity"
  value       = module.aks.identity_principal_id
}

output "container_registry_id" {
  description = "ID of the container registry"
  value       = module.aks.container_registry_id
}

output "container_registry_login_server" {
  description = "Login server of the container registry"
  value       = module.aks.container_registry_login_server
}

# Database Outputs
output "sql_server_id" {
  description = "ID of the SQL server"
  value       = module.databases.sql_server_id
}

output "sql_server_fqdn" {
  description = "FQDN of the SQL server"
  value       = module.databases.sql_server_fqdn
  sensitive   = true
}

output "sql_databases" {
  description = "Map of SQL database names to their IDs"
  value       = module.databases.sql_databases
}

output "cosmosdb_account_id" {
  description = "ID of the Cosmos DB account"
  value       = module.databases.cosmosdb_account_id
}

output "cosmosdb_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = module.databases.cosmosdb_endpoint
  sensitive   = true
}

output "cosmosdb_primary_key" {
  description = "Primary key of the Cosmos DB account"
  value       = module.databases.cosmosdb_primary_key
  sensitive   = true
}

output "redis_cache_hostname" {
  description = "Hostname of the Redis cache"
  value       = module.databases.redis_cache_hostname
  sensitive   = true
}

output "redis_cache_primary_access_key" {
  description = "Primary access key of the Redis cache"
  value       = module.databases.redis_cache_primary_access_key
  sensitive   = true
}

# Security Outputs
output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.security.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.security.key_vault_uri
  sensitive   = true
}

output "user_assigned_identity_id" {
  description = "ID of the user-assigned managed identity"
  value       = module.security.user_assigned_identity_id
}

output "user_assigned_identity_principal_id" {
  description = "Principal ID of the user-assigned managed identity"
  value       = module.security.user_assigned_identity_principal_id
}

output "user_assigned_identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = module.security.user_assigned_identity_client_id
}

# Monitoring Outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = module.monitoring.log_analytics_workspace_id
}

output "log_analytics_workspace_key" {
  description = "Primary shared key of the Log Analytics workspace"
  value       = module.monitoring.log_analytics_workspace_key
  sensitive   = true
}

output "application_insights_id" {
  description = "ID of the Application Insights instance"
  value       = module.monitoring.application_insights_id
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key of the Application Insights instance"
  value       = module.monitoring.application_insights_instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string of the Application Insights instance"
  value       = module.monitoring.application_insights_connection_string
  sensitive   = true
}

# Front Door Outputs
output "front_door_id" {
  description = "ID of the Front Door"
  value       = module.front_door.front_door_id
}

output "front_door_endpoint_hostname" {
  description = "Hostname of the Front Door endpoint"
  value       = module.front_door.front_door_endpoint_hostname
}

# API Management Outputs (conditional)
output "api_management_id" {
  description = "ID of the API Management service"
  value       = var.enable_api_management ? module.api_management[0].api_management_id : null
}

output "api_management_gateway_url" {
  description = "Gateway URL of the API Management service"
  value       = var.enable_api_management ? module.api_management[0].api_management_gateway_url : null
}

# Connection Strings (for application configuration)
output "connection_strings" {
  description = "Connection strings for applications"
  value = {
    sql_users = module.databases.sql_connection_strings["users"]
    sql_orders = module.databases.sql_connection_strings["orders"]
    sql_payments = module.databases.sql_connection_strings["payments"]
    cosmosdb_products = module.databases.cosmosdb_connection_string
    redis_session = module.databases.redis_connection_string_session
    redis_cache = module.databases.redis_connection_string_cache
    application_insights = module.monitoring.application_insights_connection_string
  }
  sensitive = true
}

# Kubernetes Configuration
output "kube_config" {
  description = "Kubernetes configuration for connecting to AKS cluster"
  value       = module.aks.kube_config_raw
  sensitive   = true
}

# Resource Naming Information
output "resource_naming" {
  description = "Information about resource naming convention used"
  value = {
    project_name = var.project_name
    environment = var.environment
    location = var.location
    naming_pattern = "${var.project_name}-{resource-type}-${var.environment}-{region}"
    tags = local.common_tags
  }
}

# Cost Information
output "estimated_monthly_cost" {
  description = "Estimated monthly cost for the environment"
  value = {
    environment = var.environment
    estimated_cost_usd = var.environment == "prod" ? "17000" : var.environment == "staging" ? "3500" : "1500"
    cost_breakdown = {
      compute = var.environment == "prod" ? "8500" : var.environment == "staging" ? "1800" : "600"
      databases = var.environment == "prod" ? "4200" : var.environment == "staging" ? "800" : "300"
      networking = var.environment == "prod" ? "2100" : var.environment == "staging" ? "500" : "200"
      storage = var.environment == "prod" ? "800" : var.environment == "staging" ? "200" : "100"
      monitoring = var.environment == "prod" ? "1400" : var.environment == "staging" ? "200" : "300"
    }
  }
}

# Security Information
output "security_configuration" {
  description = "Security configuration summary"
  value = {
    private_endpoints_enabled = var.enable_private_endpoints
    rbac_enabled = var.enable_rbac_authorization
    key_vault_sku = var.key_vault_sku
    ddos_protection_enabled = var.enable_ddos_protection
    waf_enabled = var.enable_waf
    network_security_groups = keys(local.nsg_rules)
  }
}

# Disaster Recovery Information
output "disaster_recovery_configuration" {
  description = "Disaster recovery configuration"
  value = {
    primary_region = var.location
    secondary_region = var.secondary_location
    backup_enabled = local.env_config.enable_backup
    geo_replication_enabled = local.conditional_configs.enable_geo_replication
    backup_retention_days = local.db_config.backup_retention
    rto_target = var.environment == "prod" ? "1 hour" : "4 hours"
    rpo_target = var.environment == "prod" ? "4 hours" : "24 hours"
  }
}

# Feature Flags Status
output "feature_flags" {
  description = "Status of feature flags"
  value = {
    api_management_enabled = var.enable_api_management
    private_endpoints_enabled = var.enable_private_endpoints
    ddos_protection_enabled = var.enable_ddos_protection
    waf_enabled = var.enable_waf
    auto_scaling_enabled = var.enable_auto_scaling
    spot_instances_enabled = var.enable_spot_instances
    disaster_recovery_enabled = var.enable_disaster_recovery
    application_insights_enabled = var.enable_application_insights
  }
}

# Compliance Information
output "compliance_configuration" {
  description = "Compliance and governance configuration"
  value = {
    data_classification = local.common_tags.DataClassification
    pci_dss_ready = var.environment == "prod" ? "Yes" : "Partial"
    encryption_at_rest = "Enabled"
    encryption_in_transit = "Enabled"
    audit_logging = "Enabled"
    vulnerability_assessment = var.environment == "prod" ? "Enabled" : "Basic"
  }
}
