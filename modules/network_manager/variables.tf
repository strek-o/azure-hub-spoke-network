variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "scope_accesses" {
  type = list(string)
}

variable "subscription_ids" {
  type      = list(string)
  sensitive = true
}
