# Assumption is you will be using az cli authentication
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-lnc01"
    storage_account_name = "tfstatelnc01"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Variables
variable "rgname" {
  type = string
}
variable "location" {
  type = string
}
variable "saname" {
  type = string
}

# Resources
resource "azurerm_resource_group" "tfchallenge" {
  name     = var.rgname
  location = var.location
}

resource "azurerm_storage_account" "this" {
  name                     = var.saname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Outputs
output "storageid" {
  value = azurerm_storage_account.this.id
}