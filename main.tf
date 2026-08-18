############################################################
# Shared foundation
############################################################

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location

  tags = local.tags
}

############################################################
# Networking foundation
############################################################

module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  ddos_network_protection_plan_name = local.ddos_network_protection_plan

  application_vnet_name          = local.virtual_network_name
  application_vnet_address_space = local.virtual_network_address_space

  app_gateway_subnet_name     = local.app_gateway_subnet_name
  app_gateway_subnet_prefixes = local.app_gateway_subnet_prefixes

  app_service_subnet_name     = local.app_service_subnet_name
  app_service_subnet_prefixes = local.app_service_subnet_prefixes

  private_endpoints_subnet_name     = local.private_endpoints_subnet_name
  private_endpoints_subnet_prefixes = local.private_endpoints_subnet_prefixes

  deployment_vnet_name          = local.deployment_vnet_name
  deployment_vnet_address_space = local.deployment_vnet_address_space

  deployment_bastion_subnet_name     = local.deployment_bastion_subnet_name
  deployment_bastion_subnet_prefixes = local.deployment_bastion_subnet_prefixes

  deployment_agent_subnet_name     = local.deployment_agent_subnet_name
  deployment_agent_subnet_prefixes = local.deployment_agent_subnet_prefixes
}
