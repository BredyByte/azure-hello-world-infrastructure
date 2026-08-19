############################################################
# Development environment
############################################################

location             = "France Central"
environment          = "dev"
project_name         = "helloworld"
project_display_name = "Hello World"
resource_suffix      = "f800"
owner                = "Davyd Bredykhin"

############################################################
# Networking configuration
############################################################

application_vnet_address_space    = ["10.20.0.0/16"]
app_gateway_subnet_prefixes       = ["10.20.0.0/24"]
app_service_subnet_prefixes       = ["10.20.1.0/26"]
private_endpoints_subnet_prefixes = ["10.20.2.0/27"]

deployment_vnet_address_space      = ["10.30.0.0/16"]
deployment_bastion_subnet_prefixes = ["10.30.0.0/26"]
deployment_agent_subnet_prefixes   = ["10.30.1.0/24"]
