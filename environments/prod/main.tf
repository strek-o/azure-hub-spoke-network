resource "azurerm_resource_group" "rg-prod-001" {
  name     = var.rg_name_001
  location = var.rg_location_001

}

resource "azurerm_resource_group" "rg-prod-002" {
  name     = var.rg_name_002
  location = var.rg_location_002

}
