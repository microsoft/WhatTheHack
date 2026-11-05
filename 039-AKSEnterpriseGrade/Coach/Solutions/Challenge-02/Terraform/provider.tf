terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.69"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.9"
    }
  }

  required_version = ">= 1.11.0, < 2.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}
