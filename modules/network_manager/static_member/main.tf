resource "azurerm_network_manager_static_member" "static_member" {
  name                      = var.name
  network_group_id          = var.network_group_id
  target_virtual_network_id = var.target_virtual_network_id
}
