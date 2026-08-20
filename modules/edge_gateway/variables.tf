############################################################
# Shared configuration
############################################################

variable "name_prefix" {
  description = "Common resource name prefix."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the edge resources are created."
  type        = string
}

variable "location" {
  description = "Azure region where the edge resources are created."
  type        = string
}

variable "tags" {
  description = "Tags assigned to the edge resources."
  type        = map(string)
}

############################################################
# Networking
############################################################

variable "app_gateway_subnet_id" {
  description = "Resource ID of the dedicated Application Gateway subnet."
  type        = string
}

############################################################
# App Service backend
############################################################

variable "web_app_default_hostname" {
  description = "Default hostname of the App Service backend."
  type        = string
}
