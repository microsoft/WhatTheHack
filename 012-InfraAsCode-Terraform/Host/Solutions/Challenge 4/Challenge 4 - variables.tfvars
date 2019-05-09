"azurerm" = {
  subscription_id = "f86c31f3-db18-4503-8fa4-d2b67a6474e2"
  client_id       = "b12c6727-aa20-4a6e-b9fd-1089f1ecd2eb"
  client_secret   = "d1b7882e-53c0-4969-81e9-d85d48ee7075"
  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
}

"location" = "East US"
"resource_group_name" = "WTHTFRG"

"virtual_network_name" = "WTHVNetTF"
"virtual_network_address_space" = ["10.1.0.0/16"]

"subnet" = { 
    name = "default"
    address_prefix = "10.1.0.0/24"
}

"nsg" = "WTHNSG"

"nsg_security_rule_ssh" = {
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

"tags" = {
    environment = "WTH Terraform"
}