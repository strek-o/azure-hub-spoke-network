#* Resource Groups

module "HubRG" {
  source   = "./modules/resource_group"
  name     = "HubRG"
  location = "Poland Central"
  tags = {
    project = "azure-hub-spoke-network"
  }
}

module "VirtualNetworksRG" {
  source   = "./modules/resource_group"
  name     = "VirtualNetworksRG"
  location = "Poland Central"
  tags = {
    project = "azure-hub-spoke-network"
  }
}

module "PublicIPsRG" {
  source   = "./modules/resource_group"
  name     = "PublicIPsRG"
  location = "Poland Central"
  tags = {
    project = "azure-hub-spoke-network"
  }
}

module "NetworkInterfacesRG" {
  source   = "./modules/resource_group"
  name     = "NetworkInterfacesRG"
  location = "Poland Central"
  tags = {
    project = "azure-hub-spoke-network"
  }
}

module "VirtualMachinesRG" {
  source   = "./modules/resource_group"
  name     = "VirtualMachinesRG"
  location = "Poland Central"
  tags = {
    project = "azure-hub-spoke-network"
  }
}

module "RouteTablesRG" {
  source   = "./modules/resource_group"
  name     = "RouteTablesRG"
  location = "Poland Central"
  tags = {
    project = "azure-hub-spoke-network"
  }
}

#* Virtual Networks

module "HubVNET" {
  source              = "./modules/virtual_network"
  name                = "HubVNET"
  location            = module.VirtualNetworksRG.location
  resource_group_name = module.VirtualNetworksRG.name
  address_space       = ["10.0.0.0/16"]
}

module "DevelopmentVNET" {
  source              = "./modules/virtual_network"
  name                = "DevelopmentVNET"
  location            = module.VirtualNetworksRG.location
  resource_group_name = module.VirtualNetworksRG.name
  address_space       = ["10.10.0.0/16"]
}

module "RDPConnectionVNET" {
  source              = "./modules/virtual_network"
  name                = "RDPConnectionVNET"
  location            = module.VirtualNetworksRG.location
  resource_group_name = module.VirtualNetworksRG.name
  address_space       = ["10.11.0.0/16"]
}

module "NonProductionVNET" {
  source              = "./modules/virtual_network"
  name                = "NonProductionVNET"
  location            = module.VirtualNetworksRG.location
  resource_group_name = module.VirtualNetworksRG.name
  address_space       = ["10.20.0.0/16"]
}

module "ProductionVNET" {
  source              = "./modules/virtual_network"
  name                = "ProductionVNET"
  location            = module.VirtualNetworksRG.location
  resource_group_name = module.VirtualNetworksRG.name
  address_space       = ["10.30.0.0/16"]
}

#* Subnets

module "AzureFirewallSubnet" {
  source               = "./modules/subnet"
  name                 = "AzureFirewallSubnet"
  resource_group_name  = module.VirtualNetworksRG.name
  virtual_network_name = module.HubVNET.name
  address_prefixes     = ["10.0.0.0/24"]
}

module "GeneralSubnet" {
  source               = "./modules/subnet"
  name                 = "GeneralSubnet"
  resource_group_name  = module.VirtualNetworksRG.name
  virtual_network_name = module.DevelopmentVNET.name
  address_prefixes     = ["10.10.0.0/24"]
}

module "CheckupSubnet" {
  source               = "./modules/subnet"
  name                 = "CheckupSubnet"
  resource_group_name  = module.VirtualNetworksRG.name
  virtual_network_name = module.RDPConnectionVNET.name
  address_prefixes     = ["10.11.0.0/24"]
}

module "AnalyticsSubnet" {
  source               = "./modules/subnet"
  name                 = "AnalyticsSubnet"
  resource_group_name  = module.VirtualNetworksRG.name
  virtual_network_name = module.NonProductionVNET.name
  address_prefixes     = ["10.20.0.0/24"]
}

module "WorkloadSubnet" {
  source               = "./modules/subnet"
  name                 = "WorkloadSubnet"
  resource_group_name  = module.VirtualNetworksRG.name
  virtual_network_name = module.ProductionVNET.name
  address_prefixes     = ["10.30.0.0/24"]
}

#* Peerings

module "DevelopmentVNETtoRDPConnectionVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "DevelopmentVNETtoRDPConnectionVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.name
  virtual_network_name      = module.DevelopmentVNET.name
  remote_virtual_network_id = module.RDPConnectionVNET.id
}

module "RDPConnectionVNETtoDevelopmentVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "RDPConnectionVNETtoDevelopmentVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.name
  virtual_network_name      = module.RDPConnectionVNET.name
  remote_virtual_network_id = module.DevelopmentVNET.id
}

module "HubVNETtoDevelopmentVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "HubVNETtoDevelopmentVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.name
  virtual_network_name      = module.HubVNET.name
  remote_virtual_network_id = module.DevelopmentVNET.id
}

module "DevelopmentVNETtoHubVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "DevelopmentVNETtoHubVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.name
  virtual_network_name      = module.DevelopmentVNET.name
  remote_virtual_network_id = module.HubVNET.id
}

module "HubVNETtoNonProductionVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "HubVNETtoNonProductionVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.name
  virtual_network_name      = module.HubVNET.name
  remote_virtual_network_id = module.NonProductionVNET.id
}

module "NonProductionVNETtoHubVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "NonProductionVNETtoHubVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.name
  virtual_network_name      = module.NonProductionVNET.name
  remote_virtual_network_id = module.HubVNET.id
}

module "HubVNETtoProductionVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "HubVNETtoProductionVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.name
  virtual_network_name      = module.HubVNET.name
  remote_virtual_network_id = module.ProductionVNET.id
}

module "ProductionVNETtoHubVNETPeering" {
  source                    = "./modules/virtual_network/peering"
  name                      = "ProductionVNETtoHubVNETPeering"
  resource_group_name       = module.VirtualNetworksRG.name
  virtual_network_name      = module.ProductionVNET.name
  remote_virtual_network_id = module.HubVNET.id
}

#* Route Table

module "DevelopmentRT" {
  source              = "./modules/route_table"
  name                = "DevelopmentRT"
  location            = module.RouteTablesRG.location
  resource_group_name = module.RouteTablesRG.name
}

#* Route

module "AzureFirewallRoute" {
  source                 = "./modules/route"
  name                   = "AzureFirewallRoute"
  resource_group_name    = module.RouteTablesRG.name
  route_table_name       = module.DevelopmentRT.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.AzureFirewall.private_ip_address
  depends_on             = [module.AzureFirewall]
}

#* Route Table Association

module "DevelopmentRTAssociation" {
  source         = "./modules/subnet_route_table_association"
  subnet_id      = module.GeneralSubnet.id
  route_table_id = module.DevelopmentRT.id
}

#* Network Manager

data "azurerm_subscription" "current" {
}

module "MainNM" {
  source              = "./modules/network_manager"
  name                = "MainNM"
  location            = module.HubRG.location
  resource_group_name = module.HubRG.name
  scope_accesses      = ["SecurityAdmin"]
  subscription_ids    = [data.azurerm_subscription.current.id]
}

#* Network Groups

module "HubNETG" {
  source             = "./modules/network_manager/network_group"
  name               = "HubNETG"
  network_manager_id = module.MainNM.id
}

module "DevelopmentNETG" {
  source             = "./modules/network_manager/network_group"
  name               = "DevelopmentNETG"
  network_manager_id = module.MainNM.id
}

module "RDPConnectionNETG" {
  source             = "./modules/network_manager/network_group"
  name               = "RDPConnectionNETG"
  network_manager_id = module.MainNM.id
}

module "NonProductionNETG" {
  source             = "./modules/network_manager/network_group"
  name               = "NonProductionNETG"
  network_manager_id = module.MainNM.id
}

module "ProductionNETG" {
  source             = "./modules/network_manager/network_group"
  name               = "ProductionNETG"
  network_manager_id = module.MainNM.id
}

#* Static Members

module "HubSM" {
  source                    = "./modules/network_manager/static_member"
  name                      = "HubSM"
  network_group_id          = module.HubNETG.id
  target_virtual_network_id = module.HubVNET.id
}

module "DevelopmentSM" {
  source                    = "./modules/network_manager/static_member"
  name                      = "DevelopmentSM"
  network_group_id          = module.DevelopmentNETG.id
  target_virtual_network_id = module.DevelopmentVNET.id
}

module "RDPConnectionSM" {
  source                    = "./modules/network_manager/static_member"
  name                      = "RDPConnectionSM"
  network_group_id          = module.RDPConnectionNETG.id
  target_virtual_network_id = module.RDPConnectionVNET.id
}

module "NonProductionSM" {
  source                    = "./modules/network_manager/static_member"
  name                      = "NonProductionSM"
  network_group_id          = module.NonProductionNETG.id
  target_virtual_network_id = module.NonProductionVNET.id
}

module "ProductionSM" {
  source                    = "./modules/network_manager/static_member"
  name                      = "ProductionSM"
  network_group_id          = module.ProductionNETG.id
  target_virtual_network_id = module.ProductionVNET.id
}

#* Public IPs

module "AzureFirewallPIP" {
  source              = "./modules/public_ip"
  name                = "AzureFirewallPIP"
  resource_group_name = module.PublicIPsRG.name
  location            = module.PublicIPsRG.location
}

module "RDPConnectionPIP" {
  source              = "./modules/public_ip"
  name                = "RDPConnectionPIP"
  resource_group_name = module.PublicIPsRG.name
  location            = module.PublicIPsRG.location
}

#* Network Interfaces

module "TestingNIC" {
  source                = "./modules/network_interface"
  name                  = "TestingNIC"
  location              = module.NetworkInterfacesRG.location
  resource_group_name   = module.NetworkInterfacesRG.name
  ip_configuration_name = "Default"
  subnet_id             = module.GeneralSubnet.id
}

