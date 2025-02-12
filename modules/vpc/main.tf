module "hub" {
  source = "../../modules/hub"

}

resource "azurerm_virtual_network" "vnet-hub" {
  name                = var.vnet_name_hub
  location            = module.hub.rg_location
  resource_group_name = module.hub.rg_name
  address_space       = ["10.0.0.0/16"]
  subnet              = []

}

resource "azurerm_subnet" "subnet-hub" {
  name                 = var.subnet_name_hub
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.0.0/24"]

}


module "dev" {
  source = "../../environments/dev"

}

resource "azurerm_virtual_network" "vnet-dev-001" {
  name                = var.vnet_name_dev_001
  location            = module.dev.rg_location_001
  resource_group_name = module.dev.rg_name_001
  address_space       = ["10.1.0.0/16"]
  subnet              = []

}

resource "azurerm_subnet" "subnet-dev-001-001" {
  name                 = var.subnet_name_dev_001_001
  resource_group_name  = azurerm_virtual_network.vnet-dev-001.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-dev-001.name
  address_prefixes     = ["10.1.0.0/24"]

}

module "prod" {
  source = "../../environments/prod"

}

resource "azurerm_virtual_network" "vnet-prod-001" {
  name                = var.vnet_name_prod_001
  location            = module.prod.rg_location_001
  resource_group_name = module.prod.rg_name_001
  address_space       = ["10.2.0.0/16"]
  subnet              = []

}

resource "azurerm_subnet" "subnet-prod-001-001" {
  name                 = var.subnet_name_prod_001_001
  resource_group_name  = azurerm_virtual_network.vnet-prod-001.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-prod-001.name
  address_prefixes     = ["10.2.0.0/24"]

}

resource "azurerm_virtual_network" "vnet-prod-002" {
  name                = var.vnet_name_prod_002
  location            = module.prod.rg_location_002
  resource_group_name = module.prod.rg_name_002
  address_space       = ["10.3.0.0/16"]
  subnet              = []

}

resource "azurerm_subnet" "subnet-prod-002-001" {
  name                 = var.subnet_name_prod_002_001
  resource_group_name  = azurerm_virtual_network.vnet-prod-002.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-prod-002.name
  address_prefixes     = ["10.3.0.0/24"]

}

resource "azurerm_subnet" "subnet-prod-002-002" {
  name                 = var.subnet_name_prod_002_002
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
