variable "name" {
  type = string
}

variable "azure_firewall_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "priority" {
  type = number
}

variable "action" {
  type = string
}

variable "rule_name" {
  type = string
}

variable "source_addresses" {
  type = list(string)
}

variable "target_fqdns" {
  type = list(string)
}
