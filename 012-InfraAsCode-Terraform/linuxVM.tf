# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "<subscription id>"
  client_id       = "<service principal app_id>"
  client_secret   = "<service principal password>"
  tenant_id       = "<service principal tenant id>"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "lvmRG" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "Terraform Demo"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "lvmVnet" {
  name                = "lvmVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.lvmRG.name}"

  tags {
    environment = "Terraform Demo"
  }
}

# Create subnet
resource "azurerm_subnet" "lvmSubnet" {
  name                 = "lvmSubnet"
  resource_group_name  = "${azurerm_resource_group.lvmRG.name}"
  virtual_network_name = "${azurerm_virtual_network.lvmVnet.name}"
  address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "lvmPublicIp" {
  name                         = "lvmPublicIp1"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.lvmRG.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "pvlvmtf"

  tags {
    environment = "Terraform Demo"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "lvmnsg" {
  name                = "lvmnsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.lvmRG.name}"

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

  security_rule {
    name                       = "Port80"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Terraform Demo"
  }
}

# Create network interface
resource "azurerm_network_interface" "lvmnic" {
  name                      = "lvmnic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.lvmRG.name}"
  network_security_group_id = "${azurerm_network_security_group.lvmnsg.id}"

  ip_configuration {
    name                          = "lvmnicipconfig"
    subnet_id                     = "${azurerm_subnet.lvmSubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.lvmPublicIp.id}"
  }

  tags {
    environment = "Terraform Demo"
  }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.lvmRG.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "lvmstorageAccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.lvmRG.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    environment = "Terraform Demo"
  }
}

//Linux Image created by packer
data "azurerm_resource_group" "image" {
  name = "pvPackerImages"
}

data "azurerm_image" "image" {
  name                = "pvlvmPackerImage"
  resource_group_name = "${data.azurerm_resource_group.image.name}"
}

resource "azurerm_virtual_machine" "myterraformvm" {
  name                  = "myVM"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.lvmRG.name}"
  network_interface_ids = ["${azurerm_network_interface.lvmnic.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  # storage_image_reference {
  #     publisher = "Canonical"
  #     offer     = "UbuntuServer"
  #     sku       = "16.04.0-LTS"
  #     version   = "latest"
  # }

  #Packer created image reference
  storage_image_reference {
    id = "${data.azurerm_image.image.id}"
  }
  os_profile {
    computer_name  = "pvlvmTerraform"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }
  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.lvmstorageAccount.primary_blob_endpoint}"
  }
  tags {
    environment = "Terraform Demo"
  }
}
