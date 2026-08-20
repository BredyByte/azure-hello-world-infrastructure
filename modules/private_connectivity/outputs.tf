############################################################
# Private Endpoint outputs
############################################################

output "private_endpoints" {
  description = "Names, IDs and private IP addresses of the Private Endpoints."

  value = {
    sql = {
      name = azurerm_private_endpoint.sql.name
      id   = azurerm_private_endpoint.sql.id

      private_ip_address = (
        azurerm_private_endpoint.sql
        .private_service_connection[0]
        .private_ip_address
      )
    }

    key_vault = {
      name = azurerm_private_endpoint.key_vault.name
      id   = azurerm_private_endpoint.key_vault.id

      private_ip_address = (
        azurerm_private_endpoint.key_vault
        .private_service_connection[0]
        .private_ip_address
      )
    }

    storage_blob = {
      name = azurerm_private_endpoint.storage_blob.name
      id   = azurerm_private_endpoint.storage_blob.id

      private_ip_address = (
        azurerm_private_endpoint.storage_blob
        .private_service_connection[0]
        .private_ip_address
      )
    }

    app_service = {
      name = azurerm_private_endpoint.app_service.name
      id   = azurerm_private_endpoint.app_service.id

      private_ip_address = (
        azurerm_private_endpoint.app_service
        .private_service_connection[0]
        .private_ip_address
      )
    }
  }
}
