terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.33.0"
    }
  }
  cloud {
    organization = "insight"
    workspaces {
      name = "Andrew-Sutliff-demo"
    }
  }
  }

provider "azurerm" {
  features {}
}