module "RDPConnectionNIC" {
  source                = "./modules/network_interface"
  name                  = "RDPConnectionNIC"
  location              = module.NetworkInterfacesRG.location
  resource_group_name   = module.NetworkInterfacesRG.name
  ip_configuration_name = "Default"
  subnet_id             = module.CheckupSubnet.id
  public_ip_address_id  = module.RDPConnectionPIP.id
}

module "DatabaseNIC" {
  source                = "./modules/network_interface"
  name                  = "DatabaseNIC"
  location              = module.NetworkInterfacesRG.location
  resource_group_name   = module.NetworkInterfacesRG.name
  ip_configuration_name = "Default"
  subnet_id             = module.AnalyticsSubnet.id
}

module "AppNIC" {
  source                = "./modules/network_interface"
  name                  = "AppNIC"
  location              = module.NetworkInterfacesRG.location
  resource_group_name   = module.NetworkInterfacesRG.name
  ip_configuration_name = "Default"
  subnet_id             = module.WorkloadSubnet.id
}

#* Virtual Machines

module "TestingVM" {
  source                = "./modules/windows_virtual_machine"
  name                  = "TestingVM"
  resource_group_name   = module.VirtualMachinesRG.name
  location              = module.VirtualMachinesRG.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [module.TestingNIC.id]
}

module "RDPConnectionVM" {
  source                = "./modules/windows_virtual_machine"
  name                  = "RDPConnectionVM"
  resource_group_name   = module.VirtualMachinesRG.name
  location              = module.VirtualMachinesRG.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [module.RDPConnectionNIC.id]
}

module "DatabaseVM" {
  source                = "./modules/windows_virtual_machine"
  name                  = "DatabaseVM"
  resource_group_name   = module.VirtualMachinesRG.name
  location              = module.VirtualMachinesRG.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [module.DatabaseNIC.id]
}

module "AppVM" {
  source                = "./modules/windows_virtual_machine"
  name                  = "AppVM"
  resource_group_name   = module.VirtualMachinesRG.name
  location              = module.VirtualMachinesRG.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [module.AppNIC.id]
}

#* Security Admin Configuration

module "BasicSAC" {
  source             = "./modules/network_manager/security_admin_configuration"
  name               = "BasicSAC"
  network_manager_id = module.MainNM.id
}

#* [Network Manager] Admin Rule Collections

module "DefaultNMARC" {
  source                          = "./modules/network_manager/admin_rule_collection"
  name                            = "DefaultNMARC"
  security_admin_configuration_id = module.BasicSAC.id
  network_group_ids               = [module.DevelopmentNETG.id, module.NonProductionNETG.id, module.ProductionNETG.id]
}

module "RDPConnectionNMARC" {
  source                          = "./modules/network_manager/admin_rule_collection"
  name                            = "RDPConnectionNMARC"
  security_admin_configuration_id = module.BasicSAC.id
  network_group_ids               = [module.DevelopmentNETG.id, module.RDPConnectionNETG.id]
}

#* Admin Rules

module "DenyInboundAllRule" {
  source                     = "./modules/network_manager/admin_rule"
  name                       = "DenyInboundAllRule"
  admin_rule_collection_id   = module.DefaultNMARC.id
  action                     = "Deny"
  direction                  = "Inbound"
  priority                   = 900
  protocol                   = "Any"
  source_port_ranges         = ["0-65535"]
  destination_port_ranges    = ["0-65535"]
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

module "AllowInboundRDPRule" {
  source                     = "./modules/network_manager/admin_rule"
  name                       = "AllowInboundRDPRule"
  admin_rule_collection_id   = module.RDPConnectionNMARC.id
  action                     = "Allow"
  direction                  = "Inbound"
  priority                   = 100
  protocol                   = "Tcp"
  source_port_ranges         = ["0-65535"]
  destination_port_ranges    = ["3389"]
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

#* Deployment

module "NetworkManagerDP" {
  source             = "./modules/network_manager/deployment"
  network_manager_id = module.MainNM.id
  location           = module.HubRG.location
  scope_access       = module.BasicSAC.id
  configuration_ids = [
    module.BasicSAC.id
  ]
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
  source                = "./modules/firewall"
  name                  = "AzureFirewall"
  location              = module.VirtualNetworksRG.location
  resource_group_name   = module.VirtualNetworksRG.name
  ip_configuration_name = "Default"
  subnet_id             = module.AzureFirewallSubnet.id
  public_ip_address_id  = module.AzureFirewallPIP.id
}

#* [Firewall] Application Rule Collection

module "AllowGoogleFWARC" {
  source              = "./modules/firewall/application_rule_collection"
  name                = "AllowGoogleFWARC"
  azure_firewall_name = module.AzureFirewall.name
  resource_group_name = module.AzureFirewall.resource_group_name
  priority            = 100
  action              = "Allow"
  rule_name           = "AllowGoogleRule"
  source_addresses    = ["*"]
  target_fqdns        = ["*.google.com"]
  depends_on          = [module.AzureFirewall]
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
