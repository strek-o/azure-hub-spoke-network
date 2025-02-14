resource "azurerm_network_manager_security_admin_configuration" "sac" {
  name               = var.sac_name
  network_manager_id = var.nm_id
}
