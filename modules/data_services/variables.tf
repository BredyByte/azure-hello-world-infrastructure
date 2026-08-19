############################################################
# Shared configuration
############################################################

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

############################################################
# Storage
############################################################

variable "storage_account_name" {
  type = string
}

variable "storage_account_tier" {
  type = string
}

variable "storage_replication_type" {
  type = string
}

variable "storage_container_names" {
  type = set(string)
}

############################################################
# Azure SQL
############################################################

variable "sql_server_name" {
  type = string
}

variable "sql_database_name" {
  type = string
}

variable "sql_database_sku_name" {
  type = string
}

variable "sql_administrator_group_display_name" {
  type = string
}

variable "sql_administrator_group_object_id" {
  type = string
}

############################################################
# Azure Key Vault
############################################################

variable "key_vault_name" {
  type = string
}
