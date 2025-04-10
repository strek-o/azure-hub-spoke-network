variable "nic_name" {
  type = string
}

variable "nic_location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "nic_ip_configuration_name" {
  type = string
}

variable "snet_id" {
  type = string
}

variable "pip_id" {
  type    = string
  default = null
}
