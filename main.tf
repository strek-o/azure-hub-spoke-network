#* Resource Groups

module "HubRG" {
  source      = "./modules/resource_group"
  rg_name     = "HubRG"
  rg_location = "Poland Central"
}

module "VirtualNetworksRG" {
  source      = "./modules/resource_group"
  rg_name     = "VirtualNetworksRG"
  rg_location = "Poland Central"
}

module "PublicIPsRG" {
  source      = "./modules/resource_group"
  rg_name     = "PublicIPsRG"
  rg_location = "Poland Central"
}

module "NetworkInterfacesRG" {
  source      = "./modules/resource_group"
  rg_name     = "NetworkInterfacesRG"
  rg_location = "Poland Central"
}

module "VirtualMachinesRG" {
  source      = "./modules/resource_group"
  rg_name     = "VirtualMachinesRG"
  rg_location = "Poland Central"
}

#* Virtual Networks

module "HubVNET" {
  source             = "./modules/virtual_network"
  vnet_name          = "HubVNET"
  vnet_location      = module.VirtualNetworksRG.rg_location
  rg_name            = module.VirtualNetworksRG.rg_name
  vnet_address_space = ["10.0.0.0/16"]
}

module "DevelopmentVNET" {
  source             = "./modules/virtual_network"
  vnet_name          = "DevelopmentVNET"
  vnet_location      = module.VirtualNetworksRG.rg_location
  rg_name            = module.VirtualNetworksRG.rg_name
  vnet_address_space = ["10.10.0.0/16"]
}

module "RDPConnectionVNET" {
  source             = "./modules/virtual_network"
  vnet_name          = "RDPConnectionVNET"
  vnet_location      = module.VirtualNetworksRG.rg_location
  rg_name            = module.VirtualNetworksRG.rg_name
  vnet_address_space = ["10.11.0.0/16"]
}

module "NonProductionVNET" {
  source             = "./modules/virtual_network"
  vnet_name          = "NonProductionVNET"
  vnet_location      = module.VirtualNetworksRG.rg_location
  rg_name            = module.VirtualNetworksRG.rg_name
  vnet_address_space = ["10.20.0.0/16"]
}

module "ProductionVNET" {
  source             = "./modules/virtual_network"
  vnet_name          = "ProductionVNET"
  vnet_location      = module.VirtualNetworksRG.rg_location
  rg_name            = module.VirtualNetworksRG.rg_name
  vnet_address_space = ["10.30.0.0/16"]
}

#* Subnets

module "AzureFirewallSubnet" {
  source                = "./modules/subnet"
  snet_name             = "AzureFirewallSubnet"
  rg_name               = module.VirtualNetworksRG.rg_name
  vnet_name             = module.HubVNET.vnet_name
  snet_address_prefixes = ["10.0.0.0/24"]
}

module "GeneralSubnet" {
  source                = "./modules/subnet"
  snet_name             = "GeneralSubnet"
  rg_name               = module.VirtualNetworksRG.rg_name
  vnet_name             = module.DevelopmentVNET.vnet_name
  snet_address_prefixes = ["10.10.0.0/24"]
}

module "CheckupSubnet" {
  source                = "./modules/subnet"
  snet_name             = "CheckupSubnet"
  rg_name               = module.VirtualNetworksRG.rg_name
  vnet_name             = module.RDPConnectionVNET.vnet_name
  snet_address_prefixes = ["10.11.0.0/24"]
}

module "AnalyticsSubnet" {
  source                = "./modules/subnet"
  snet_name             = "AnalyticsSubnet"
  rg_name               = module.VirtualNetworksRG.rg_name
  vnet_name             = module.NonProductionVNET.vnet_name
  snet_address_prefixes = ["10.20.0.0/24"]
}

module "WorkloadSubnet" {
  source                = "./modules/subnet"
  snet_name             = "WorkloadSubnet"
  rg_name               = module.VirtualNetworksRG.rg_name
  vnet_name             = module.ProductionVNET.vnet_name
  snet_address_prefixes = ["10.30.0.0/24"]
}

