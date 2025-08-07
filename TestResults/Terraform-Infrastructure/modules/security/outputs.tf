# Security Module Outputs

output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "workload_identity_id" {
  description = "The ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.workload_identity.id
}

output "workload_identity_client_id" {
  description = "The client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.workload_identity.client_id
}

output "workload_identity_principal_id" {
  description = "The principal ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.workload_identity.principal_id
}

output "ssl_certificate_id" {
  description = "The ID of the SSL certificate"
  value       = var.environment == "prod" ? azurerm_key_vault_certificate.ssl_certificate[0].id : null
}

output "ssl_certificate_thumbprint" {
  description = "The thumbprint of the SSL certificate"
  value       = var.environment == "prod" ? azurerm_key_vault_certificate.ssl_certificate[0].thumbprint : null
}
