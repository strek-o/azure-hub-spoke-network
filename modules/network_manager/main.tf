resource "azurerm_network_manager" "network_manager" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  scope_accesses      = var.scope_accesses

  scope {
    subscription_ids = var.subscription_ids
  }
}
