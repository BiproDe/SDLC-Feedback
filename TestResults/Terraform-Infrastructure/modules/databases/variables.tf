# Database Module Variables

# Basic Configuration
variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "location" {
  description = "The primary Azure region where resources will be created"
  type        = string
}

variable "secondary_location" {
  description = "The secondary Azure region for disaster recovery"
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

# SQL Server Configuration
variable "sql_server_name" {
  description = "The name of the SQL Server"
  type        = string
}

variable "sql_admin_username" {
  description = "The administrator username for SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "The administrator password for SQL Server"
  type        = string
  sensitive   = true
}

variable "sql_databases" {
  description = "Configuration for SQL databases"
  type = map(object({
    name                        = string
    sku_name                   = string
    max_size_gb                = number
    zone_redundant             = bool
    backup_storage_redundancy  = string
    geo_backup_enabled         = bool
    point_in_time_restore_days = number
  }))
  default = {}
}

# Cosmos DB Configuration
variable "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account"
  type        = string
}

variable "cosmosdb_configurations" {
  description = "Configuration for Cosmos DB databases and containers"
  type = map(object({
    database_name = string
    containers = map(object({
      name               = string
      partition_key_path = string
      throughput        = number
    }))
  }))
  default = {}
}

# Redis Configuration
variable "redis_configurations" {
  description = "Configuration for Redis Cache instances"
  type = map(object({
    name     = string
    sku_name = string
    family   = string
    capacity = number
    enable_non_ssl_port = bool
    minimum_tls_version = string
  }))
  default = {}
}

# Network Configuration
variable "subnet_id" {
  description = "The subnet ID for database resources"
  type        = string
}

variable "enable_private_endpoints" {
  description = "Whether to enable private endpoints"
  type        = bool
  default     = true
}

variable "private_endpoint_subnet_id" {
  description = "The subnet ID for private endpoints"
  type        = string
}

# Security
variable "key_vault_id" {
  description = "The Key Vault ID for storing secrets"
  type        = string
}

# Backup and Disaster Recovery
variable "enable_disaster_recovery" {
  description = "Whether to enable disaster recovery configurations"
  type        = bool
  default     = true
}

variable "backup_configurations" {
  description = "Backup configuration settings"
  type = object({
    sql_backup_retention_days     = number
    sql_long_term_retention_weeks = number
    cosmosdb_backup_interval_hours = number
    cosmosdb_backup_retention_hours = number
  })
  default = {
    sql_backup_retention_days     = 35
    sql_long_term_retention_weeks = 104
    cosmosdb_backup_interval_hours = 24
    cosmosdb_backup_retention_hours = 720
  }
}
