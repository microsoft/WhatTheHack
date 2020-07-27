# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "<subscription id>"
  client_id       = "<service principal app id>"
  client_secret   = "<service principal password>"
  tenant_id       = "<service principal tenant id>"
}
resource "azurerm_resource_group" "rg" {
        name = "WTHTFRG"
        location = "centralus"
}
