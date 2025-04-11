resource "azurerm_network_manager_deployment" "deployment" {
  network_manager_id = var.network_manager_id
  location           = var.location
  scope_access       = var.scope_access
  configuration_ids  = var.configuration_ids
}
