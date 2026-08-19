############################################################
# Resource Group
############################################################

output "resource_group" {
  description = "Resource group that contains the complete project."

  value = {
    name     = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
  }
}

############################################################
# Application Virtual Network
############################################################

output "application_network" {
  description = "Application VNet and its subnet configuration."

  value = {
    name          = local.application_vnet_name
    address_space = var.application_vnet_address_space

    subnets = {
      app_gateway = {
        name             = local.app_gateway_subnet_name
        address_prefixes = var.app_gateway_subnet_prefixes
      }

      app_service_integration = {
        name             = local.app_service_subnet_name
        address_prefixes = var.app_service_subnet_prefixes
      }

      private_endpoints = {
        name             = local.private_endpoints_subnet_name
        address_prefixes = var.private_endpoints_subnet_prefixes
      }
    }
  }
}

############################################################
# Deployment Virtual Network
############################################################

output "deployment_network" {
  description = "Deployment VNet and its subnet configuration."

  value = {
    name          = local.deployment_vnet_name
    address_space = var.deployment_vnet_address_space

    subnets = {
      bastion = {
        name             = local.deployment_bastion_subnet_name
        address_prefixes = var.deployment_bastion_subnet_prefixes
      }

      deployment_agent = {
        name             = local.deployment_agent_subnet_name
        address_prefixes = var.deployment_agent_subnet_prefixes
      }
    }
  }
}

############################################################
# Private DNS Zones
############################################################

output "private_dns_zones" {
  description = "Private DNS Zones configured for the project."
  value       = module.private_dns.private_dns_zone_names
}

############################################################
# Storage
############################################################

output "storage" {
  description = "Storage Account and private container configuration."

  value = {
    name                  = module.data_services.storage_account_name
    primary_blob_endpoint = module.data_services.storage_primary_blob_endpoint
    containers            = module.data_services.storage_container_names
  }
}

############################################################
# Azure SQL and Key Vault
############################################################

output "data_services" {
  description = "Azure SQL and Key Vault service details."

  value = {
    sql_server_name = module.data_services.sql_server_name
    sql_database    = module.data_services.sql_database_name
    key_vault_name  = module.data_services.key_vault_name
    key_vault_uri   = module.data_services.key_vault_uri
  }
}

############################################################
# Microsoft Entra identity
############################################################

output "sql_administrators_group" {
  description = "Microsoft Entra group that will administer Azure SQL."

  value = {
    display_name = module.identity.sql_administrator_group_display_name
    object_id    = module.identity.sql_administrator_group_object_id
  }
}
