############################################################
# Shared configuration
############################################################

variable "name_prefix" {
  description = "Common resource name prefix."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where monitoring resources are created."
  type        = string
}

variable "location" {
  description = "Azure region where monitoring resources are created."
  type        = string
}

variable "tags" {
  description = "Tags assigned to monitoring resources."
  type        = map(string)
}

############################################################
# Log Analytics
############################################################

variable "log_analytics_retention_in_days" {
  description = "Number of days that logs are retained."
  type        = number
}

############################################################
# Application Gateway
############################################################

variable "application_gateway_id" {
  description = "Resource ID of the Application Gateway to monitor."
  type        = string
}
