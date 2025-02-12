variable "vnet_hub_name" {
  type      = string
  default   = "vnet-hub"
  sensitive = false

}

variable "snet_hub_1_name" {
  type      = string
  default   = "ServicesSubnet"
  sensitive = false

}

variable "vnet_dev_001_name" {
  type      = string
  default   = "vnet-dev-001"
  sensitive = false

}

variable "snet_dev_001_1_name" {
  type      = string
  default   = "Dev_001_Subnet_1"
  sensitive = false

}

variable "vnet_prod_001_name" {
  type      = string
  default   = "vnet-prod-001"
  sensitive = false

}

variable "snet_prod_001_1_name" {
  type      = string
  default   = "Prod_001_Subnet_1"
  sensitive = false

}

variable "vnet_prod_002_name" {
  type      = string
  default   = "vnet-prod-002"
  sensitive = false

}

variable "snet_prod_002_1_name" {
  type      = string
  default   = "Prod_002_Subnet_1"
  sensitive = false

}

variable "snet_prod_002_2_name" {
  type      = string
  default   = "Prod_002_Subnet_2"
  sensitive = false

}
