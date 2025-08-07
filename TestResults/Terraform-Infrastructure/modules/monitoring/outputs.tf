# Monitoring Module Outputs

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_key" {
  description = "The primary shared key of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_workspace_id" {
  description = "The workspace ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}

output "application_insights_id" {
  description = "The ID of the Application Insights instance"
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].id : null
}

output "application_insights_name" {
  description = "The name of the Application Insights instance"
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].name : null
}

output "application_insights_app_id" {
  description = "The app ID of the Application Insights instance"
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].app_id : null
}

output "application_insights_instrumentation_key" {
  description = "The instrumentation key of the Application Insights instance"
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].instrumentation_key : null
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "The connection string of the Application Insights instance"
  value       = var.enable_application_insights ? azurerm_application_insights.main[0].connection_string : null
  sensitive   = true
}

output "action_group_id" {
  description = "The ID of the action group"
  value       = azurerm_monitor_action_group.main.id
}

output "data_collection_rule_id" {
  description = "The ID of the data collection rule"
  value       = azurerm_monitor_data_collection_rule.custom_metrics.id
}
