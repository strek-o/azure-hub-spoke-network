output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "rg_name" {
  value = azurerm_virtual_network.vnet.resource_group_name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
