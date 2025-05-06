# Resources
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfchallenge" {
  name     = var.rgname
  location = var.location
}

resource "azurerm_storage_account" "this" {
  name                     = "${var.saname}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.tfchallenge.name
  location                 = azurerm_resource_group.tfchallenge.location
  account_tier             = "Standard"
  account_replication_type = var.geoRedundancy ? "GRS" : "LRS"
}

resource "azurerm_storage_container" "thiscontainer" {
  name                  = var.containername
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "blob"
}

