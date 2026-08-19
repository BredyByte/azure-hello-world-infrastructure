############################################################
# Storage Account
############################################################

output "storage_account_id" {
  description = "Resource ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Primary Blob Storage endpoint."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

############################################################
# Storage Containers
############################################################

output "container_names" {
  description = "Names of the private Blob Storage containers."
  value       = sort(keys(azurerm_storage_container.this))
}
