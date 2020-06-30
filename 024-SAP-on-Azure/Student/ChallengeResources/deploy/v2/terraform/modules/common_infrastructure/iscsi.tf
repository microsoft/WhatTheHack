/*-----------------------------------------------------------------------------8
|                                                                              |
|                                    iSCSI                                     |
|                                                                              |
+--------------------------------------4--------------------------------------*/

/*-----------------------------------------------------------------------------8
TODO:  Fix Naming convention and document in the Naming Convention Doc
+--------------------------------------4--------------------------------------*/

# Creates the NIC and IP address for iSCSI device
resource "azurerm_network_interface" "iscsi" {
  count               = local.iscsi.iscsi_count
  name                = "iscsi-${format("%02d", count.index)}-nic"
  location            = var.infrastructure.region
  resource_group_name = var.infrastructure.resource_group.is_existing ? data.azurerm_resource_group.resource-group[0].name : azurerm_resource_group.resource-group[0].name

  ip_configuration {
    name                          = "ipconfig-iscsi"
    subnet_id                     = var.infrastructure.vnets.sap.subnet_db.is_existing ? data.azurerm_subnet.subnet-sap-db[0].id : azurerm_subnet.subnet-sap-db[0].id
    private_ip_address            = var.infrastructure.vnets.sap.subnet_db.is_existing ? local.iscsi.iscsi_nic_ips[count.index] : lookup(local.iscsi, "iscsi_nic_ips", false) != false ? local.iscsi.iscsi_nic_ips[count.index] : cidrhost(var.infrastructure.vnets.sap.subnet_db.prefix, tonumber(count.index) + 4 + length(local.dbnodes) + length(local.hana-databases))
    private_ip_address_allocation = "static"
  }
}

# Manages Linux Virtual Machine for iSCSI
resource "azurerm_linux_virtual_machine" "iscsi" {
  count                           = local.iscsi.iscsi_count
  name                            = "iscsi-${format("%02d", count.index)}"
  location                        = var.infrastructure.region
  resource_group_name             = var.infrastructure.resource_group.is_existing ? data.azurerm_resource_group.resource-group[0].name : azurerm_resource_group.resource-group[0].name
  network_interface_ids           = [azurerm_network_interface.iscsi[count.index].id]
  size                            = local.iscsi.size
  computer_name                   = "iscsi-${format("%02d", count.index)}"
  admin_username                  = local.iscsi.authentication.username
  admin_password                  = lookup(local.iscsi.authentication, "password", null)
  disable_password_authentication = local.iscsi.authentication.type != "password" ? true : false

  os_disk {
    name                 = "iscsi-${format("%02d", count.index)}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = local.iscsi.os.publisher
    offer     = local.iscsi.os.offer
    sku       = local.iscsi.os.sku
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.iscsi.authentication.username
    public_key = file(var.sshkey.path_to_public_key)
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage-bootdiag.primary_blob_endpoint
  }

  tags = {
    iscsiName = "iSCSI-${format("%02d", count.index)}"
  }
}
