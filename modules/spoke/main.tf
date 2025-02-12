module "hub" {
  source = "../hub"

}

module "vpc" {
  source = "../vpc"

}

data "azurerm_subscription" "current" {
}

resource "azurerm_network_manager" "NetworkManager" {
  name                = "NetworkManager"
  location            = module.hub.rg_location
  resource_group_name = module.hub.rg_name
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
  scope_accesses = ["SecurityAdmin"]

}

resource "azurerm_network_manager_network_group" "ng-hub" {
  name               = var.ng_hub_name
  network_manager_id = azurerm_network_manager.NetworkManager.id

}

resource "azurerm_network_manager_static_member" "member-hub" {
  name                      = module.vpc.vnet_hub_name
  network_group_id          = azurerm_network_manager_network_group.ng-hub.id
  target_virtual_network_id = module.vpc.vnet_hub_id

}

resource "azurerm_network_manager_network_group" "ng-dev" {
  name               = var.ng_dev_name
  network_manager_id = azurerm_network_manager.NetworkManager.id

}

resource "azurerm_network_manager_static_member" "member-dev-001" {
  name                      = module.vpc.vnet_dev_001_name
  network_group_id          = azurerm_network_manager_network_group.ng-dev.id
  target_virtual_network_id = module.vpc.vnet_dev_001_id

}

resource "azurerm_network_manager_network_group" "ng-prod" {
  name               = var.ng_prod_name
  network_manager_id = azurerm_network_manager.NetworkManager.id

}

resource "azurerm_network_manager_static_member" "member-prod-001" {
  name                      = module.vpc.vnet_prod_001_name
  network_group_id          = azurerm_network_manager_network_group.ng-prod.id
  target_virtual_network_id = module.vpc.vnet_prod_001_id

}

resource "azurerm_network_manager_static_member" "member-prod-002" {
  name                      = module.vpc.vnet_prod_002_name
  network_group_id          = azurerm_network_manager_network_group.ng-prod.id
  target_virtual_network_id = module.vpc.vnet_prod_002_id

}
