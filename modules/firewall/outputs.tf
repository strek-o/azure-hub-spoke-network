output "fw_name" {
  value = azurerm_firewall.fw.name
}

output "rg_name" {
  value = azurerm_firewall.fw.resource_group_name
}

output "private_ip_address" {
  value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}
