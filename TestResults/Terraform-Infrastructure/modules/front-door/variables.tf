# Front Door Module Variables

# Basic Configuration
variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
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

# Front Door Configuration
variable "front_door_name" {
  description = "The name of the Front Door"
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the Front Door"
  type        = string
  default     = "Standard_AzureFrontDoor"
  
  validation {
    condition = contains([
      "Standard_AzureFrontDoor", "Premium_AzureFrontDoor"
    ], var.sku_name)
    error_message = "SKU name must be either Standard_AzureFrontDoor or Premium_AzureFrontDoor."
  }
}

# Origin Configuration
variable "origin_host_name" {
  description = "The host name of the origin (Application Gateway public IP or FQDN)"
  type        = string
}

variable "origin_http_port" {
  description = "The HTTP port of the origin"
  type        = number
  default     = 80
}

variable "origin_https_port" {
  description = "The HTTPS port of the origin"
  type        = number
  default     = 443
}

# Security Configuration
variable "enable_waf" {
  description = "Whether to enable Web Application Firewall"
  type        = bool
  default     = true
}

variable "waf_mode" {
  description = "The mode of the WAF policy"
  type        = string
  default     = "Prevention"
  
  validation {
    condition = contains([
      "Detection", "Prevention"
    ], var.waf_mode)
    error_message = "WAF mode must be either Detection or Prevention."
  }
}

# Custom Domain Configuration
variable "custom_domains" {
  description = "List of custom domains to add to Front Door"
  type = list(object({
    name = string
    host_name = string
  }))
  default = []
}

# Caching Configuration
variable "cache_query_string_caching_behavior" {
  description = "Query string caching behavior"
  type        = string
  default     = "IgnoreQueryString"
  
  validation {
    condition = contains([
      "IgnoreQueryString", "UseQueryString", "NotSet"
    ], var.cache_query_string_caching_behavior)
    error_message = "Invalid query string caching behavior."
  }
}
