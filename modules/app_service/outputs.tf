output "app_service_plan_id" {
  value = azurerm_service_plan.this.id
}

output "app_service_plan_name" {
  value = azurerm_service_plan.this.name
}

output "web_app_id" {
  value = azurerm_linux_web_app.this.id
}

output "web_app_name" {
  value = azurerm_linux_web_app.this.name
}

output "web_app_default_hostname" {
  value = azurerm_linux_web_app.this.default_hostname
}

output "web_app_principal_id" {
  description = "Principal ID used later for Azure RBAC assignments."
  value       = azurerm_linux_web_app.this.identity[0].principal_id
}

