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

nsg_security_rule_http = {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}

tags = {
    environment = "WTH Terraform"
}
azurerm_network_interface = "WTHUbuntuNIC"

azurerm_public_ip = {
    name = "myPublicIP"
    allocation_method = "Dynamic"
}
azurerm_storage_account = {    
    account_replication_type = "LRS"
    account_tier = "Standard"
}

azurerm_network_interface_ip_configuration =  {
        name                          = "WTHUbuntuNICConfiguration"
        private_ip_address_allocation = "Dynamic"        
}

os_profile = {
        computer_name  = "WTHUbuntuVM01"
        admin_username = "azureuser"
}

azurerm_virtual_machine  =  {
    name                  = "WTHUbuntuVM01"
    vm_size               = "Standard_DS1_v2"
}

azurerm_virtual_machine_storage_os_disk = {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
}

os_profile_linux_config_disable_password_authentication = true

os_profile_linux_config_ssh_keys = {
    path     = "/home/azureuser/.ssh/authorized_keys"
    key_data = "ssh-rsa AAAAB3NzacjVxasxEbZ2otJpJpK6DACuktMDeBtj3QlctK0uiWqaErxwDAYXmqDtp6Gkihg6kJtZxC1y7t2N/dc5/zAt16MfV+RoIhxrmUabNA9pVWGloxi6CE3PgJGqzijClAvFU8VT9Gu0xzY8LoAS0R0oF7/Zhac6cWzxICcPVMlKBaWL3etpGRvrK8xO3nK2qHmB1EwuKw+57owriTslNyblXt2WT/c2kRGKo5HFLufh/P+rDyB/hvd1Xy75IEW/BGTfhT0YbYLntYHF7K5heQjrMW4kW6eWx pete@cc-9b61a39f-66fcd9ccfb-sb8br"
}

