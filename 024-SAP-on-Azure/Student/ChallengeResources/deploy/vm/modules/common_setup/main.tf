# Create a resource group.

resource "null_resource" "configuration-check" {
  provisioner "local-exec" {
    command = "ansible-playbook ../../ansible/configcheck.yml"
  }
}

resource "azurerm_resource_group" "hana-resource-group" {
  depends_on = [null_resource.configuration-check]
  name       = var.az_resource_group
  location   = var.az_region

  tags = {
    environment = "Terraform SAP HANA deployment"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.sap_sid}-vnet"
  location            =  azurerm_resource_group.hana-resource-group.location
  resource_group_name =  azurerm_resource_group.hana-resource-group.name
  address_space       = ["10.0.0.0/21"]
}

resource "azurerm_subnet" "subnet" {
  name                      = "hdb-subnet"
  resource_group_name       = azurerm_resource_group.hana-resource-group.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  address_prefix            = "10.0.0.0/24"
  network_security_group_id = azurerm_network_security_group.sap_nsg[0].id
}
