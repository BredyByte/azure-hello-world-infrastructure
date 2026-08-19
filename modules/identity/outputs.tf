output "sql_administrator_group_object_id" {
  description = "Object ID of the Microsoft Entra group that will administer Azure SQL."
  value       = azuread_group.sql_administrators.object_id
}

output "sql_administrator_group_display_name" {
  description = "Display name of the Microsoft Entra SQL administrators group."
  value       = azuread_group.sql_administrators.display_name
}
