############################################################
# Storage Account
############################################################

resource "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  public_network_access_enabled = false

  tags = var.tags
}

############################################################
# Private Blob Containers
############################################################

resource "azurerm_storage_container" "this" {
  for_each = var.container_names

  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}
