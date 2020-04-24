# Configure the Microsoft Azure Provider
provider "azurerm"  {
  subscription_id = "<subscription id>"
  client_id       = "<service principal app id>"
  client_secret   = "<service principal password>"
  tenant_id       = "<service principal tenant id>"
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

    tags {
        environment = "${var.tags["environment"]}"
    }
}
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "${var.azurerm_public_ip["name"]}"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg.name}"
    allocation_method            = "${var.azurerm_public_ip["allocation_method"]}"

    tags {
        environment = "${var.tags["environment"]}"
    }
}resource "azurerm_network_interface" "myterraformnic" {
    name                = "${var.azurerm_network_interface}"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

    ip_configuration {
        name                          = "${var.azurerm_network_interface_ip_configuration["name"]}"
        subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
        private_ip_address_allocation = "${var.azurerm_network_interface_ip_configuration["private_ip_address_allocation"]}"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
    }

    tags = {
        environment = "${var.tags["environment"]}"
    }
}

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.rg.name}"
    }
    
    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                = "diag${random_id.randomId.hex}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    location            = "${var.location}"
    account_replication_type = "${var.azurerm_storage_account["account_replication_type"]}"
    account_tier = "${var.azurerm_storage_account["account_tier"]}"

    tags = {
        environment = "${var.tags["environment"]}"
    }
}

resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "${var.azurerm_virtual_machine["name"]}"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
    vm_size               = "${var.azurerm_virtual_machine["vm_size"]}"

    storage_os_disk {
        name              = "${var.azurerm_virtual_machine_storage_os_disk["name"]}"
        caching           = "${var.azurerm_virtual_machine_storage_os_disk["caching"]}"
        create_option     = "${var.azurerm_virtual_machine_storage_os_disk["create_option"]}"
        managed_disk_type = "${var.azurerm_virtual_machine_storage_os_disk["managed_disk_type"]}"
    }

    storage_image_reference {
        publisher = "${var.azurerm_virtual_machine_storage_image_reference["publisher"]}"
        offer     = "${var.azurerm_virtual_machine_storage_image_reference["offer"]}"
        sku       = "${var.azurerm_virtual_machine_storage_image_reference["sku"]}"
        version   = "${var.azurerm_virtual_machine_storage_image_reference["version"]}"
    }

    os_profile {
        computer_name  = "${var.os_profile["computer_name"]}"
        admin_username = "${var.os_profile["admin_username"]}"
    }

    os_profile_linux_config {
        disable_password_authentication = "${var.os_profile_linux_config_disable_password_authentication}"
        ssh_keys {
            path     = "${var.os_profile_linux_config_ssh_keys["path"]}"
            key_data = "${var.os_profile_linux_config_ssh_keys["key_data"]}"
        }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags = {
        environment = "WTH Terraform Demo"
    }
}