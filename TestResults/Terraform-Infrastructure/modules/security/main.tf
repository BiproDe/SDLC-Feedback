# Security Module
# This module creates and manages Key Vault and security-related resources

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# Get current client configuration
data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                         = var.key_vault_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  enabled_for_disk_encryption  = true
  enabled_for_deployment       = false
  enabled_for_template_deployment = true
  tenant_id                    = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days   = 90
  purge_protection_enabled     = true
  sku_name                     = var.key_vault_sku
  enable_rbac_authorization    = var.enable_rbac_authorization
  public_network_access_enabled = false

  # Network ACLs
  network_acls {
    default_action = var.network_acls.default_action
    bypass         = var.network_acls.bypass
    ip_rules       = var.network_acls.ip_rules
    virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
  }

  tags = var.tags
}

# Access policies (only if RBAC is disabled)
resource "azurerm_key_vault_access_policy" "policies" {
  count = var.enable_rbac_authorization ? 0 : length(var.key_vault_access_policies)
  
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.key_vault_access_policies[count.index].object_id

  secret_permissions      = var.key_vault_access_policies[count.index].secret_permissions
  key_permissions        = var.key_vault_access_policies[count.index].key_permissions
  certificate_permissions = var.key_vault_access_policies[count.index].certificate_permissions
}

# Default access policy for the current service principal/user (only if RBAC is disabled)
resource "azurerm_key_vault_access_policy" "current_user" {
  count = var.enable_rbac_authorization ? 0 : 1
  
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]

  key_permissions = [
    "Get", "List", "Create", "Delete", "Recover", "Backup", "Restore", "Purge",
    "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Update", "Import"
  ]

  certificate_permissions = [
    "Get", "List", "Create", "Delete", "DeleteIssuers", "GetIssuers", "Import",
    "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "SetIssuers", "Update"
  ]
}

# RBAC role assignments (only if RBAC is enabled)
resource "azurerm_role_assignment" "key_vault_administrator" {
  count = var.enable_rbac_authorization ? 1 : 0
  
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Private endpoint for Key Vault
resource "azurerm_private_endpoint" "key_vault_endpoint" {
  count = var.enable_private_endpoints ? 1 : 0
  
  name                = "${var.key_vault_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.key_vault_name}-psc"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Key Vault secrets for SSL certificates and other sensitive data
resource "azurerm_key_vault_certificate" "ssl_certificate" {
  count = var.environment == "prod" ? 1 : 0
  
  name         = "ssl-certificate"
  key_vault_id = azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Friendly name for the certificate
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=ecommerce.local"
      validity_in_months = 12

      subject_alternative_names {
        dns_names = ["ecommerce.local", "*.ecommerce.local"]
      }
    }
  }

  tags = var.tags
}

# Diagnostic settings for Key Vault
resource "azurerm_monitor_diagnostic_setting" "key_vault_diagnostics" {
  count = var.log_analytics_workspace_id != null ? 1 : 0
  
  name                       = "${var.key_vault_name}-diagnostics"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# User-assigned managed identity for workloads
resource "azurerm_user_assigned_identity" "workload_identity" {
  name                = "${var.environment}-workload-identity"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

# Role assignment for managed identity to access Key Vault
resource "azurerm_role_assignment" "workload_identity_key_vault_user" {
  count = var.enable_rbac_authorization ? 1 : 0
  
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}
