############################################################
# Private DNS configuration
############################################################

locals {
  private_dns_zones = {
    sql         = "privatelink.database.windows.net"
    key_vault   = "privatelink.vaultcore.azure.net"
    storage     = "privatelink.blob.core.windows.net"
    app_service = "privatelink.azurewebsites.net"
  }

  virtual_networks = {
    application = var.application_vnet_id
    deployment  = var.deployment_vnet_id
  }

  dns_zone_vnet_links = {
    for pair in setproduct(
      keys(local.private_dns_zones),
      keys(local.virtual_networks)
      ) : "${pair[0]}-${pair[1]}" => {
      zone_key = pair[0]
      vnet_key = pair[1]
    }
  }
}

############################################################
# Private DNS Zones
############################################################

resource "azurerm_private_dns_zone" "this" {
  for_each = local.private_dns_zones

  name                = each.value
  resource_group_name = var.resource_group_name

  tags = var.tags
}

############################################################
# Virtual Network Links
############################################################

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.dns_zone_vnet_links

  name = "link-${each.value.vnet_key}"

  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.value.zone_key].name
  virtual_network_id    = local.virtual_networks[each.value.vnet_key]

  registration_enabled = false

  tags = var.tags
}
