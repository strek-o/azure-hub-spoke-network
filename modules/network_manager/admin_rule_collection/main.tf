resource "azurerm_network_manager_admin_rule_collection" "admin_rule_collection" {
  name                            = var.name
  security_admin_configuration_id = var.security_admin_configuration_id
  network_group_ids               = var.network_group_ids
}
