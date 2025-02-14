resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.nic_location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = var.nic_ip_configuration_name
    subnet_id                     = var.snet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.pip_id
  }
}
