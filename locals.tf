locals {
  location            = "France Central"
  resource_group_name = "rg-dev-helloworld-f800"

  ############################################################
  # Application virtual network
  ############################################################

  virtual_network_name          = "vnet-dev-helloworld"
  virtual_network_address_space = ["10.20.0.0/16"]

  app_gateway_subnet_name     = "snet-app-gateway"
  app_gateway_subnet_prefixes = ["10.20.0.0/24"]

  app_service_subnet_name     = "snet-app-service-integration"
  app_service_subnet_prefixes = ["10.20.1.0/26"]

  private_endpoints_subnet_name     = "snet-private-endpoints"
  private_endpoints_subnet_prefixes = ["10.20.2.0/27"]

  ############################################################
  # Deployment virtual network
  ############################################################

  deployment_vnet_name          = "vnet-dev-helloworld-deployment"
  deployment_vnet_address_space = ["10.30.0.0/16"]

  deployment_bastion_subnet_name     = "AzureBastionSubnet"
  deployment_bastion_subnet_prefixes = ["10.30.0.0/26"]

  deployment_agent_subnet_name     = "snet-deployment-agent"
  deployment_agent_subnet_prefixes = ["10.30.1.0/24"]

  ############################################################
  # DDoS and tags
  ############################################################

  ddos_network_protection_plan = "ddos-network-dev-helloworld"

  tags = {
    Environment = "Development"
    Project     = "Hello World"
    Owner       = "Davyd Bredykhin"
    ManagedBy   = "Terraform"
  }
}
