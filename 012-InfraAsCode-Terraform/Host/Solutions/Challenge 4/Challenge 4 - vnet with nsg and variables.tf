# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.azurerm["subscription_id"]}"
  client_id       = "${var.azurerm["client_id"]}"
  client_secret   = "${var.azurerm["client_secret"]}"
  tenant_id       = "${var.azurerm["tenant_id"]}"
}
resource "azurerm_resource_group" "rg" {
        name = "${var.resource_group_name}"
        location = "${var.location}"
}
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "${var.virtual_network_name}"
    address_space       = "${var.virtual_network_address_space}"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"

    tags = {
        environment = "${var.tags["environment"]}"
    }
}

resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "${var.subnet["name"]}"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix       = "${var.subnet["address_prefix"]}"
}

resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "${var.nsg}"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    
    security_rule {
        name                       = "${var.nsg_security_rule_ssh["name"]}"
        priority                   = "${var.nsg_security_rule_ssh["priority"]}"
        direction                  = "${var.nsg_security_rule_ssh["direction"]}"
        access                     = "${var.nsg_security_rule_ssh["access"]}"
        protocol                   = "${var.nsg_security_rule_ssh["protocol"]}"
        source_port_range          = "${var.nsg_security_rule_ssh["source_port_range"]}"
        destination_port_range     = "${var.nsg_security_rule_ssh["destination_port_range"]}"
        source_address_prefix      = "${var.nsg_security_rule_ssh["source_address_prefix"]}"
        destination_address_prefix = "${var.nsg_security_rule_ssh["destination_address_prefix"]}"
    }

    tags = {
        environment = "${var.tags["environment"]}"
    }
}