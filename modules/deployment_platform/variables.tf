############################################################
# Shared configuration
############################################################

variable "name_prefix" {
  description = "Common project name prefix."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be created."
  type        = string
}

variable "tags" {
  description = "Tags assigned to deployment-platform resources."
  type        = map(string)
}

############################################################
# Networking
############################################################

variable "deployment_bastion_subnet_id" {
  description = "Resource ID of AzureBastionSubnet."
  type        = string
}

variable "deployment_agent_subnet_id" {
  description = "Resource ID of the deployment-agent subnet."
  type        = string
}

############################################################
# Deployment VM
############################################################

variable "deployment_agent_vm_size" {
  description = "Azure size used by the deployment VM."
  type        = string
}

variable "deployment_agent_admin_username" {
  description = "Administrator username of the deployment VM."
  type        = string
}

variable "deployment_agent_ssh_public_key_path" {
  description = "Local filesystem path to the SSH public key."
  type        = string
}
