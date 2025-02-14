resource "azurerm_network_manager_deployment" "dp" {
  network_manager_id = var.nm_id
  location           = var.dp_location
  scope_access       = "SecurityAdmin"
  configuration_ids  = [var.sac_id]
}
