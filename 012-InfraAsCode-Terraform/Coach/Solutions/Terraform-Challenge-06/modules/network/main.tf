# Resources
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}


# Create virtual network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.rg
}

# Create subnet
resource "azurerm_subnet" "vmsubnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_addr_prefix
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vmnsg${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.rg

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet2nsg" {
  subnet_id                 = azurerm_subnet.vmsubnet.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

