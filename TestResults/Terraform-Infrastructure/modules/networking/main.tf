# Networking Module for E-Commerce Platform
# This module creates the core networking infrastructure including VNet, subnets, NSGs, and Application Gateway

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "subnet_configurations" {
  description = "Subnet configurations"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  }))
}

variable "enable_ddos_protection" {
  description = "Enable DDoS Protection Standard"
  type        = bool
  default     = false
}

variable "enable_waf" {
  description = "Enable Web Application Firewall"
  type        = bool
  default     = true
}

variable "nsg_rules" {
  description = "Network Security Group rules"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Data sources
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# DDoS Protection Plan (optional)
resource "azurerm_network_ddos_protection_plan" "main" {
  count               = var.enable_ddos_protection ? 1 : 0
  name                = "${var.vnet_name}-ddos"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection ? [1] : []
    content {
      id     = azurerm_network_ddos_protection_plan.main[0].id
      enable = true
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_configurations

  name                 = "${var.vnet_name}-${each.key}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

# Network Security Groups
resource "azurerm_network_security_group" "nsgs" {
  for_each = var.subnet_configurations

  name                = "${var.vnet_name}-${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# NSG Rules
resource "azurerm_network_security_rule" "rules" {
  for_each = {
    for rule in flatten([
      for subnet_name, rules in var.nsg_rules : [
        for rule in rules : {
          key                        = "${subnet_name}-${rule.name}"
          nsg_name                  = azurerm_network_security_group.nsgs[subnet_name].name
          name                      = rule.name
          priority                  = rule.priority
          direction                 = rule.direction
          access                    = rule.access
          protocol                  = rule.protocol
          source_port_range         = try(rule.source_port_range, null)
          source_port_ranges        = try(rule.source_port_ranges, null)
          destination_port_range    = try(rule.destination_port_range, null)
          destination_port_ranges   = try(rule.destination_port_ranges, null)
          source_address_prefix     = try(rule.source_address_prefix, null)
          source_address_prefixes   = try(rule.source_address_prefixes, null)
          destination_address_prefix = try(rule.destination_address_prefix, null)
          destination_address_prefixes = try(rule.destination_address_prefixes, null)
        }
      ]
    ]) : rule.key => rule
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range          = each.value.source_port_range
  source_port_ranges         = each.value.source_port_ranges
  destination_port_range     = each.value.destination_port_range
  destination_port_ranges    = each.value.destination_port_ranges
  source_address_prefix      = each.value.source_address_prefix
  source_address_prefixes    = each.value.source_address_prefixes
  destination_address_prefix = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
  resource_group_name        = var.resource_group_name
  network_security_group_name = each.value.nsg_name
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "associations" {
  for_each = var.subnet_configurations

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}

# Public IP for Application Gateway
resource "azurerm_public_ip" "app_gateway" {
  name                = "${var.vnet_name}-agw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                = "Standard"
  zones              = ["1", "2", "3"]
  tags               = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

# Web Application Firewall Policy
resource "azurerm_web_application_firewall_policy" "main" {
  count               = var.enable_waf ? 1 : 0
  name                = "${var.vnet_name}-waf-policy"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  policy_settings {
    enabled                     = true
    mode                       = "Prevention"
    request_body_check         = true
    file_upload_limit_in_mb    = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
    
    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "0.1"
    }
  }

  # Custom rules for rate limiting
  custom_rules {
    name      = "RateLimitRule"
    priority  = 1
    rule_type = "RateLimitRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }
      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["0.0.0.0/0"]
    }

    action = "Block"
    
    rate_limit_duration    = "OneMin"
    rate_limit_threshold   = 100
  }

  # Block known bad IPs (example)
  custom_rules {
    name      = "BlockBadIPs"
    priority  = 2
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }
      operator           = "IPMatch"
      negation_condition = false
      match_values       = [] # Add known bad IPs here
    }

    action = "Block"
  }
}

# Application Gateway
resource "azurerm_application_gateway" "main" {
  name                = "${var.vnet_name}-agw"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  zones = ["1", "2", "3"]

  # Auto-scaling configuration
  autoscale_configuration {
    min_capacity = 2
    max_capacity = 125
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.subnets["application-gateway"].id
  }

  frontend_port {
    name = "frontend-port-80"
    port = 80
  }

  frontend_port {
    name = "frontend-port-443"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name = "aks-backend-pool"
  }

  backend_http_settings {
    name                  = "backend-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    
    probe_name = "health-probe"
  }

  backend_http_settings {
    name                  = "backend-https-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    
    probe_name = "health-probe-https"
  }

  # Health Probes
  probe {
    name                = "health-probe"
    host                = "localhost"
    protocol            = "Http"
    path                = "/health"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    
    match {
      status_code = ["200-399"]
    }
  }

  probe {
    name                = "health-probe-https"
    host                = "localhost"
    protocol            = "Https"
    path                = "/health"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    
    match {
      status_code = ["200-399"]
    }
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "frontend-port-80"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "frontend-port-443"
    protocol                       = "Https"
    ssl_certificate_name           = "ssl-cert"
  }

  # Default SSL Certificate (self-signed for now)
  ssl_certificate {
    name     = "ssl-cert"
    data     = base64encode(tls_self_signed_cert.app_gateway.cert_pem)
    password = ""
  }

  request_routing_rule {
    name                       = "http-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "aks-backend-pool"
    backend_http_settings_name = "backend-http-settings"
    priority                   = 100
  }

  request_routing_rule {
    name                       = "https-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "aks-backend-pool"
    backend_http_settings_name = "backend-https-settings"
    priority                   = 200
  }

  # WAF Configuration
  dynamic "waf_configuration" {
    for_each = var.enable_waf ? [1] : []
    content {
      enabled                  = true
      firewall_mode           = "Prevention"
      rule_set_type           = "OWASP"
      rule_set_version        = "3.2"
      file_upload_limit_mb    = 100
      request_body_check      = true
      max_request_body_size_kb = 128
    }
  }

  # Link WAF Policy if created
  dynamic "firewall_policy_id" {
    for_each = var.enable_waf ? [azurerm_web_application_firewall_policy.main[0].id] : []
    content {
      firewall_policy_id = firewall_policy_id.value
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      request_routing_rule,
      ssl_certificate,
      tags
    ]
  }
}

# Self-signed certificate for Application Gateway (replace with real certificate in production)
resource "tls_private_key" "app_gateway" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "app_gateway" {
  private_key_pem = tls_private_key.app_gateway.private_key_pem

  subject {
    common_name  = "*.${var.environment}.ecommerce.local"
    organization = "E-Commerce Platform"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Route Table for AKS subnet (for custom routing if needed)
resource "azurerm_route_table" "aks" {
  name                = "${var.vnet_name}-aks-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Custom routes can be added here if needed
  # route {
  #   name           = "internet"
  #   address_prefix = "0.0.0.0/0"
  #   next_hop_type  = "Internet"
  # }
}

resource "azurerm_subnet_route_table_association" "aks_nodes" {
  subnet_id      = azurerm_subnet.subnets["aks-nodes"].id
  route_table_id = azurerm_route_table.aks.id
}

# Outputs
output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "application_gateway_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.main.id
}

output "application_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.app_gateway.ip_address
}

output "network_security_group_ids" {
  description = "Map of NSG names to their IDs"
  value       = { for k, v in azurerm_network_security_group.nsgs : k => v.id }
}
