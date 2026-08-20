############################################################
# Shared configuration
############################################################

variable "resource_group_name" {
  description = "Name of the Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region where the Private Endpoints will be created."
  type        = string
}

variable "tags" {
  description = "Tags assigned to the Private Endpoints."
  type        = map(string)
}

############################################################
# Networking
############################################################

variable "private_endpoints_subnet_id" {
  description = "Resource ID of the subnet dedicated to Private Endpoints."
  type        = string
}

############################################################
# Naming
############################################################

variable "name_prefix" {
  description = "Common project name prefix used by private connectivity resources."
  type        = string
}

############################################################
# Private Link service resources
############################################################

variable "sql_server_id" {
  description = "Resource ID of the Azure SQL Server."
  type        = string
}

variable "key_vault_id" {
  description = "Resource ID of the Azure Key Vault."
  type        = string
}

variable "storage_account_id" {
  description = "Resource ID of the Azure Storage Account."
  type        = string
}

variable "web_app_id" {
  description = "Resource ID of the Azure Web App."
  type        = string
}

############################################################
# Private DNS Zones
############################################################

variable "private_dns_zone_ids" {
  description = "Private DNS Zone IDs associated with the Private Endpoints."

  type = object({
    sql          = string
    key_vault    = string
    storage_blob = string
    app_service  = string
  })
}
