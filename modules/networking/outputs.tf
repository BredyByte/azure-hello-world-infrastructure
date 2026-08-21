output "application_vnet_id" {
  value = azurerm_virtual_network.application.id
}

output "deployment_vnet_id" {
  value = azurerm_virtual_network.deployment.id
}

output "app_gateway_subnet_id" {
  value = azurerm_subnet.app_gateway.id
}

output "app_service_integration_subnet_id" {
  value = azurerm_subnet.app_service_integration.id
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "deployment_agent_subnet_id" {
  value = azurerm_subnet.deployment_agent.id
}

output "deployment_bastion_subnet_id" {
  value = azurerm_subnet.deployment_bastion.id
}

output "ddos_protection_plan_id" {
  description = "DDoS Network Protection plan ID, or null when protection is disabled."

  value = (
    var.enable_ddos_network_protection
    ? azurerm_network_ddos_protection_plan.project[0].id
    : null
  )
}
