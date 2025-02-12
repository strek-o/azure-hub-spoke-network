module "hub" {
  source = "../../modules/hub"

}

resource "azurerm_virtual_network" "vnet-hub" {
  name                = var.vnet_hub_name
  location            = module.hub.rg_location
  resource_group_name = module.hub.rg_name
  address_space       = ["10.0.0.0/16"]
  subnet              = []

}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.0.0/24"]

}

resource "azurerm_subnet" "snet-hub-1" {
  name                 = var.snet_hub_1_name
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.1.0/24"]

}

module "dev" {
  source = "../../environments/dev"

}

resource "azurerm_virtual_network" "vnet-dev-001" {
  name                = var.vnet_dev_001_name
  location            = module.dev.rg_001_location
  resource_group_name = module.dev.rg_001_name
  address_space       = ["10.1.0.0/16"]
  subnet              = []

}

resource "azurerm_subnet" "snet-dev-001-1" {
  name                 = var.snet_dev_001_1_name
  resource_group_name  = azurerm_virtual_network.vnet-dev-001.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-dev-001.name
  address_prefixes     = ["10.1.0.0/24"]

}

module "prod" {
  source = "../../environments/prod"

}

resource "azurerm_virtual_network" "vnet-prod-001" {
  name                = var.vnet_prod_001_name
  location            = module.prod.rg_001_location
  resource_group_name = module.prod.rg_001_name
  address_space       = ["10.2.0.0/16"]
  subnet              = []

}

resource "azurerm_subnet" "snet-prod-001-1" {
  name                 = var.snet_prod_001_1_name
  resource_group_name  = azurerm_virtual_network.vnet-prod-001.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-prod-001.name
  address_prefixes     = ["10.2.0.0/24"]

}

resource "azurerm_virtual_network" "vnet-prod-002" {
  name                = var.vnet_prod_002_name
  location            = module.prod.rg_002_location
  resource_group_name = module.prod.rg_002_name
  address_space       = ["10.3.0.0/16"]
  subnet              = []

}

resource "azurerm_subnet" "snet-prod-002-1" {
  name                 = var.snet_prod_002_1_name
  resource_group_name  = azurerm_virtual_network.vnet-prod-002.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-prod-002.name
  address_prefixes     = ["10.3.0.0/24"]

}

resource "azurerm_subnet" "snet-prod-002-2" {
  name                 = var.snet_prod_002_2_name
  resource_group_name  = azurerm_virtual_network.vnet-prod-002.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-prod-002.name
  address_prefixes     = ["10.3.1.0/24"]

}

resource "null_resource" "nw-delete" {
  provisioner "local-exec" {
    command = "az group delete --name NetworkWatcherRG --yes --no-wait"
  }
  depends_on = [azurerm_virtual_network.vnet-hub, azurerm_virtual_network.vnet-dev-001,
  azurerm_virtual_network.vnet-prod-001, azurerm_virtual_network.vnet-prod-002]

}
