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
