# Monitoring Module
# This module creates and manages Log Analytics workspace and Application Insights

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_days
  daily_quota_gb      = var.environment == "prod" ? -1 : 1

  tags = var.tags
}

# Application Insights
resource "azurerm_application_insights" "main" {
  count = var.enable_application_insights ? 1 : 0
  
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = var.application_type
  
  retention_in_days   = var.retention_days
  daily_data_cap_in_gb                  = var.environment == "prod" ? 100 : 5
  daily_data_cap_notifications_disabled = false

  tags = var.tags
}

# Log Analytics Solutions
resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "key_vault_analytics" {
  solution_name         = "KeyVaultAnalytics"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/KeyVaultAnalytics"
  }

  tags = var.tags
}

resource "azurerm_log_analytics_solution" "security_center_free" {
  count = var.environment != "prod" ? 1 : 0
  
  solution_name         = "SecurityCenterFree"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityCenterFree"
  }

  tags = var.tags
}

# Saved searches for common queries
resource "azurerm_log_analytics_saved_search" "failed_requests" {
  count = var.enable_application_insights ? 1 : 0
  
  name                       = "Failed Requests"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  category                   = "Application"
  display_name              = "Failed Requests"
  query                     = <<-QUERY
    requests
    | where success == false
    | where timestamp > ago(24h)
    | summarize count() by bin(timestamp, 1h), resultCode
    | render timechart
  QUERY

  tags = var.tags
}

resource "azurerm_log_analytics_saved_search" "high_cpu_usage" {
  name                       = "High CPU Usage"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  category                   = "Infrastructure"
  display_name              = "High CPU Usage"
  query                     = <<-QUERY
    Perf
    | where ObjectName == "Processor" and CounterName == "% Processor Time" and InstanceName == "_Total"
    | where CounterValue > 80
    | where TimeGenerated > ago(24h)
    | summarize avg(CounterValue) by Computer, bin(TimeGenerated, 15m)
    | render timechart
  QUERY

  tags = var.tags
}

resource "azurerm_log_analytics_saved_search" "container_restarts" {
  name                       = "Container Restarts"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  category                   = "Kubernetes"
  display_name              = "Container Restarts"
  query                     = <<-QUERY
    KubePodInventory
    | where PodRestartCount > 0
    | where TimeGenerated > ago(24h)
    | summarize RestartCount = sum(PodRestartCount) by Name, Namespace, bin(TimeGenerated, 1h)
    | render timechart
  QUERY

  tags = var.tags
}

# Data Collection Rules for custom metrics
resource "azurerm_monitor_data_collection_rule" "custom_metrics" {
  name                = "${var.environment}-custom-metrics-dcr"
  resource_group_name = var.resource_group_name
  location           = var.location
  description        = "Custom metrics data collection rule for ${var.environment}"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "log-analytics-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["log-analytics-destination"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Memory\\Available Bytes",
        "\\Network Interface(*)\\Bytes Total/sec"
      ]
      name = "perfCounterDataSource"
    }

    windows_event_log {
      streams = ["Microsoft-WindowsEvent"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0)]]",
        "Security!*[System[(band(Keywords,13510798882111488))]]",
        "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0)]]"
      ]
      name = "eventLogsDataSource"
    }
  }

  tags = var.tags
}

# Action Groups for alerting
resource "azurerm_monitor_action_group" "main" {
  name                = "${var.environment}-alerts"
  resource_group_name = var.resource_group_name
  short_name          = substr("${var.environment}alert", 0, 12)

  email_receiver {
    name          = "admin-email"
    email_address = "admin@ecommerce.com"
  }

  webhook_receiver {
    name        = "slack-webhook"
    service_uri = "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"
  }

  tags = var.tags
}

# Metric Alerts
resource "azurerm_monitor_metric_alert" "high_cpu_alert" {
  name                = "${var.environment}-high-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_log_analytics_workspace.main.id]
  description         = "Alert when CPU usage is consistently high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_% Processor Time"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "failed_requests_alert" {
  count = var.enable_application_insights ? 1 : 0
  
  name                = "${var.environment}-failed-requests-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main[0].id]
  description         = "Alert when there are many failed requests"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}
