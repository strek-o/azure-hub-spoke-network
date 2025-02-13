resource "azurerm_network_manager_static_member" "smem" {
  name                      = var.smem_name
  network_group_id          = var.netg_id
  target_virtual_network_id = var.target_virtual_network_id
}
