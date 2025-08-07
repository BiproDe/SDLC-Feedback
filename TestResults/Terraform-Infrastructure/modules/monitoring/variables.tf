# Monitoring Module Variables

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

# Log Analytics Configuration
variable "log_analytics_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
}

variable "retention_days" {
  description = "The number of days to retain logs"
  type        = number
  default     = 30
  
  validation {
    condition     = var.retention_days >= 30 && var.retention_days <= 730
    error_message = "Retention days must be between 30 and 730."
  }
}

variable "sku" {
  description = "The SKU of the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
  
  validation {
    condition = contains([
      "Free", "PerNode", "Premium", "Standard", "Standalone", "Unlimited", 
      "CapacityReservation", "PerGB2018"
    ], var.sku)
    error_message = "Invalid SKU. Must be one of the supported Log Analytics SKUs."
  }
}

# Application Insights Configuration
variable "enable_application_insights" {
  description = "Whether to enable Application Insights"
  type        = bool
  default     = true
}

variable "application_insights_name" {
  description = "The name of the Application Insights instance"
  type        = string
}

variable "application_type" {
  description = "The type of Application Insights"
  type        = string
  default     = "web"
  
  validation {
    condition = contains([
      "web", "ios", "other", "store", "java", "phone"
    ], var.application_type)
    error_message = "Invalid application type."
  }
}
