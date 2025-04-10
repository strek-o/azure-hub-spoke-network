variable "sub_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "vm_Testing_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_Testing_admin_password" {
  type      = string
  sensitive = true
}

variable "vm_RDPConnection_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_RDPConnection_admin_password" {
  type      = string
  sensitive = true
}

variable "vm_Database_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_Database_admin_password" {
  type      = string
  sensitive = true
}

variable "vm_App_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_App_admin_password" {
  type      = string
  sensitive = true
}
