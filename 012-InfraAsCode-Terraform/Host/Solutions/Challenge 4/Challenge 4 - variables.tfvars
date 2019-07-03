azurerm = {
  subscription_id = "<subscription id>"
  client_id       = "<service principal app id>"
  client_secret   = "<service principal password>"
  tenant_id       = "<service principal tenant id>"
}

location = "East US"
resource_group_name = "WTHTFRG"

virtual_network_name = "WTHVNetTF"
virtual_network_address_space = ["10.1.0.0/16"]

subnet = { 
    name = "default"
    address_prefix = "10.1.0.0/24"
}

nsg = "WTHNSG"

nsg_security_rule_ssh = {
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

tags = {
    environment = "WTH Terraform"
}
