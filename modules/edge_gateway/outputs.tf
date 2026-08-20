############################################################
# Application Gateway outputs
############################################################

output "application_gateway_id" {
  description = "Resource ID of the Application Gateway."
  value       = azurerm_application_gateway.this.id
}

output "application_gateway_name" {
  description = "Name of the Application Gateway."
  value       = azurerm_application_gateway.this.name
}

output "application_gateway_public_ip_address" {
  description = "Public IP address used to access the application."
  value       = azurerm_public_ip.application_gateway.ip_address
}

############################################################
# WAF outputs
############################################################

output "waf_policy_id" {
  description = "Resource ID of the Web Application Firewall policy."
  value       = azurerm_web_application_firewall_policy.this.id
}

output "waf_policy_name" {
  description = "Name of the Web Application Firewall policy."
  value       = azurerm_web_application_firewall_policy.this.name
}
