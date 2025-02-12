resource "azurerm_resource_group" "rg-prod-001" {
  name     = var.rg_001_name
  location = var.rg_001_location

}

resource "azurerm_resource_group" "rg-prod-002" {
  name     = var.rg_002_name
  location = var.rg_002_location

}
