module "hub" {
  source = "../hub"

}

module "vpc" {
  source = "../vpc"

}

data "azurerm_subscription" "current" {
}

resource "azurerm_network_manager" "nm" {
  name                = var.nm_name
  location            = module.hub.rg_location
  resource_group_name = module.hub.rg_name
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
  scope_accesses = ["SecurityAdmin"]

}

resource "azurerm_network_manager_network_group" "ng-hub" {
  name               = var.ng_name_hub
  network_manager_id = azurerm_network_manager.nm.id

}

resource "azurerm_network_manager_static_member" "member-hub" {
  name                      = module.vpc.vnet_name_hub
  network_group_id          = azurerm_network_manager_network_group.ng-hub.id
  target_virtual_network_id = module.vpc.vnet_id_hub

}

resource "azurerm_network_manager_network_group" "ng-dev" {
  name               = var.ng_name_dev
  network_manager_id = azurerm_network_manager.nm.id

}

resource "azurerm_network_manager_static_member" "member-dev-001" {
  name                      = module.vpc.vnet_name_dev_001
  network_group_id          = azurerm_network_manager_network_group.ng-dev.id
  target_virtual_network_id = module.vpc.vnet_id_dev_001

}

resource "azurerm_network_manager_network_group" "ng-prod" {
  name               = var.ng_name_prod
  network_manager_id = azurerm_network_manager.nm.id

}

resource "azurerm_network_manager_static_member" "member-prod-001" {
  name                      = module.vpc.vnet_name_prod_001
  network_group_id          = azurerm_network_manager_network_group.ng-prod.id
  target_virtual_network_id = module.vpc.vnet_id_prod_001

}

resource "azurerm_network_manager_static_member" "member-prod-002" {
  name                      = module.vpc.vnet_name_prod_002
  network_group_id          = azurerm_network_manager_network_group.ng-prod.id
  target_virtual_network_id = module.vpc.vnet_id_prod_002

}
