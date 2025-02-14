variable "sub_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "vm_Main_001_admin_username" {
  type      = string
  sensitive = true
}

variable "vm_Main_001_admin_password" {
  type      = string
  sensitive = true
}
