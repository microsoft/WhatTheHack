# Resources
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Create public IP
resource "azurerm_public_ip" "vmpip" {
  name                = "vmPublicIP${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.rg
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "vm_nic" {
  name                = "vmNIC${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "vm_nic_configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vmpip.id
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = var.vmname
  location              = var.location
  resource_group_name   = var.rg
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk${random_string.suffix.result}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = var.vmname
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_publickey
  }

  boot_diagnostics {
    storage_account_uri = "" # null value means use managed storage account
  }
}

