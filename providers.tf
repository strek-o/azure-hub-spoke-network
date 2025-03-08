terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.22.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id
}
