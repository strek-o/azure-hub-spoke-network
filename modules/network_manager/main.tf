data "azurerm_subscription" "current" {
}

resource "azurerm_network_manager" "nm" {
  name                = var.nm_name
  location            = var.nm_location
  resource_group_name = var.rg_name
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
  scope_accesses = var.nm_scope_accesses
}
