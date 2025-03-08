resource "azurerm_firewall_application_rule_collection" "arc" {
  name                = var.arc_name
  azure_firewall_name = var.fw_name
  resource_group_name = var.rg_name
  priority            = var.priority
  action              = var.action
  rule {
    name             = "AllowGoogle"
    source_addresses = ["10.10.0.0/16"]
    target_fqdns     = ["*.google.com"]

    protocol {
      port = 443
      type = "Https"
    }
  }
}
