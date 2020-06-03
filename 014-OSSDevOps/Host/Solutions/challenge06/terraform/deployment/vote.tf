provider "azurerm" {
    subscription_id = "{subscription_id}"
    client_id       = "{client_id}"
    client_secret   = "{client_secret}"
    tenant_id       = "{tenant_id}"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

resource "azurerm_container_group" "example" {
  name                = "example-continst"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "voting"
    image  = "alihhussain/votingapp:v1"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}
