############################################################
# SQL administrator group
############################################################

variable "sql_administrator_group_display_name" {
  description = "Display name of the Microsoft Entra group that will administer Azure SQL."
  type        = string
}

variable "sql_administrator_user_principal_name" {
  description = "Microsoft Entra user principal name added to the SQL administrators group."
  type        = string
}
