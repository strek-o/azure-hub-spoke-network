resource "azurerm_network_manager_admin_rule" "admin_rule" {
  name                     = var.name
  admin_rule_collection_id = var.admin_rule_collection_id
  action                   = var.action
  direction                = var.direction
  priority                 = var.priority
  protocol                 = var.protocol
  source_port_ranges       = var.source_port_ranges
  destination_port_ranges  = var.destination_port_ranges

  source {
    address_prefix_type = "IPPrefix"
    address_prefix      = var.source_address_prefix
  }

  destination {
    address_prefix_type = "IPPrefix"
    address_prefix      = var.destination_address_prefix
  }
}
