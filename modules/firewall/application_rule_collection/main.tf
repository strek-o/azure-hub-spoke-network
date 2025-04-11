resource "azurerm_firewall_application_rule_collection" "application_rule_collection" {
  name                = var.name
  azure_firewall_name = var.azure_firewall_name
  resource_group_name = var.resource_group_name
  priority            = var.priority
  action              = var.action
  rule {
    name             = var.rule_name
    source_addresses = var.source_addresses
    target_fqdns     = var.target_fqdns

    protocol {
      port = 80
      type = "Http"
    }

    protocol {
      port = 443
      type = "Https"
    }
  }
}
