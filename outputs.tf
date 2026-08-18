output "resource_group" {
  description = "Resource group that contains the complete project."
  value       = azurerm_resource_group.rg.name
}
