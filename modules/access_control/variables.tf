############################################################
# Web App identity
############################################################

variable "web_app_principal_id" {
  description = "Principal ID of the Web App managed identity."
  type        = string
}

############################################################
# Deployment VM identity
############################################################

variable "deployment_agent_principal_id" {
  description = "Principal ID of the deployment VM managed identity."
  type        = string
}

############################################################
# Resource scopes
############################################################

variable "storage_account_id" {
  description = "Resource ID of the Storage Account."
  type        = string
}

variable "key_vault_id" {
  description = "Resource ID of the Azure Key Vault."
  type        = string
}

variable "web_app_id" {
  description = "Resource ID of the Azure Web App."
  type        = string
}

############################################################
# Microsoft Entra SQL administrators group
############################################################

variable "sql_administrator_group_object_id" {
  description = "Object ID of the Microsoft Entra SQL administrators group."
  type        = string
}
