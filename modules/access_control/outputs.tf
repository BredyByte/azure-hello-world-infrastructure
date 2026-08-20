############################################################
# Web App role assignment outputs
############################################################

output "web_app_role_assignment_ids" {
  description = "Role assignment IDs created for the Web App."

  value = {
    storage_blob_data_reader = (
      azurerm_role_assignment
      .web_app_storage_blob_data_reader
      .id
    )

    key_vault_secrets_user = (
      azurerm_role_assignment
      .web_app_key_vault_secrets_user
      .id
    )
  }
}

############################################################
# Deployment VM role assignment outputs
############################################################

output "deployment_agent_role_assignment_ids" {
  description = "Role assignment IDs created for the deployment VM."

  value = {
    storage_blob_data_contributor = (
      azurerm_role_assignment
      .deployment_agent_storage_blob_data_contributor
      .id
    )

    key_vault_secrets_officer = (
      azurerm_role_assignment
      .deployment_agent_key_vault_secrets_officer
      .id
    )

    website_contributor = (
      azurerm_role_assignment
      .deployment_agent_website_contributor
      .id
    )
  }
}

############################################################
# SQL group membership output
############################################################

output "deployment_agent_sql_group_membership_id" {
  description = "ID of the deployment VM SQL administrators group membership."

  value = (
    azuread_group_member
    .deployment_agent_sql_administrator
    .id
  )
}

