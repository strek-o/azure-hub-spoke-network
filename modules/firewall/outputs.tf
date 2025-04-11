output "name" {
  value = azurerm_firewall.firewall.name
}

output "resource_group_name" {
  value = azurerm_firewall.firewall.resource_group_name
}

output "private_ip_address" {
  value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}
