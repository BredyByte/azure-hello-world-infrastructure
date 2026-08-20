############################################################
# Private connectivity names
############################################################

locals {
  sql_private_endpoint_name = (
    "pe-sql-${var.name_prefix}"
  )

  sql_private_service_connection_name = (
    "psc-sql-${var.name_prefix}"
  )

  key_vault_private_endpoint_name = (
    "pe-kv-${var.name_prefix}"
  )

  key_vault_private_service_connection_name = (
    "psc-kv-${var.name_prefix}"
  )

  storage_blob_private_endpoint_name = (
    "pe-storage-${var.name_prefix}"
  )

  storage_blob_private_service_connection_name = (
    "psc-storage-blob-${var.name_prefix}"
  )

  app_service_private_endpoint_name = (
    "pe-app-${var.name_prefix}"
  )

  app_service_private_service_connection_name = (
    "psc-app-${var.name_prefix}"
  )

  app_service_network_interface_name = (
    "pe-app-${var.name_prefix}-nic"
  )
}

############################################################
# Azure SQL Private Endpoint
############################################################

resource "azurerm_private_endpoint" "sql" {
  name                = local.sql_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name = local.sql_private_service_connection_name

    private_connection_resource_id = var.sql_server_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_ids.sql]
  }

  tags = var.tags
}

############################################################
# Azure Key Vault Private Endpoint
############################################################

resource "azurerm_private_endpoint" "key_vault" {
  name                = local.key_vault_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name = local.key_vault_private_service_connection_name

    private_connection_resource_id = var.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "key-vault-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_ids.key_vault]
  }

  tags = var.tags
}

############################################################
# Blob Storage Private Endpoint
############################################################

resource "azurerm_private_endpoint" "storage_blob" {
  name                = local.storage_blob_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name = local.storage_blob_private_service_connection_name

    private_connection_resource_id = var.storage_account_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_ids.storage_blob]
  }

  tags = var.tags
}

############################################################
# App Service Private Endpoint
############################################################

resource "azurerm_private_endpoint" "app_service" {
  name                = local.app_service_private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  custom_network_interface_name = (
    local.app_service_network_interface_name
  )

  private_service_connection {
    name                           = local.app_service_private_service_connection_name
    private_connection_resource_id = var.web_app_id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids.app_service]
  }

  tags = var.tags
}
