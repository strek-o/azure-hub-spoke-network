resource "azurerm_network_manager_network_group" "netg" {
  name               = var.netg_name
  network_manager_id = var.nm_id
}