#* Peerings

module "DevelopmentVNETtoRDPConnectionVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "DevelopmentVNETtoRDPConnectionVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.rg_name
  virtual_network_name      = module.DevelopmentVNET.vnet_name
  remote_virtual_network_id = module.RDPConnectionVNET.vnet_id
}

module "RDPConnectionVNETtoDevelopmentVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "RDPConnectionVNETtoDevelopmentVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.rg_name
  virtual_network_name      = module.RDPConnectionVNET.vnet_name
  remote_virtual_network_id = module.DevelopmentVNET.vnet_id
}

module "HubVNETtoDevelopmentVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "HubVNETtoDevelopmentVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.rg_name
  virtual_network_name      = module.HubVNET.vnet_name
  remote_virtual_network_id = module.DevelopmentVNET.vnet_id
}

module "DevelopmentVNETtoHubVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "DevelopmentVNETtoHubVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.rg_name
  virtual_network_name      = module.DevelopmentVNET.vnet_name
  remote_virtual_network_id = module.HubVNET.vnet_id
}

module "HubVNETtoNonProductionVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "HubVNETtoNonProductionVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.rg_name
  virtual_network_name      = module.HubVNET.vnet_name
  remote_virtual_network_id = module.NonProductionVNET.vnet_id
}

module "NonProductionVNETtoHubVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "NonProductionVNETtoHubVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.rg_name
  virtual_network_name      = module.NonProductionVNET.vnet_name
  remote_virtual_network_id = module.HubVNET.vnet_id
}

module "HubVNETtoProductionVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "HubVNETtoProductionVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.rg_name
  virtual_network_name      = module.HubVNET.vnet_name
  remote_virtual_network_id = module.ProductionVNET.vnet_id
}

module "ProductionVNETtoHubVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "ProductionVNETtoHubVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.rg_name
  virtual_network_name      = module.ProductionVNET.vnet_name
  remote_virtual_network_id = module.HubVNET.vnet_id
}

#* Network Manager

module "MainNM" {
  source            = "./modules/network_manager"
  nm_name           = "MainNM"
  nm_location       = module.HubRG.rg_location
  rg_name           = module.HubRG.rg_name
  nm_scope_accesses = ["SecurityAdmin"]
}

#* Network Groups

module "HubNETG" {
  source    = "./modules/network_manager/network_group"
  netg_name = "HubNETG"
  nm_id     = module.MainNM.nm_id
}

module "DevelopmentNETG" {
  source    = "./modules/network_manager/network_group"
  netg_name = "DevelopmentNETG"
  nm_id     = module.MainNM.nm_id
}

module "RDPConnectionNETG" {
  source    = "./modules/network_manager/network_group"
  netg_name = "RDPConnectionNETG"
  nm_id     = module.MainNM.nm_id
}

module "NonProductionNETG" {
  source    = "./modules/network_manager/network_group"
  netg_name = "NonProductionNETG"
  nm_id     = module.MainNM.nm_id
}

module "ProductionNETG" {
  source    = "./modules/network_manager/network_group"
  netg_name = "ProductionNETG"
  nm_id     = module.MainNM.nm_id
}

#* Static Members

module "HubSM" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = "HubSM"
  netg_id                        = module.HubNETG.netg_id
  smem_target_virtual_network_id = module.HubVNET.vnet_id
}

module "DevelopmentSM" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = "DevelopmentSM"
  netg_id                        = module.DevelopmentNETG.netg_id
  smem_target_virtual_network_id = module.DevelopmentVNET.vnet_id
}

module "RDPConnectionSM" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = "RDPConnectionSM"
  netg_id                        = module.RDPConnectionNETG.netg_id
  smem_target_virtual_network_id = module.RDPConnectionVNET.vnet_id
}

module "NonProductionSM" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = "NonProductionSM"
  netg_id                        = module.NonProductionNETG.netg_id
  smem_target_virtual_network_id = module.NonProductionVNET.vnet_id
}

