# Security Module Variables

# Basic Configuration
variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
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

# Key Vault Configuration
variable "key_vault_name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "key_vault_sku" {
  description = "The SKU of the Key Vault"
  type        = string
  default     = "premium"
  
  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be either 'standard' or 'premium'."
  }
}

# Network Configuration
variable "subnet_id" {
  description = "The subnet ID for private endpoints"
  type        = string
}

variable "enable_private_endpoints" {
  description = "Whether to enable private endpoints"
  type        = bool
  default     = true
}

# RBAC Configuration
variable "enable_rbac_authorization" {
  description = "Whether to enable RBAC authorization for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_access_policies" {
  description = "Access policies for Key Vault"
  type = list(object({
    object_id          = string
    secret_permissions = list(string)
    key_permissions    = list(string)
    certificate_permissions = list(string)
  }))
  default = []
}

# Network ACLs
variable "network_acls" {
  description = "Network ACLs for Key Vault"
  type = object({
    default_action = string
    bypass         = string
    ip_rules       = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = []
    virtual_network_subnet_ids = []
  }
}

# Monitoring
variable "log_analytics_workspace_id" {
  description = "The Log Analytics workspace ID for diagnostics"
  type        = string
  default     = null
}
