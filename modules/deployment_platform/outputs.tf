############################################################
# Azure Bastion outputs
############################################################

output "bastion_host_id" {
  description = "Resource ID of Azure Bastion."
  value       = azurerm_bastion_host.this.id
}

output "bastion_public_ip_address" {
  description = "Public IP address used by Azure Bastion."
  value       = azurerm_public_ip.bastion.ip_address
}

############################################################
# NAT Gateway outputs
############################################################

output "nat_gateway_id" {
  description = "Resource ID of the deployment NAT Gateway."
  value       = azurerm_nat_gateway.deployment.id
}

output "nat_gateway_public_ip_address" {
  description = "Public outbound IP address of the NAT Gateway."
  value       = azurerm_public_ip.nat_gateway.ip_address
}

############################################################
# Deployment VM outputs
############################################################

output "deployment_agent_vm_id" {
  description = "Resource ID of the deployment VM."
  value       = azurerm_linux_virtual_machine.deployment_agent.id
}

output "deployment_agent_vm_name" {
  description = "Name of the deployment VM."
  value       = azurerm_linux_virtual_machine.deployment_agent.name
}

output "deployment_agent_private_ip" {
  description = "Private IP address assigned to the deployment VM."
  value       = azurerm_network_interface.deployment_agent.private_ip_address
}

output "deployment_agent_principal_id" {
  description = "Principal ID of the deployment VM managed identity."

  value = (
    azurerm_linux_virtual_machine.deployment_agent
    .identity[0]
    .principal_id
  )
}
