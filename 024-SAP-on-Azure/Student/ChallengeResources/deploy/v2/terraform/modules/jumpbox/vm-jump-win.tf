/*-----------------------------------------------------------------------------8
|                                                                              |
|                              JUMPBOX - WINDOWS                               |
|                                                                              |
+--------------------------------------4--------------------------------------*/

/*-----------------------------------------------------------------------------8
TODO:  Fix Naming convention and document in the Naming Convention Doc
+--------------------------------------4--------------------------------------*/

# Creates the public IP addresses for Windows jumpboxes
resource "azurerm_public_ip" "jump-win" {
  count               = length(local.vm-jump-win)
  name                = "${local.vm-jump-win[count.index].name}-public-ip"
  location            = var.resource-group[0].location
  resource_group_name = var.resource-group[0].name
  allocation_method   = "Static"
}

/*-----------------------------------------------------------------------------8
TODO:  Change ip_configuration.name to a static value. ex. ipconfig1
+--------------------------------------4--------------------------------------*/

# Creates the NIC and IP address for Windows jumpboxes
resource "azurerm_network_interface" "jump-win" {
  count               = length(local.vm-jump-win)
  name                = "${local.vm-jump-win[count.index].name}-nic1"
  location            = var.resource-group[0].location
  resource_group_name = var.resource-group[0].name

  ip_configuration {
    name                          = "${local.vm-jump-win[count.index].name}-nic1-ip"
    subnet_id                     = var.subnet-mgmt[0].id
    private_ip_address            = var.infrastructure.vnets.management.subnet_mgmt.is_existing ? local.vm-jump-win[count.index].private_ip_address : lookup(local.vm-jump-win[count.index], "private_ip_address", false) != false ? local.vm-jump-win[count.index].private_ip_address : cidrhost(var.infrastructure.vnets.management.subnet_mgmt.prefix, (count.index + 4))
    private_ip_address_allocation = "static"
    public_ip_address_id          = azurerm_public_ip.jump-win[count.index].id
  }
}

# Manages the association between NIC and NSG for Windows jumpboxes
resource "azurerm_network_interface_security_group_association" "jump-win" {
  count                     = length(local.vm-jump-win)
  network_interface_id      = azurerm_network_interface.jump-win[count.index].id
  network_security_group_id = var.nsg-mgmt[0].id
}

# Manages Windows Virtual Machine for Windows jumpboxes
resource "azurerm_windows_virtual_machine" "jump-win" {
  count                 = length(local.vm-jump-win)
  name                  = local.vm-jump-win[count.index].name
  location              = var.resource-group[0].location
  resource_group_name   = var.resource-group[0].name
  network_interface_ids = [azurerm_network_interface.jump-win[count.index].id]
  size                  = local.vm-jump-win[count.index].size
  computer_name         = local.vm-jump-win[count.index].name
  admin_username        = local.vm-jump-win[count.index].authentication.username
  admin_password        = local.vm-jump-win[count.index].authentication.password
  custom_data           = base64encode("Param($ComputerName = \"${local.vm-jump-win[count.index].name}\") ${file("${path.module}/winrm_files/winrm.ps1")}")
  provision_vm_agent    = true

  os_disk {
    name                 = "${local.vm-jump-win[count.index].name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = local.vm-jump-win[count.index].disk_type
  }

  source_image_reference {
    publisher = local.vm-jump-win[count.index].os.publisher
    offer     = local.vm-jump-win[count.index].os.offer
    sku       = local.vm-jump-win[count.index].os.sku
    version   = "latest"
  }

  secret {
    certificate {
      store = "My"
      url   = azurerm_key_vault_certificate.key-vault-cert[count.index].secret_id
    }
    key_vault_id = azurerm_key_vault.key-vault.id
  }

  winrm_listener {
    protocol        = "Https"
    certificate_url = azurerm_key_vault_certificate.key-vault-cert[count.index].secret_id
  }


  # Auto-Login's required to configure WinRM
  additional_unattend_content {
    setting = "AutoLogon"
    content = "<AutoLogon><Password><Value>${local.vm-jump-win[count.index].authentication.password}</Value></Password><Enabled>true</Enabled><LogonCount>2</LogonCount><Username>${local.vm-jump-win[count.index].authentication.username}</Username></AutoLogon>"
  }

  # Unattended config is to enable basic auth in WinRM, required for the provisioner stage
  additional_unattend_content {
    setting = "FirstLogonCommands"
    content = file("${path.module}/winrm_files/FirstLogonCommands.xml")
  }

  boot_diagnostics {
    storage_account_uri = var.storage-bootdiag.primary_blob_endpoint
  }

  tags = {
    JumpboxName = "WINDOWS-JUMPBOX"
  }
}
