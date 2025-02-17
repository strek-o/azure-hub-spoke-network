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

variable "vm_HPC_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_HPC_admin_password" {
  type      = string
  sensitive = true
}

variable "vm_Main_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_Main_admin_password" {
  type      = string
  sensitive = true
}

variable "vm_Backup_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_Backup_admin_password" {
  type      = string
  sensitive = true
}

variable "vm_Hosting_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_Hosting_admin_password" {
  type      = string
  sensitive = true
}
