locals {
  ############################################################
  # Naming convention
  ############################################################

  project_identifier = "${var.project_name}${var.resource_suffix}"
  name_prefix        = "${var.environment}-${local.project_identifier}"

  ############################################################
  # Resource names
  ############################################################

  resource_group_name = "rg-${local.name_prefix}"

  application_vnet_name = "vnet-${local.name_prefix}-app"
  deployment_vnet_name  = "vnet-${local.name_prefix}-deployment"

  ddos_network_protection_plan_name = "ddos-network-${local.name_prefix}"

  ############################################################
  # Subnet names
  ############################################################

  app_gateway_subnet_name       = "snet-app-gateway"
  app_service_subnet_name       = "snet-app-service-integration"
  private_endpoints_subnet_name = "snet-private-endpoints"

  deployment_agent_subnet_name = "snet-deployment-agent"

  # Azure requires this exact subnet name for Azure Bastion.
  deployment_bastion_subnet_name = "AzureBastionSubnet"

  ############################################################
  # Common tags
  ############################################################

  environment_display_names = {
    dev  = "Development"
    test = "Test"
    prod = "Production"
  }

  common_tags = {
    Environment = local.environment_display_names[var.environment]
    Project     = var.project_display_name
    ProjectId   = local.project_identifier
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}
