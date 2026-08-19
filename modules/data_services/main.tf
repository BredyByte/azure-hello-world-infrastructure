############################################################
# Azure Storage Account
############################################################

resource "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  # Storage is reachable only through its future private endpoint.
  public_network_access_enabled = false

  tags = var.tags
}

############################################################
# Private Blob Containers
############################################################

resource "azurerm_storage_container" "this" {
  for_each = var.storage_container_names

  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

############################################################
# Azure SQL Server
############################################################

resource "azurerm_mssql_server" "this" {
  name                = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  version = "12.0"

  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  # SQL authentication is disabled. Microsoft Entra authentication is required.
  azuread_administrator {
    login_username              = var.sql_administrator_group_display_name
    object_id                   = var.sql_administrator_group_object_id
    tenant_id                   = var.tenant_id
    azuread_authentication_only = true
  }

  # Azure SQL needs this identity to resolve Entra users and managed identities.
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

############################################################
# Microsoft Entra Directory Readers
############################################################

resource "azuread_directory_role" "directory_readers" {
  display_name = "Directory Readers"
}

resource "azuread_directory_role_assignment" "sql_server_directory_readers" {
  role_id             = azuread_directory_role.directory_readers.object_id
  principal_object_id = azurerm_mssql_server.this.identity[0].principal_id
}

############################################################
# Azure SQL Database
############################################################

resource "azurerm_mssql_database" "this" {
  name      = var.sql_database_name
  server_id = azurerm_mssql_server.this.id

  sku_name             = var.sql_database_sku_name
  zone_redundant       = false
  storage_account_type = "Local"

  tags = var.tags
}

############################################################
# Azure Key Vault
############################################################

resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tenant_id = var.tenant_id
  sku_name  = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Permissions are managed with Azure RBAC.
  rbac_authorization_enabled = true

  # Key Vault is reachable only through its future private endpoint.
  public_network_access_enabled = false

  tags = var.tags
}
