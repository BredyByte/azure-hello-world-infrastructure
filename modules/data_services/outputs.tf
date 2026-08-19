############################################################
# Storage
############################################################

output "storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "storage_primary_blob_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}

output "storage_container_names" {
  value = sort(keys(azurerm_storage_container.this))
}

############################################################
# Azure SQL
############################################################

output "sql_server_id" {
  value = azurerm_mssql_server.this.id
}

output "sql_server_name" {
  value = azurerm_mssql_server.this.name
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "sql_server_principal_id" {
  value = azurerm_mssql_server.this.identity[0].principal_id
}

output "sql_database_id" {
  value = azurerm_mssql_database.this.id
}

output "sql_database_name" {
  value = azurerm_mssql_database.this.name
}

############################################################
# Azure Key Vault
############################################################

output "key_vault_id" {
  value = azurerm_key_vault.this.id
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}
