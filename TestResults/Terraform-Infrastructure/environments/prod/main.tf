# Production Environment Configuration
# This file contains production-specific settings for the e-commerce platform

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "tfstate-rg-prod"
    storage_account_name = "tfstateprod001"
    container_name       = "tfstate"
    key                  = "ecommerce/prod/terraform.tfstate"
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    
    cognitive_account {
      purge_soft_delete_on_destroy = false
    }
  }
}

# Configure the Random Provider
provider "random" {}

# Include shared configuration
locals {
  shared_config = "../../../shared"
}

# Load shared variables and locals
module "shared" {
  source = local.shared_config
}

# Main Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_names.resource_group
  location = var.location
  tags     = local.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  
  # Network configuration
  vnet_name          = local.resource_names.virtual_network
  address_space      = var.vnet_address_space
  subnet_configurations = var.subnet_configurations
  
  # Security configuration
  enable_ddos_protection = var.enable_ddos_protection
  enable_waf            = var.enable_waf
  nsg_rules             = local.nsg_rules
  
  tags = local.common_tags
}

# AKS Module
module "aks" {
  source = "../../modules/aks"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  
  # AKS configuration
  cluster_name        = local.resource_names.aks_cluster
  kubernetes_version  = var.kubernetes_version
  subnet_id          = module.networking.subnet_ids["aks-nodes"]
  pod_subnet_id      = module.networking.subnet_ids["aks-pods"]
  
  # Node pools
  node_pools = var.aks_node_pools
  
  # Container registry
  acr_name = local.resource_names.container_registry
  
  # Monitoring
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  
  # Security
  key_vault_id = module.security.key_vault_id
  
  tags = local.common_tags
  
  depends_on = [module.networking, module.security, module.monitoring]
}

# Database Module
module "databases" {
  source = "../../modules/databases"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  secondary_location = var.secondary_location
  environment        = var.environment
  
  # SQL Server configuration
  sql_server_name     = local.resource_names.sql_server
  sql_admin_username  = "sqladmin"
  sql_admin_password  = random_password.sql_admin_password.result
  sql_databases      = var.sql_databases
  
  # Cosmos DB configuration
  cosmosdb_account_name = local.resource_names.cosmosdb_account
  cosmosdb_configurations = var.cosmosdb_configurations
  
  # Redis configuration
  redis_configurations = var.redis_configurations
  
  # Networking
  subnet_id = module.networking.subnet_ids["database"]
  enable_private_endpoints = var.enable_private_endpoints
  private_endpoint_subnet_id = module.networking.subnet_ids["private-endpoints"]
  
  # Security
  key_vault_id = module.security.key_vault_id
  
  # Backup configuration
  enable_disaster_recovery = var.enable_disaster_recovery
  backup_configurations = var.backup_configurations
  
  tags = local.common_tags
  
  depends_on = [module.networking, module.security]
}

# Security Module
module "security" {
  source = "../../modules/security"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  
  # Key Vault configuration
  key_vault_name = local.resource_names.key_vault
  key_vault_sku  = var.key_vault_sku
  
  # Network configuration
  subnet_id = module.networking.subnet_ids["private-endpoints"]
  enable_private_endpoints = var.enable_private_endpoints
  
  # RBAC configuration
  enable_rbac_authorization = var.enable_rbac_authorization
  key_vault_access_policies = local.key_vault_access_policies
  
  # Network ACLs
  network_acls = var.key_vault_network_acls
  
  tags = local.common_tags
  
  depends_on = [module.networking]
}

# Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  
  # Log Analytics configuration
  log_analytics_name = local.resource_names.log_analytics
  retention_days     = var.log_analytics_retention_days
  
  # Application Insights configuration
  enable_application_insights = var.enable_application_insights
  application_insights_name   = local.resource_names.application_insights
  
  tags = local.common_tags
}

# Front Door Module
module "front_door" {
  source = "../../modules/front-door"

  resource_group_name = azurerm_resource_group.main.name
  environment        = var.environment
  
  # Front Door configuration
  front_door_name = local.resource_names.front_door
  sku_name       = var.front_door_sku
  
  # Origin configuration
  origin_host_name = module.networking.application_gateway_public_ip
  
  # Security configuration
  enable_waf = var.enable_waf
  
  tags = local.common_tags
  
  depends_on = [module.networking]
}

# API Management Module (conditional)
module "api_management" {
  count  = var.enable_api_management ? 1 : 0
  source = "../../modules/api-management"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  environment        = var.environment
  
  # API Management configuration
  api_management_name = local.resource_names.api_management
  publisher_name     = "E-Commerce Platform"
  publisher_email    = "admin@ecommerce.com"
  
  # SKU configuration
  sku_name     = "Premium"
  sku_capacity = 1
  
  # Network configuration
  subnet_id = module.networking.subnet_ids["aks-nodes"]
  
  # Security
  key_vault_id = module.security.key_vault_id
  
  tags = local.common_tags
  
  depends_on = [module.networking, module.security]
}
