variable "name" {
  type = string
}

variable "admin_rule_collection_id" {
  type = string
}

variable "action" {
  type = string
}

variable "direction" {
  type = string
}

variable "priority" {
  type = number
}

variable "protocol" {
  type = string
}

variable "source_port_ranges" {
  type = list(string)
}

variable "destination_port_ranges" {
  type = list(string)
}

variable "source_address_prefix" {
  type = string
}

variable "destination_address_prefix" {
  type = string
}
