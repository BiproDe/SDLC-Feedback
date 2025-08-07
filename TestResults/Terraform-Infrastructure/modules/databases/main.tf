# Database Module
# This module creates and manages Azure SQL, Cosmos DB, and Redis Cache

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  
  # Security configuration
  minimum_tls_version               = "1.2"
  public_network_access_enabled     = false
  outbound_network_restriction_enabled = false
  
  # Azure AD authentication
  azuread_administrator {
    login_username = "sqladmin"
    object_id      = data.azurerm_client_config.current.object_id
  }

  # Identity for managed identity authentication
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# SQL Server Failover Group for Disaster Recovery
resource "azurerm_mssql_server" "sql_server_secondary" {
  count = var.enable_disaster_recovery ? 1 : 0
  
  name                         = "${var.sql_server_name}-secondary"
  resource_group_name          = var.resource_group_name
  location                     = var.secondary_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  
  minimum_tls_version               = "1.2"
  public_network_access_enabled     = false
  outbound_network_restriction_enabled = false
  
  azuread_administrator {
    login_username = "sqladmin"
    object_id      = data.azurerm_client_config.current.object_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# SQL Databases
resource "azurerm_mssql_database" "databases" {
  for_each = var.sql_databases
  
  name         = each.value.name
  server_id    = azurerm_mssql_server.sql_server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  
  # Performance and capacity
  sku_name                   = each.value.sku_name
  max_size_gb               = each.value.max_size_gb
  zone_redundant            = each.value.zone_redundant
  storage_account_type      = each.value.backup_storage_redundancy
  geo_backup_enabled        = each.value.geo_backup_enabled
  
  # Backup configuration
  short_term_retention_policy {
    retention_days = each.value.point_in_time_restore_days
  }

  long_term_retention_policy {
    weekly_retention  = "P12W"
    monthly_retention = "P12M"
    yearly_retention  = "P5Y"
    week_of_year     = 1
  }

  # Transparent Data Encryption
  transparent_data_encryption_enabled = true

  tags = var.tags
}

# SQL Server Firewall Rules (for Azure services only)
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql_private_endpoint" {
  count = var.enable_private_endpoints ? 1 : 0
  
  name                = "${var.sql_server_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.sql_server_name}-psc"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmosdb_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  # Consistency policy
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 86400
    max_staleness_prefix    = 1000000
  }

  # Multi-region configuration
  geo_location {
    location          = var.location
    failover_priority = 0
  }

  dynamic "geo_location" {
    for_each = var.enable_disaster_recovery ? [var.secondary_location] : []
    content {
      location          = geo_location.value
      failover_priority = 1
    }
  }

  # Capabilities
  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  # Network restrictions
  is_virtual_network_filter_enabled = true
  public_network_access_enabled     = false

  virtual_network_rule {
    id                                   = var.subnet_id
    ignore_missing_vnet_service_endpoint = false
  }

  # Backup configuration
  backup {
    type                = "Periodic"
    interval_in_minutes = var.backup_configurations.cosmosdb_backup_interval_hours * 60
    retention_in_hours  = var.backup_configurations.cosmosdb_backup_retention_hours
    storage_redundancy  = "Geo"
  }

  # Security
  local_authentication_disabled = false
  analytical_storage_enabled     = true

  tags = var.tags
}

# Cosmos DB SQL Databases and Containers
resource "azurerm_cosmosdb_sql_database" "databases" {
  for_each = var.cosmosdb_configurations
  
  name                = each.value.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
}

resource "azurerm_cosmosdb_sql_container" "containers" {
  for_each = merge([
    for db_key, db_config in var.cosmosdb_configurations : {
      for container_key, container_config in db_config.containers :
      "${db_key}-${container_key}" => merge(container_config, {
        database_name = db_config.database_name
        database_key  = db_key
      })
    }
  ]...)

  name                  = each.value.name
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmosdb.name
  database_name         = azurerm_cosmosdb_sql_database.databases[each.value.database_key].name
  partition_key_paths   = [each.value.partition_key_path]
  partition_key_version = 1
  throughput           = each.value.throughput

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/\"_etag\"/?"
    }
  }
}

# Private Endpoint for Cosmos DB
resource "azurerm_private_endpoint" "cosmosdb_private_endpoint" {
  count = var.enable_private_endpoints ? 1 : 0
  
  name                = "${var.cosmosdb_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.cosmosdb_account_name}-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Redis Cache instances
resource "azurerm_redis_cache" "redis" {
  for_each = var.redis_configurations
  
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = each.value.capacity
  family              = each.value.family
  sku_name            = each.value.sku_name
  non_ssl_port_enabled = each.value.enable_non_ssl_port
  minimum_tls_version = each.value.minimum_tls_version

  # Security
  public_network_access_enabled = false

  # Backup configuration (Premium tier only)
  dynamic "redis_configuration" {
    for_each = each.value.sku_name == "Premium" ? [1] : []
    content {
      rdb_backup_enabled            = true
      rdb_backup_frequency          = 60
      rdb_backup_max_snapshot_count = 1
      rdb_storage_connection_string = azurerm_storage_account.redis_backup[each.key].primary_blob_connection_string
    }
  }

  # Patch schedule for updates
  patch_schedule {
    day_of_week    = "Sunday"
    start_hour_utc = 2
  }

  tags = var.tags
}

# Storage account for Redis backup (Premium tier)
resource "azurerm_storage_account" "redis_backup" {
  for_each = { for k, v in var.redis_configurations : k => v if v.sku_name == "Premium" }
  
  name                     = "redis${each.key}backup"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version         = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

# Private Endpoints for Redis Cache
resource "azurerm_private_endpoint" "redis_private_endpoint" {
  for_each = var.enable_private_endpoints ? var.redis_configurations : {}
  
  name                = "${each.value.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${each.value.name}-psc"
    private_connection_resource_id = azurerm_redis_cache.redis[each.key].id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Store connection strings in Key Vault
resource "azurerm_key_vault_secret" "sql_connection_strings" {
  for_each = var.sql_databases
  
  name         = "sql-${each.value.name}-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${each.value.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = var.key_vault_id
  content_type = "connection-string"

  tags = var.tags
}

resource "azurerm_key_vault_secret" "cosmosdb_connection_string" {
  name         = "cosmosdb-connection-string"
  value        = azurerm_cosmosdb_account.cosmosdb.primary_sql_connection_string
  key_vault_id = var.key_vault_id
  content_type = "connection-string"

  tags = var.tags
}

resource "azurerm_key_vault_secret" "cosmosdb_primary_key" {
  name         = "cosmosdb-primary-key"
  value        = azurerm_cosmosdb_account.cosmosdb.primary_key
  key_vault_id = var.key_vault_id
  content_type = "key"

  tags = var.tags
}

resource "azurerm_key_vault_secret" "redis_connection_strings" {
  for_each = var.redis_configurations
  
  name         = "redis-${each.key}-connection-string"
  value        = azurerm_redis_cache.redis[each.key].primary_connection_string
  key_vault_id = var.key_vault_id
  content_type = "connection-string"

  tags = var.tags
}

# Current client configuration
data "azurerm_client_config" "current" {}
