############################################################
# Deployment platform names
############################################################

locals {
  bastion_public_ip_name = "pip-bastion-${var.name_prefix}"
  bastion_host_name      = "bastion-${var.name_prefix}"

  nat_gateway_public_ip_name = "pip-nat-deployment-${var.name_prefix}"
  nat_gateway_name           = "nat-deployment-${var.name_prefix}"

  deployment_agent_nic_name = "nic-deployment-agent-${var.name_prefix}"
  deployment_agent_vm_name  = "vm-deployment-agent-${var.name_prefix}"
}

############################################################
# Azure Bastion Public IP
############################################################

resource "azurerm_public_ip" "bastion" {
  name                = local.bastion_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = ["1", "2", "3"]

  # The protection comes from the DDoS plan assigned to the VNet.
  ddos_protection_mode = "VirtualNetworkInherited"

  tags = var.tags
}

############################################################
# Azure Bastion
############################################################

resource "azurerm_bastion_host" "this" {
  name                = local.bastion_host_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # Basic supports browser-based SSH through Azure Portal.
  sku = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.deployment_bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = var.tags
}

############################################################
# NAT Gateway Public IP
############################################################

resource "azurerm_public_ip" "nat_gateway" {
  name                = local.nat_gateway_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "StandardV2"

  tags = var.tags
}

############################################################
# NAT Gateway
############################################################

resource "azurerm_nat_gateway" "deployment" {
  name                = local.nat_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name                = "StandardV2"
  idle_timeout_in_minutes = 4

  tags = var.tags
}

############################################################
# NAT Gateway associations
############################################################

resource "azurerm_nat_gateway_public_ip_association" "deployment" {
  nat_gateway_id       = azurerm_nat_gateway.deployment.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "deployment_agent" {
  subnet_id      = var.deployment_agent_subnet_id
  nat_gateway_id = azurerm_nat_gateway.deployment.id
}

############################################################
# Deployment VM Network Interface
############################################################

resource "azurerm_network_interface" "deployment_agent" {
  name                = local.deployment_agent_nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  accelerated_networking_enabled = true

  ip_configuration {
    name                          = "ipconfig-deployment-agent"
    subnet_id                     = var.deployment_agent_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

############################################################
# Private Linux Deployment VM
############################################################

resource "azurerm_linux_virtual_machine" "deployment_agent" {
  name                = local.deployment_agent_vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.deployment_agent_vm_size

  network_interface_ids = [
    azurerm_network_interface.deployment_agent.id,
  ]

  admin_username                  = var.deployment_agent_admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username = var.deployment_agent_admin_username
    # Terraform reads only the public half of your local SSH key pair.
    # The private key always remains on your laptop.
    public_key = file(pathexpand(var.deployment_agent_ssh_public_key_path))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {}

  # Creates the identity that will receive RBAC permissions later.
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
