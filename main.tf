module "rg-hub" {
  source      = "./modules/resource_group"
  rg_name     = "rg-hub"
  rg_location = "Poland Central"
}

module "vnet-hub" {
  source             = "./modules/virtual_network"
  vnet_name          = "vnet-hub"
  vnet_location      = module.rg-hub.rg_location
  rg_name            = module.rg-hub.rg_name
  vnet_address_space = ["10.0.0.0/16"]
}

module "GatewaySubnet" {
  source                = "./modules/subnet"
  snet_name             = "GatewaySubnet"
  rg_name               = module.vnet-hub.rg_name
  vnet_name             = module.vnet-hub.vnet_name
  snet_address_prefixes = ["10.0.0.0/24"]
}

module "GeneralSubnet" {
  source                = "./modules/subnet"
  snet_name             = "GeneralSubnet"
  rg_name               = module.vnet-hub.rg_name
  vnet_name             = module.vnet-hub.vnet_name
  snet_address_prefixes = ["10.0.1.0/24"]
}

module "NetworkManager" {
  source            = "./modules/network_manager"
  nm_name           = "NetworkManager"
  nm_location       = module.rg-hub.rg_location
  rg_name           = module.rg-hub.rg_name
  nm_scope_accesses = ["SecurityAdmin"]
}

module "netg-hub" {
  source    = "./modules/network_manager/network_group"
  netg_name = "netg-hub"
  nm_id     = module.NetworkManager.nm_id
}

module "smem-hub" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = module.vnet-hub.vnet_name
  netg_id                        = module.netg-hub.netg_id
  smem_target_virtual_network_id = module.vnet-hub.vnet_id
}

module "rg-dev-001" {
  source      = "./modules/resource_group"
  rg_name     = "rg-dev-001"
  rg_location = "North Europe"
}

module "vnet-dev-001" {
  source             = "./modules/virtual_network"
  vnet_name          = "vnet-dev-001"
  vnet_location      = module.rg-dev-001.rg_location
  rg_name            = module.rg-dev-001.rg_name
  vnet_address_space = ["10.10.0.0/16"]
}

module "DevSubnet" {
  source                = "./modules/subnet"
  snet_name             = "DevSubnet"
  rg_name               = module.vnet-dev-001.rg_name
  vnet_name             = module.vnet-dev-001.vnet_name
  snet_address_prefixes = ["10.10.0.0/24"]
}

module "netg-dev" {
  source    = "./modules/network_manager/network_group"
  netg_name = "netg-dev"
  nm_id     = module.NetworkManager.nm_id
}

module "smem-dev" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = module.vnet-dev-001.vnet_name
  netg_id                        = module.netg-dev.netg_id
  smem_target_virtual_network_id = module.vnet-dev-001.vnet_id
}

module "rg-prod-001" {
  source      = "./modules/resource_group"
  rg_name     = "rg-prod-001"
  rg_location = "Poland Central"
}

module "vnet-prod-001" {
  source             = "./modules/virtual_network"
  vnet_name          = "vnet-prod-001"
  vnet_location      = module.rg-prod-001.rg_location
  rg_name            = module.rg-prod-001.rg_name
  vnet_address_space = ["10.20.0.0/16"]
}

module "ProdSubnet" {
  source                = "./modules/subnet"
  snet_name             = "ProdSubnet"
  rg_name               = module.vnet-prod-001.rg_name
  vnet_name             = module.vnet-prod-001.vnet_name
  snet_address_prefixes = ["10.20.0.0/24"]
}

module "netg-prod-001" {
  source    = "./modules/network_manager/network_group"
  netg_name = "netg-prod-001"
  nm_id     = module.NetworkManager.nm_id
}

module "smem-prod-001" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = module.vnet-prod-001.vnet_name
  netg_id                        = module.netg-prod-001.netg_id
  smem_target_virtual_network_id = module.vnet-prod-001.vnet_id
}

module "rg-prod-002" {
  source      = "./modules/resource_group"
  rg_name     = "rg-prod-002"
  rg_location = "East US"
}

module "vnet-prod-002" {
  source             = "./modules/virtual_network"
  vnet_name          = "vnet-prod-002"
  vnet_location      = module.rg-prod-002.rg_location
  rg_name            = module.rg-prod-002.rg_name
  vnet_address_space = ["10.30.0.0/16"]
}

module "ManufacturingSubnet" {
  source                = "./modules/subnet"
  snet_name             = "ManufacturingSubnet"
  rg_name               = module.vnet-prod-002.rg_name
  vnet_name             = module.vnet-prod-002.vnet_name
  snet_address_prefixes = ["10.30.0.0/24"]
}

module "SalesSubnet" {
  source                = "./modules/subnet"
  snet_name             = "SalesSubnet"
  rg_name               = module.vnet-prod-002.rg_name
  vnet_name             = module.vnet-prod-002.vnet_name
  snet_address_prefixes = ["10.30.1.0/24"]
}

module "netg-prod" {
  source    = "./modules/network_manager/network_group"
  netg_name = "netg-prod"
  nm_id     = module.NetworkManager.nm_id
}

module "smem-prod" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = module.vnet-prod-002.vnet_name
  netg_id                        = module.netg-prod.netg_id
  smem_target_virtual_network_id = module.vnet-prod-002.vnet_id
}

resource "null_resource" "nw-delete" {
  provisioner "local-exec" {
    command = "az group delete --name NetworkWatcherRG --yes --no-wait"
  }
  depends_on = [
    module.vnet-hub,
    module.vnet-dev-001,
    module.vnet-prod-001,
    module.vnet-prod-002
  ]
}
