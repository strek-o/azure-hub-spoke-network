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

module "SecurityAdminConfiguration" {
  source   = "./modules/network_manager/security_admin_configuration"
  sac_name = "SecurityAdminConfiguration"
  nm_id    = module.NetworkManager.nm_id
}

module "arc-hub" {
  source   = "./modules/network_manager/admin_rule_collection"
  arc_name = "arc-hub"
  sac_id   = module.SecurityAdminConfiguration.sac_id
  netg_id  = module.netg-hub.netg_id
}

module "ar-DenyInboundAll" {
  source                        = "./modules/network_manager/admin_rule"
  ar_name                       = "DenyInboundAll"
  arc_id                        = module.arc-hub.arc_id
  ar_action                     = "Deny"
  ar_direction                  = "Inbound"
  ar_priority                   = 1
  ar_protocol                   = "Any"
  ar_source_port_ranges         = "0-65535"
  ar_destination_port_ranges    = "0-65535"
  ar_source_address_prefix      = "*"
  ar_destination_address_prefix = "*"
}

module "dp-hub" {
  source      = "./modules/network_manager/deployment"
  nm_id       = module.NetworkManager.nm_id
  dp_location = module.rg-hub.rg_location
  sac_id      = module.SecurityAdminConfiguration.sac_id
  depends_on = [
    module.SecurityAdminConfiguration,
    module.arc-hub,
    module.ar-DenyInboundAll
  ]
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

module "arc-dev" {
  source   = "./modules/network_manager/admin_rule_collection"
  arc_name = "arc-dev"
  sac_id   = module.SecurityAdminConfiguration.sac_id
  netg_id  = module.netg-dev.netg_id
}

module "ar-AllowInboundRDP" {
  source                        = "./modules/network_manager/admin_rule"
  ar_name                       = "AllowInboundRDP"
  arc_id                        = module.arc-dev.arc_id
  ar_action                     = "Allow"
  ar_direction                  = "Inbound"
  ar_priority                   = 100
  ar_protocol                   = "Tcp"
  ar_source_port_ranges         = "0-65535"
  ar_destination_port_ranges    = "3389"
  ar_source_address_prefix      = "*"
  ar_destination_address_prefix = "*"
}

module "dp-dev-001" {
  source      = "./modules/network_manager/deployment"
  nm_id       = module.NetworkManager.nm_id
  dp_location = module.rg-dev-001.rg_location
  sac_id      = module.SecurityAdminConfiguration.sac_id
  depends_on = [
    module.SecurityAdminConfiguration,
    module.arc-dev,
    module.ar-AllowInboundRDP
  ]
}

module "pip-Main-001" {
  source       = "./modules/public_ip"
  pip_name     = "pip-Main-001"
  rg_name      = module.rg-dev-001.rg_name
  pip_location = module.rg-dev-001.rg_location
}

module "nic-Main-001" {
  source                    = "./modules/network_interface"
  nic_name                  = "nic-Main-001"
  nic_location              = module.rg-dev-001.rg_location
  rg_name                   = module.rg-dev-001.rg_name
  nic_ip_configuration_name = "nic-ip-config-dev-001"
  snet_id                   = module.DevSubnet.snet_id
  pip_id                    = module.pip-Main-001.pip_id
}

module "vm-Main-001" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "vm-Main-001"
  rg_name            = module.rg-dev-001.rg_name
  wvm_location       = module.rg-dev-001.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_Main_001_admin_username
  wvm_admin_password = var.vm_Main_001_admin_password
  nic_id             = module.nic-Main-001.nic_id
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

resource "null_resource" "DeleteNetworkWatcher" {
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

resource "azurerm_policy_definition" "DenyNetworkWatcher" {
  name         = "DenyNetworkWatcher"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Network Watcher"

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "field": "type",
          "equals": "Microsoft.Network/networkWatchers"
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  }
  POLICY_RULE
}

data "azurerm_subscription" "current" {
}

resource "azurerm_subscription_policy_assignment" "pa-DenyNetworkWatcher" {
  name                 = "pa-DenyNetworkWatcher"
  policy_definition_id = azurerm_policy_definition.DenyNetworkWatcher.id
  subscription_id      = data.azurerm_subscription.current.id
}
