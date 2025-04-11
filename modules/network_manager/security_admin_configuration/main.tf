resource "azurerm_network_manager_security_admin_configuration" "security_admin_configuration" {
  name               = var.name
  network_manager_id = var.network_manager_id
}
