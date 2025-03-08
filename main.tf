#* Resource Groups

module "rg-hub" {
  source      = "./modules/resource_group"
  rg_name     = "rg-hub"
  rg_location = "UK South"
}

module "rg-dev-001" {
  source      = "./modules/resource_group"
  rg_name     = "rg-dev-001"
  rg_location = "North Europe"
}

module "rg-prod-001" {
  source      = "./modules/resource_group"
  rg_name     = "rg-prod-001"
  rg_location = "Poland Central"
}

module "rg-prod-002" {
  source      = "./modules/resource_group"
  rg_name     = "rg-prod-002"
  rg_location = "East US"
}

#* Virtual Networks

module "vnet-hub" {
  source             = "./modules/virtual_network"
  vnet_name          = "vnet-hub"
  vnet_location      = module.rg-hub.rg_location
  rg_name            = module.rg-hub.rg_name
  vnet_address_space = ["10.0.0.0/16"]
}

module "vnet-dev-001" {
  source             = "./modules/virtual_network"
  vnet_name          = "vnet-dev-001"
  vnet_location      = module.rg-dev-001.rg_location
  rg_name            = module.rg-dev-001.rg_name
  vnet_address_space = ["10.10.0.0/16"]
}

module "vnet-prod-001" {
  source             = "./modules/virtual_network"
  vnet_name          = "vnet-prod-001"
  vnet_location      = module.rg-prod-001.rg_location
  rg_name            = module.rg-prod-001.rg_name
  vnet_address_space = ["10.20.0.0/16"]
}

module "vnet-prod-002" {
  source             = "./modules/virtual_network"
  vnet_name          = "vnet-prod-002"
  vnet_location      = module.rg-prod-002.rg_location
  rg_name            = module.rg-prod-002.rg_name
  vnet_address_space = ["10.30.0.0/16"]
}

#* Subnets

module "AzureFirewallSubnet" {
  source                = "./modules/subnet"
  snet_name             = "AzureFirewallSubnet"
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

module "DevSubnet" {
  source                = "./modules/subnet"
  snet_name             = "DevSubnet"
  rg_name               = module.vnet-dev-001.rg_name
  vnet_name             = module.vnet-dev-001.vnet_name
  snet_address_prefixes = ["10.10.0.0/24"]
}

module "ProdSubnet" {
  source                = "./modules/subnet"
  snet_name             = "ProdSubnet"
  rg_name               = module.vnet-prod-001.rg_name
  vnet_name             = module.vnet-prod-001.vnet_name
  snet_address_prefixes = ["10.20.0.0/24"]
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

#* Network Manager

module "NetworkManager" {
  source            = "./modules/network_manager"
  nm_name           = "NetworkManager"
  nm_location       = module.rg-hub.rg_location
  rg_name           = module.rg-hub.rg_name
  nm_scope_accesses = ["SecurityAdmin"]
}

#* Network Groups

module "netg-hub" {
  source    = "./modules/network_manager/network_group"
  netg_name = "netg-hub"
  nm_id     = module.NetworkManager.nm_id
}

module "netg-dev" {
  source    = "./modules/network_manager/network_group"
  netg_name = "netg-dev"
  nm_id     = module.NetworkManager.nm_id
}

module "netg-prod" {
  source    = "./modules/network_manager/network_group"
  netg_name = "netg-prod"
  nm_id     = module.NetworkManager.nm_id
}

#* Static Members

module "smem-hub" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = module.vnet-hub.vnet_name
  netg_id                        = module.netg-hub.netg_id
  smem_target_virtual_network_id = module.vnet-hub.vnet_id
}

module "smem-dev-001" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = module.vnet-dev-001.vnet_name
  netg_id                        = module.netg-dev.netg_id
  smem_target_virtual_network_id = module.vnet-dev-001.vnet_id
}

module "smem-prod-001" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = module.vnet-prod-001.vnet_name
  netg_id                        = module.netg-prod.netg_id
  smem_target_virtual_network_id = module.vnet-prod-001.vnet_id
}

module "smem-prod-002" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = module.vnet-prod-002.vnet_name
  netg_id                        = module.netg-prod.netg_id
  smem_target_virtual_network_id = module.vnet-prod-002.vnet_id
}

#* Public IPs

module "pip-Testing" {
  source       = "./modules/public_ip"
  pip_name     = "pip-Testing"
  rg_name      = module.rg-dev-001.rg_name
  pip_location = module.rg-dev-001.rg_location
}

