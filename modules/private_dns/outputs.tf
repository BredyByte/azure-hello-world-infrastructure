############################################################
# Private DNS Zone IDs
############################################################

output "private_dns_zone_ids" {
  description = "Resource IDs of the Private DNS Zones."

  value = {
    for key, zone in azurerm_private_dns_zone.this :
    key => zone.id
  }
}

############################################################
# Private DNS Zone Names
############################################################

output "private_dns_zone_names" {
  description = "Names of the Private DNS Zones."

  value = {
    for key, zone in azurerm_private_dns_zone.this :
    key => zone.name
  }
}
