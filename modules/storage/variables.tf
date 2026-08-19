############################################################
# Resource Group
############################################################

variable "resource_group_name" {
  description = "Name of the resource group where the Storage Account is created."
  type        = string
}

variable "location" {
  description = "Azure region where the Storage Account is created."
  type        = string
}

############################################################
# Storage Account
############################################################

variable "storage_account_name" {
  description = "Globally unique name of the Storage Account."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The Storage Account name must contain 3-24 lowercase letters and numbers."
  }
}

variable "account_tier" {
  description = "Performance tier of the Storage Account."
  type        = string

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The account tier must be Standard or Premium."
  }
}

variable "account_replication_type" {
  description = "Replication type of the Storage Account."
  type        = string

  validation {
    condition = contains(
      ["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"],
      var.account_replication_type
    )

    error_message = "The replication type must be LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS."
  }
}

############################################################
# Storage Containers
############################################################

variable "container_names" {
  description = "Names of the private Blob Storage containers."
  type        = set(string)
}

############################################################
# Tags
############################################################

variable "tags" {
  description = "Common tags applied to the Storage Account."
  type        = map(string)
}
