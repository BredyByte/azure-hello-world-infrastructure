############################################################
# Shared foundation
############################################################

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location

  tags = local.common_tags
}

############################################################
# Networking foundation
############################################################

module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.common_tags

  ddos_network_protection_plan_name = local.ddos_network_protection_plan_name

  application_vnet_name          = local.application_vnet_name
  application_vnet_address_space = var.application_vnet_address_space

  app_gateway_subnet_name     = local.app_gateway_subnet_name
  app_gateway_subnet_prefixes = var.app_gateway_subnet_prefixes

  app_service_subnet_name     = local.app_service_subnet_name
  app_service_subnet_prefixes = var.app_service_subnet_prefixes

  private_endpoints_subnet_name     = local.private_endpoints_subnet_name
  private_endpoints_subnet_prefixes = var.private_endpoints_subnet_prefixes

  deployment_vnet_name          = local.deployment_vnet_name
  deployment_vnet_address_space = var.deployment_vnet_address_space

  deployment_bastion_subnet_name     = local.deployment_bastion_subnet_name
  deployment_bastion_subnet_prefixes = var.deployment_bastion_subnet_prefixes

  deployment_agent_subnet_name     = local.deployment_agent_subnet_name
  deployment_agent_subnet_prefixes = var.deployment_agent_subnet_prefixes
}

############################################################
# Private DNS
############################################################

module "private_dns" {
  source = "./modules/private_dns"

  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

  application_vnet_id = module.networking.application_vnet_id
  deployment_vnet_id  = module.networking.deployment_vnet_id
}
