resource "azurerm_windows_virtual_machine" "wvm" {
  name                  = var.wvm_name
  resource_group_name   = var.rg_name
  location              = var.wvm_location
  size                  = var.wvm_size
  admin_username        = var.wvm_admin_username
  admin_password        = var.wvm_admin_password
  network_interface_ids = [var.nic_id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}