module "ProductionSM" {
  source                         = "./modules/network_manager/static_member"
  smem_name                      = "ProductionSM"
  netg_id                        = module.ProductionNETG.netg_id
  smem_target_virtual_network_id = module.ProductionVNET.vnet_id
}

#* Public IPs

module "AzureFirewallPIP" {
  source       = "./modules/public_ip"
  pip_name     = "AzureFirewallPIP"
  rg_name      = module.PublicIPsRG.rg_name
  pip_location = module.PublicIPsRG.rg_location
}

module "RDPConnectionPIP" {
  source       = "./modules/public_ip"
  pip_name     = "RDPConnectionPIP"
  rg_name      = module.PublicIPsRG.rg_name
  pip_location = module.PublicIPsRG.rg_location
}

#* Network Interfaces

module "TestingNIC" {
  source                    = "./modules/network_interface"
  nic_name                  = "TestingNIC"
  nic_location              = module.NetworkInterfacesRG.rg_location
  rg_name                   = module.NetworkInterfacesRG.rg_name
  nic_ip_configuration_name = "Default"
  snet_id                   = module.GeneralSubnet.snet_id
}

module "RDPConnectionNIC" {
  source                    = "./modules/network_interface"
  nic_name                  = "RDPConnectionNIC"
  nic_location              = module.NetworkInterfacesRG.rg_location
  rg_name                   = module.NetworkInterfacesRG.rg_name
  nic_ip_configuration_name = "Default"
  snet_id                   = module.CheckupSubnet.snet_id
  pip_id                    = module.RDPConnectionPIP.pip_id
}

module "DatabaseNIC" {
  source                    = "./modules/network_interface"
  nic_name                  = "DatabaseNIC"
  nic_location              = module.NetworkInterfacesRG.rg_location
  rg_name                   = module.NetworkInterfacesRG.rg_name
  nic_ip_configuration_name = "Default"
  snet_id                   = module.AnalyticsSubnet.snet_id
}

module "AppNIC" {
  source                    = "./modules/network_interface"
  nic_name                  = "AppNIC"
  nic_location              = module.NetworkInterfacesRG.rg_location
  rg_name                   = module.NetworkInterfacesRG.rg_name
  nic_ip_configuration_name = "Default"
  snet_id                   = module.WorkloadSubnet.snet_id
}

#* Virtual Machines

module "TestingVM" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "TestingVM"
  rg_name            = module.VirtualMachinesRG.rg_name
  wvm_location       = module.VirtualMachinesRG.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_Testing_admin_username
  wvm_admin_password = var.vm_Testing_admin_password
  nic_id             = module.TestingNIC.nic_id
}

module "RDPConnectionVM" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "RDPConnectionVM"
  rg_name            = module.VirtualMachinesRG.rg_name
  wvm_location       = module.VirtualMachinesRG.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_RDPConnection_admin_username
  wvm_admin_password = var.vm_RDPConnection_admin_password
  nic_id             = module.RDPConnectionNIC.nic_id
}

module "DatabaseVM" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "DatabaseVM"
  rg_name            = module.VirtualMachinesRG.rg_name
  wvm_location       = module.VirtualMachinesRG.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_Database_admin_username
  wvm_admin_password = var.vm_Database_admin_password
  nic_id             = module.DatabaseNIC.nic_id
}

module "AppVM" {
  source             = "./modules/windows_virtual_machine"
  wvm_name           = "AppVM"
  rg_name            = module.VirtualMachinesRG.rg_name
  wvm_location       = module.VirtualMachinesRG.rg_location
  wvm_size           = "Standard_B2s"
  wvm_admin_username = var.vm_App_admin_username
  wvm_admin_password = var.vm_App_admin_password
  nic_id             = module.AppNIC.nic_id
}

#* Security Admin Configuration