module "pip-HPC" {
  source       = "./modules/public_ip"
  pip_name     = "pip-HPC"
  rg_name      = module.rg-prod-001.rg_name
  pip_location = module.rg-prod-001.rg_location
}

module "pip-Main" {
  source       = "./modules/public_ip"
  pip_name     = "pip-Main"
  rg_name      = module.rg-prod-002.rg_name
  pip_location = module.rg-prod-002.rg_location
}

module "pip-Backup" {
  source       = "./modules/public_ip"
  pip_name     = "pip-Backup"
  rg_name      = module.rg-prod-002.rg_name
  pip_location = module.rg-prod-002.rg_location
}

module "pip-Hosting" {
  source       = "./modules/public_ip"
  pip_name     = "pip-Hosting"
  rg_name      = module.rg-prod-002.rg_name
  pip_location = module.rg-prod-002.rg_location
}

module "pip-Firewall" {
  source       = "./modules/public_ip"
  pip_name     = "pip-Firewall"
  rg_name      = module.rg-hub.rg_name
  pip_location = module.rg-hub.rg_location
}

#* Network Interfaces

module "nic-Testing" {
  source                    = "./modules/network_interface"
  nic_name                  = "nic-Testing"
  nic_location              = module.rg-dev-001.rg_location
  rg_name                   = module.rg-dev-001.rg_name
  nic_ip_configuration_name = "cfg-Testing"
  snet_id                   = module.DevSubnet.snet_id
  pip_id                    = module.pip-Testing.pip_id
}

module "nic-HPC" {
  source                    = "./modules/network_interface"
  nic_name                  = "nic-HPC"
  nic_location              = module.rg-prod-001.rg_location
  rg_name                   = module.rg-prod-001.rg_name
  nic_ip_configuration_name = "cfg-HPC"
  snet_id                   = module.ProdSubnet.snet_id
  pip_id                    = module.pip-HPC.pip_id
}

module "nic-Main" {
  source                    = "./modules/network_interface"
  nic_name                  = "nic-Main"
  nic_location              = module.rg-prod-002.rg_location
  rg_name                   = module.rg-prod-002.rg_name
  nic_ip_configuration_name = "cfg-Main"
  snet_id                   = module.ManufacturingSubnet.snet_id
  pip_id                    = module.pip-Main.pip_id
}

module "nic-Backup" {
  source                    = "./modules/network_interface"
  nic_name                  = "nic-Backup"
  nic_location              = module.rg-prod-002.rg_location
  rg_name                   = module.rg-prod-002.rg_name
  nic_ip_configuration_name = "cfg-Backup"
  snet_id                   = module.ManufacturingSubnet.snet_id
  pip_id                    = module.pip-Backup.pip_id
}

module "nic-Hosting" {
  source                    = "./modules/network_interface"
  nic_name                  = "nic-Hosting"
  nic_location              = module.rg-prod-002.rg_location
  rg_name                   = module.rg-prod-002.rg_name
  nic_ip_configuration_name = "cfg-Hosting"
  snet_id                   = module.SalesSubnet.snet_id
  pip_id                    = module.pip-Hosting.pip_id
}

#* Virtual Machines

module "vm-Testing" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "vm-Testing"
  rg_name            = module.rg-dev-001.rg_name
  wvm_location       = module.rg-dev-001.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_Testing_admin_username
  wvm_admin_password = var.vm_Testing_admin_password
  nic_id             = module.nic-Testing.nic_id
}

module "vm-HPC" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "vm-HPC"
  rg_name            = module.rg-prod-001.rg_name
  wvm_location       = module.rg-prod-001.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_HPC_admin_username
  wvm_admin_password = var.vm_HPC_admin_password
  nic_id             = module.nic-HPC.nic_id
}

module "vm-Main" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "vm-Main"
  rg_name            = module.rg-prod-002.rg_name
  wvm_location       = module.rg-prod-002.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_Main_admin_username
  wvm_admin_password = var.vm_Main_admin_password
  nic_id             = module.nic-Main.nic_id
}

module "vm-Backup" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "vm-Backup"
  rg_name            = module.rg-prod-002.rg_name
  wvm_location       = module.rg-prod-002.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_Backup_admin_username
  wvm_admin_password = var.vm_Backup_admin_password
  nic_id             = module.nic-Backup.nic_id
}

module "vm-Hosting" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "vm-Hosting"
  rg_name            = module.rg-prod-002.rg_name
  wvm_location       = module.rg-prod-002.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_Hosting_admin_username
  wvm_admin_password = var.vm_Hosting_admin_password
  nic_id             = module.nic-Hosting.nic_id
}

#* Security Admin Configuration

