# Generate random text for a unique storage account name.
resource "random_id" "randomId" {
  keepers = {
    # Generate a new id only when a new resource group is defined.
    resource_group = var.az_resource_group
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "bootdiagstorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = var.az_resource_group
  location                 = var.az_region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Terraform SAP HANA deployment"
  }
}

# All disks that are in the storage_disk_sizes_gb list will be created
resource "azurerm_managed_disk" "disk" {
  count                = length(var.storage_disk_sizes_gb)
  name                 = "${var.machine_name}-disk${count.index}"
  location             = var.az_region
  storage_account_type = "Premium_LRS"
  #storage_account_type = "Ultra_SSD"
  resource_group_name  = var.az_resource_group
  disk_size_gb         = var.storage_disk_sizes_gb[count.index]
  create_option        = "Empty"
}

# All of the disks created above will now be attached to the VM
resource "azurerm_virtual_machine_data_disk_attachment" "disk" {
  count              = length(var.storage_disk_sizes_gb)
  virtual_machine_id = azurerm_virtual_machine.vm.id
  managed_disk_id    = element(azurerm_managed_disk.disk.*.id, count.index)
  lun                = count.index
  caching            = "ReadWrite"
  #write_accelerator_enabled = "true"
}

# Create virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                          = var.machine_name
  location                      = var.az_region
  resource_group_name           = var.az_resource_group
  network_interface_ids         = [var.nic_id]
  availability_set_id           = var.availability_set_id
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = "true"

  storage_os_disk {
    name              = "${var.machine_name}-OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  #additional_capabilities {
  #  ultra_ssd_enabled = "true"
  #}
  storage_image_reference {
    publisher = "suse"
    offer     = "sles-sap-15-sp1"
    sku       = "gen1"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.machine_name
    admin_username = var.vm_user
    admin_password = var.vm_paswd
  }

  os_profile_linux_config {
    disable_password_authentication = false
    #disable_password_authentication = true
  
    ssh_keys {
      path     = "/home/${var.vm_user}/.ssh/authorized_keys"
      key_data = file(var.sshkey_path_public)
    }
  }

  boot_diagnostics {
    enabled = "true"

    storage_uri = azurerm_storage_account.bootdiagstorageaccount.primary_blob_endpoint
  }

  tags = merge(
    {
      "${var.machine_type}" = ""
    },
    var.tags,
  )
}