module "BasicSAC" {
  source   = "./modules/network_manager/security_admin_configuration"
  sac_name = "BasicSAC"
  nm_id    = module.MainNM.nm_id
}

#* [Network Manager] Admin Rule Collections

module "DefaultNMARC" {
  source   = "./modules/network_manager/admin_rule_collection"
  arc_name = "DefaultNMARC"
  sac_id   = module.BasicSAC.sac_id
  netg_ids = [module.DevelopmentNETG.netg_id, module.NonProductionNETG.netg_id, module.ProductionNETG.netg_id]
}

module "RDPConnectionNMARC" {
  source   = "./modules/network_manager/admin_rule_collection"
  arc_name = "RDPConnectionNMARC"
  sac_id   = module.BasicSAC.sac_id
  netg_ids = [module.DevelopmentNETG.netg_id, module.RDPConnectionNETG.netg_id]
}

#* Admin Rules

module "DenyInboundAllRule" {
  source                        = "./modules/network_manager/admin_rule"
  ar_name                       = "DenyInboundAllRule"
  arc_id                        = module.DefaultNMARC.arc_id
  ar_action                     = "Deny"
  ar_direction                  = "Inbound"
  ar_priority                   = 900
  ar_protocol                   = "Any"
  ar_source_port_ranges         = "0-65535"
  ar_destination_port_ranges    = "0-65535"
  ar_source_address_prefix      = "*"
  ar_destination_address_prefix = "*"
}

module "AllowInboundRDPRule" {
  source                        = "./modules/network_manager/admin_rule"
  ar_name                       = "AllowInboundRDPRule"
  arc_id                        = module.RDPConnectionNMARC.arc_id
  ar_action                     = "Allow"
  ar_direction                  = "Inbound"
  ar_priority                   = 100
  ar_protocol                   = "Tcp"
  ar_source_port_ranges         = "0-65535"
  ar_destination_port_ranges    = "3389"
  ar_source_address_prefix      = "*"
  ar_destination_address_prefix = "*"
}

#* Deployment

module "NetworkManagerDP" {
  source      = "./modules/network_manager/deployment"
  nm_id       = module.MainNM.nm_id
  dp_location = module.HubRG.rg_location
  sac_id      = module.BasicSAC.sac_id
  depends_on = [
    module.BasicSAC,
    module.DefaultNMARC,
    module.RDPConnectionNMARC,
    module.DenyInboundAllRule,
    module.AllowInboundRDPRule
  ]
}

#* Firewall

module "AzureFirewall" {
  source      = "./modules/firewall"
  fw_name     = "AzureFirewall"
  fw_location = module.HubRG.rg_location
  rg_name     = module.HubRG.rg_name
  snet_id     = module.AzureFirewallSubnet.snet_id
  pip_id      = module.AzureFirewallPIP.pip_id
}

#* [Firewall] Application Rule Collection

module "AllowGoogleFWARC" {
  source     = "./modules/firewall/application_rule_collection"
  arc_name   = "AllowGoogleFWARC"
  fw_name    = module.AzureFirewall.fw_name
  rg_name    = module.AzureFirewall.rg_name
  priority   = 100
  action     = "Allow"
  depends_on = [module.AzureFirewall]
}

#* Policy Definition

resource "azurerm_policy_definition" "DenyNetworkWatcherPolicy" {
  name         = "DenyNetworkWatcherPolicy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Network Watcher Policy"

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

resource "azurerm_subscription_policy_assignment" "DenyNetworkWatcherPA" {
  name                 = "DenyNetworkWatcherPA"
  policy_definition_id = azurerm_policy_definition.DenyNetworkWatcherPolicy.id
  subscription_id      = data.azurerm_subscription.current.id
}

#* Local Execution

resource "null_resource" "DeleteNetworkWatcherLE" {
  provisioner "local-exec" {
    command = "az group delete --name NetworkWatcherRG --yes --no-wait"
  }
  depends_on = [
    resource.azurerm_subscription_policy_assignment.DenyNetworkWatcherPA
  ]
}
