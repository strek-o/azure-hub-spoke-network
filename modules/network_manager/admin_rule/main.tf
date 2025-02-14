resource "azurerm_network_manager_admin_rule" "ar" {
  name                     = var.ar_name
  admin_rule_collection_id = var.arc_id
  action                   = var.ar_action
  direction                = var.ar_direction
  priority                 = var.ar_priority
  protocol                 = var.ar_protocol
  source_port_ranges       = [var.ar_source_port_ranges]
  destination_port_ranges  = [var.ar_destination_port_ranges]
  source {
    address_prefix_type = "IPPrefix"
    address_prefix      = var.ar_source_address_prefix
  }
  destination {
    address_prefix_type = "IPPrefix"
    address_prefix      = var.ar_destination_address_prefix
  }
}
