############################################################
# Resource Group
############################################################

variable "resource_group_name" {
  description = "Name of the resource group where the Private DNS Zones are created."
  type        = string
}

############################################################
# Virtual Networks
############################################################

variable "application_vnet_id" {
  description = "Resource ID of the application virtual network."
  type        = string
}

variable "deployment_vnet_id" {
  description = "Resource ID of the deployment virtual network."
  type        = string
}

############################################################
# Tags
############################################################

variable "tags" {
  description = "Common tags applied to the Private DNS resources."
  type        = map(string)
}
