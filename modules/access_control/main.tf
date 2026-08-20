############################################################
# Web App Storage permissions
############################################################

# Allows the Web App to read and list Blob Storage content.
resource "azurerm_role_assignment" "web_app_storage_blob_data_reader" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.web_app_principal_id
}

############################################################
# Web App Key Vault permissions
############################################################

# Allows the Web App to read Key Vault secret values.
resource "azurerm_role_assignment" "web_app_key_vault_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.web_app_principal_id
}

############################################################
# Deployment VM SQL permissions
############################################################

# Makes the deployment VM a member of the SQL administrators group.
resource "azuread_group_member" "deployment_agent_sql_administrator" {
  group_object_id  = var.sql_administrator_group_object_id
  member_object_id = var.deployment_agent_principal_id
}

############################################################
# Deployment VM Storage permissions
############################################################

# Allows the deployment VM to create, update and delete Blob content.
resource "azurerm_role_assignment" "deployment_agent_storage_blob_data_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.deployment_agent_principal_id
}

############################################################
# Deployment VM Key Vault permissions
############################################################

# Allows the deployment VM to create and update Key Vault secrets.
resource "azurerm_role_assignment" "deployment_agent_key_vault_secrets_officer" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.deployment_agent_principal_id
}

############################################################
# Deployment VM App Service permissions
############################################################

# Allows the deployment VM to deploy and configure the Web App.
resource "azurerm_role_assignment" "deployment_agent_website_contributor" {
  scope                = var.web_app_id
  role_definition_name = "Website Contributor"
  principal_id         = var.deployment_agent_principal_id
}
