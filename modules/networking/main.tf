############################################################
# Azure DDoS Network Protection
############################################################

resource "azurerm_network_ddos_protection_plan" "project" {
  # Creates one plan when enabled and no plan when disabled.
  count = var.enable_ddos_network_protection ? 1 : 0

  name                = var.ddos_network_protection_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Preserves the existing Terraform resource address after
# adding count to the DDoS protection plan.
moved {
  from = azurerm_network_ddos_protection_plan.project
  to   = azurerm_network_ddos_protection_plan.project[0]
}

############################################################
# Application virtual network
############################################################


resource "azurerm_virtual_network" "application" {
  name                = var.application_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.application_vnet_address_space

  # Adds the DDoS plan block only when the paid protection
  # has been explicitly enabled.
  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_network_protection ? [1] : []

    content {
      enable = true
      id = (
        azurerm_network_ddos_protection_plan.project[0].id
      )
    }
  }

  tags = var.tags
}

resource "azurerm_subnet" "app_gateway" {
  name                 = var.app_gateway_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.application.name
  address_prefixes     = var.app_gateway_subnet_prefixes
}

resource "azurerm_subnet" "app_service_integration" {
  name                 = var.app_service_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.application.name
  address_prefixes     = var.app_service_subnet_prefixes

  delegation {
    name = "app-service-delegation"

    service_delegation {
      name = "Microsoft.Web/serverFarms"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = var.private_endpoints_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.application.name
  address_prefixes     = var.private_endpoints_subnet_prefixes

  # Allows the NSG to filter traffic sent to private-endpoint NICs.
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

############################################################
# Deployment virtual network
############################################################

resource "azurerm_virtual_network" "deployment" {
  name                = var.deployment_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.deployment_vnet_address_space

  # Adds the DDoS plan block only when the paid protection
  # has been explicitly enabled.
  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_network_protection ? [1] : []

    content {
      enable = true
      id = (
        azurerm_network_ddos_protection_plan.project[0].id
      )
    }
  }

  tags = var.tags
}

resource "azurerm_subnet" "deployment_agent" {
  name                 = var.deployment_agent_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.deployment.name
  address_prefixes     = var.deployment_agent_subnet_prefixes
}

resource "azurerm_subnet" "deployment_bastion" {
  name                 = var.deployment_bastion_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.deployment.name
  address_prefixes     = var.deployment_bastion_subnet_prefixes
}

############################################################
# Network Security Groups
############################################################

resource "azurerm_network_security_group" "app_gateway" {
  name                = "nsg-app-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "app_service" {
  name                = "nsg-app-service"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "private_endpoints" {
  name                = "nsg-private-endpoints"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "deployment_agent" {
  name                = "nsg-deployment-agent"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

############################################################
# Private endpoint NSG rules
############################################################

resource "azurerm_network_security_rule" "allow_app_service_to_sql" {
  name                        = "allow-app-service-to-sql"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = var.app_service_subnet_prefixes[0]
  destination_address_prefix  = var.private_endpoints_subnet_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_endpoints.name
  description                 = "Allows App Service to reach Azure SQL privately."
}

resource "azurerm_network_security_rule" "allow_app_service_to_private_https" {
  name                        = "allow-app-service-to-private-https"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.app_service_subnet_prefixes[0]
  destination_address_prefix  = var.private_endpoints_subnet_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_endpoints.name
  description                 = "Allows App Service to reach HTTPS private endpoints."
}

resource "azurerm_network_security_rule" "allow_gateway_to_app_service" {
  name                        = "allow-gateway-to-app-service"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.app_gateway_subnet_prefixes[0]
  destination_address_prefix  = var.private_endpoints_subnet_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_endpoints.name
  description                 = "Allows Application Gateway to reach the App Service private endpoint."
}

resource "azurerm_network_security_rule" "allow_deployment_agent_to_sql" {
  name                        = "allow-deployment-agent-to-sql"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = var.deployment_agent_subnet_prefixes[0]
  destination_address_prefix  = var.private_endpoints_subnet_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_endpoints.name
  description                 = "Allows the deployment subnet to reach Azure SQL through private endpoints."
}

resource "azurerm_network_security_rule" "allow_deployment_agent_to_private_https" {
  name                        = "allow-deployment-agent-to-private-https"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.deployment_agent_subnet_prefixes[0]
  destination_address_prefix  = var.private_endpoints_subnet_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_endpoints.name
  description                 = "Allows the deployment subnet to reach HTTPS private endpoints."
}

resource "azurerm_network_security_rule" "deny_vnet_to_private_endpoints" {
  name                        = "deny-vnet-to-private-endpoints"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = var.private_endpoints_subnet_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_endpoints.name
  description                 = "Blocks other VNet traffic before Azure's broad AllowVNetInBound default rule."
}

############################################################
# Application Gateway NSG rules
############################################################

resource "azurerm_network_security_rule" "allow_http_from_internet" {
  name                        = "allow-http-from-internet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = var.app_gateway_subnet_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app_gateway.name
  description                 = "Allows HTTP traffic from the Internet to Application Gateway."
}

resource "azurerm_network_security_rule" "allow_gateway_manager" {
  name                        = "allow-gateway-manager"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app_gateway.name
  description                 = "Allows required Application Gateway v2 control-plane traffic."
}

############################################################
# Deployment-agent NSG rule
############################################################

resource "azurerm_network_security_rule" "allow_bastion_to_deployment_vm_ssh" {
  name                        = "allow-bastion-to-deployment-vm-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.deployment_bastion_subnet_prefixes[0]
  destination_address_prefix  = var.deployment_agent_subnet_prefixes[0]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.deployment_agent.name
  description                 = "Allows Azure Bastion to connect to the deployment VM through SSH."
}

############################################################
# NSG associations
############################################################

resource "azurerm_subnet_network_security_group_association" "app_gateway" {
  subnet_id                 = azurerm_subnet.app_gateway.id
  network_security_group_id = azurerm_network_security_group.app_gateway.id
}

resource "azurerm_subnet_network_security_group_association" "app_service" {
  subnet_id                 = azurerm_subnet.app_service_integration.id
  network_security_group_id = azurerm_network_security_group.app_service.id
}

resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.private_endpoints.id
}

resource "azurerm_subnet_network_security_group_association" "deployment_agent" {
  subnet_id                 = azurerm_subnet.deployment_agent.id
  network_security_group_id = azurerm_network_security_group.deployment_agent.id
}

############################################################
# Bidirectional VNet peering
############################################################

resource "azurerm_virtual_network_peering" "deployment_to_application" {
  name                      = "peer-deployment-to-application"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.deployment.name
  remote_virtual_network_id = azurerm_virtual_network.application.id

  depends_on = [
    azurerm_subnet.app_gateway,
    azurerm_subnet.app_service_integration,
    azurerm_subnet.private_endpoints,
    azurerm_subnet.deployment_agent,
    azurerm_subnet.deployment_bastion,
  ]

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "application_to_deployment" {
  name                      = "peer-application-to-deployment"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.application.name
  remote_virtual_network_id = azurerm_virtual_network.deployment.id

  depends_on = [
    azurerm_subnet.app_gateway,
    azurerm_subnet.app_service_integration,
    azurerm_subnet.private_endpoints,
    azurerm_subnet.deployment_agent,
    azurerm_subnet.deployment_bastion,
  ]

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
