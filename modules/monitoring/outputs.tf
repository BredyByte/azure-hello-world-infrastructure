############################################################
# Log Analytics Workspace outputs
############################################################

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

############################################################
# Diagnostic Setting outputs
############################################################

output "application_gateway_diagnostic_setting_id" {
  description = "Resource ID of the Application Gateway diagnostic setting."

  value = (
    azurerm_monitor_diagnostic_setting.application_gateway.id
  )
}

output "application_gateway_diagnostic_setting_name" {
  description = "Name of the Application Gateway diagnostic setting."

  value = (
    azurerm_monitor_diagnostic_setting.application_gateway.name
  )
}
