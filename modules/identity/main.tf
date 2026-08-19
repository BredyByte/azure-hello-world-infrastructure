############################################################
# Microsoft Entra user
############################################################

# Looks up your existing Microsoft Entra user.
data "azuread_user" "sql_administrator" {
  user_principal_name = var.sql_administrator_user_principal_name
}

############################################################
# SQL administrators group
############################################################

# This group will become the Microsoft Entra administrator of Azure SQL.
resource "azuread_group" "sql_administrators" {
  display_name            = var.sql_administrator_group_display_name
  security_enabled        = true
  mail_enabled            = false
  prevent_duplicate_names = true
}

# Keeps your Entra user able to administer the Azure SQL Server.
resource "azuread_group_member" "sql_administrator" {
  group_object_id  = azuread_group.sql_administrators.object_id
  member_object_id = data.azuread_user.sql_administrator.object_id
}
