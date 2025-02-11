resource "azurerm_resource_group" "rg-prod-001" {
  name     = var.rg_name_prod_001
  location = var.rg_location_prod_001
}

resource "azurerm_resource_group" "rg-prod-002" {
  name     = var.rg_name_prod_002
  location = var.rg_location_prod_002
}
