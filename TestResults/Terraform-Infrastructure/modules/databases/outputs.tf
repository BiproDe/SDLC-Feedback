# Database Module Outputs

# SQL Server Outputs
output "sql_server_id" {
  description = "The ID of the SQL Server"
  value       = azurerm_mssql_server.sql_server.id
}

output "sql_server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.sql_server.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "sql_database_ids" {
  description = "The IDs of the SQL databases"
  value       = { for k, v in azurerm_mssql_database.databases : k => v.id }
}

output "sql_database_names" {
  description = "The names of the SQL databases"
  value       = { for k, v in azurerm_mssql_database.databases : k => v.name }
}

# Cosmos DB Outputs
output "cosmosdb_id" {
  description = "The ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmosdb.id
}

output "cosmosdb_name" {
  description = "The name of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmosdb.name
}

output "cosmosdb_endpoint" {
  description = "The endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "cosmosdb_connection_strings" {
  description = "The connection strings for Cosmos DB"
  value = {
    primary_sql       = azurerm_cosmosdb_account.cosmosdb.primary_sql_connection_string
    secondary_sql     = azurerm_cosmosdb_account.cosmosdb.secondary_sql_connection_string
    primary_readonly  = azurerm_cosmosdb_account.cosmosdb.primary_readonly_sql_connection_string
    secondary_readonly = azurerm_cosmosdb_account.cosmosdb.secondary_readonly_sql_connection_string
  }
  sensitive = true
}

output "cosmosdb_keys" {
  description = "The access keys for Cosmos DB"
  value = {
    primary_key              = azurerm_cosmosdb_account.cosmosdb.primary_key
    secondary_key           = azurerm_cosmosdb_account.cosmosdb.secondary_key
    primary_readonly_key    = azurerm_cosmosdb_account.cosmosdb.primary_readonly_key
    secondary_readonly_key  = azurerm_cosmosdb_account.cosmosdb.secondary_readonly_key
  }
  sensitive = true
}

output "cosmosdb_database_names" {
  description = "The names of the Cosmos DB databases"
  value       = { for k, v in azurerm_cosmosdb_sql_database.databases : k => v.name }
}

# Redis Cache Outputs
output "redis_ids" {
  description = "The IDs of the Redis Cache instances"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.id }
}

output "redis_names" {
  description = "The names of the Redis Cache instances"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.name }
}

output "redis_hostnames" {
  description = "The hostnames of the Redis Cache instances"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.hostname }
}

output "redis_ports" {
  description = "The ports of the Redis Cache instances"
  value = {
    ssl_port = { for k, v in azurerm_redis_cache.redis : k => v.ssl_port }
    port     = { for k, v in azurerm_redis_cache.redis : k => v.port }
  }
}

output "redis_primary_access_keys" {
  description = "The primary access keys for Redis Cache instances"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.primary_access_key }
  sensitive   = true
}

output "redis_connection_strings" {
  description = "The connection strings for Redis Cache instances"
  value       = { for k, v in azurerm_redis_cache.redis : k => v.primary_connection_string }
  sensitive   = true
}