module "SecurityAdminConfiguration" {
  source   = "./modules/network_manager/security_admin_configuration"
  sac_name = "SecurityAdminConfiguration"
  nm_id    = module.NetworkManager.nm_id
}

#* Admin Rule Collection

module "arc-Basic" {
  source   = "./modules/network_manager/admin_rule_collection"
  arc_name = "arc-Basic"
  sac_id   = module.SecurityAdminConfiguration.sac_id
  netg_ids = [module.netg-hub.netg_id, module.netg-dev.netg_id, module.netg-prod.netg_id]
}

#* Admin Rules

module "ar-AllowInboundRDP" {
  source                        = "./modules/network_manager/admin_rule"
  ar_name                       = "AllowInboundRDP"
  arc_id                        = module.arc-Basic.arc_id
  ar_action                     = "Allow"
  ar_direction                  = "Inbound"
  ar_priority                   = 100
  ar_protocol                   = "Tcp"
  ar_source_port_ranges         = "0-65535"
  ar_destination_port_ranges    = "3389"
  ar_source_address_prefix      = "*"
  ar_destination_address_prefix = "*"
}

module "ar-DenyInboundAll" {
  source                        = "./modules/network_manager/admin_rule"
  ar_name                       = "DenyInboundAll"
  arc_id                        = module.arc-Basic.arc_id
  ar_action                     = "Deny"
  ar_direction                  = "Inbound"
  ar_priority                   = 900
  ar_protocol                   = "Any"
  ar_source_port_ranges         = "0-65535"
  ar_destination_port_ranges    = "0-65535"
  ar_source_address_prefix      = "*"
  ar_destination_address_prefix = "*"
}

#* Deployments

module "dp-hub" {
  source      = "./modules/network_manager/deployment"
  nm_id       = module.NetworkManager.nm_id
  dp_location = module.rg-hub.rg_location
  sac_id      = module.SecurityAdminConfiguration.sac_id
  depends_on = [
    module.SecurityAdminConfiguration,
    module.arc-Basic,
    module.ar-AllowInboundRDP,
    module.ar-DenyInboundAll
  ]
}

module "dp-dev-001" {
  source      = "./modules/network_manager/deployment"
  nm_id       = module.NetworkManager.nm_id
  dp_location = module.rg-dev-001.rg_location
  sac_id      = module.SecurityAdminConfiguration.sac_id
  depends_on  = [module.dp-hub]
}

module "dp-prod-001" {
  source      = "./modules/network_manager/deployment"
  nm_id       = module.NetworkManager.nm_id
  dp_location = module.rg-prod-001.rg_location
  sac_id      = module.SecurityAdminConfiguration.sac_id
  depends_on  = [module.dp-dev-001]
}

module "dp-prod-002" {
  source      = "./modules/network_manager/deployment"
  nm_id       = module.NetworkManager.nm_id
  dp_location = module.rg-prod-002.rg_location
  sac_id      = module.SecurityAdminConfiguration.sac_id
  depends_on  = [module.dp-prod-001]
}

#* Firewall

module "Firewall" {
  source      = "./modules/firewall"
  fw_name     = "Firewall"
  fw_location = module.rg-hub.rg_location
  rg_name     = module.rg-hub.rg_name
  snet_id     = module.AzureFirewallSubnet.snet_id
  pip_id      = module.pip-Firewall.pip_id
}

#* Application Rule Collection

module "ApplicationRuleCollection" {
  source     = "./modules/firewall/application_rule_collection"
  arc_name   = "arc-ApplicationRuleCollection"
  fw_name    = module.Firewall.fw_name
  rg_name    = module.Firewall.rg_name
  priority   = 100
  action     = "Allow"
  depends_on = [module.Firewall]
}

#* Policy Definition

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

#* Policy Assignment

data "azurerm_subscription" "current" {
}

resource "azurerm_subscription_policy_assignment" "pa-DenyNetworkWatcher" {
  name                 = "pa-DenyNetworkWatcher"
  policy_definition_id = azurerm_policy_definition.DenyNetworkWatcher.id
  subscription_id      = data.azurerm_subscription.current.id
}

#* Local Execution

resource "null_resource" "DeleteNetworkWatcher" {
  provisioner "local-exec" {
    command = "az group delete --name NetworkWatcherRG --yes --no-wait"
  }
  depends_on = [
    module.vnet-hub,
    module.vnet-dev-001,
    module.vnet-prod-001,
    module.vnet-prod-002,
    resource.azurerm_subscription_policy_assignment.pa-DenyNetworkWatcher
  ]
}
