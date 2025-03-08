resource "azurerm_firewall" "fw" {
  name                = var.fw_name
  location            = var.fw_location
  resource_group_name = var.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "ip-configuration"
    subnet_id            = var.snet_id
    public_ip_address_id = var.pip_id
  }
}
