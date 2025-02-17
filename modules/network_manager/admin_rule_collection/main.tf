resource "azurerm_network_manager_admin_rule_collection" "arc" {
  name                            = var.arc_name
  security_admin_configuration_id = var.sac_id
  network_group_ids               = var.netg_ids
}
