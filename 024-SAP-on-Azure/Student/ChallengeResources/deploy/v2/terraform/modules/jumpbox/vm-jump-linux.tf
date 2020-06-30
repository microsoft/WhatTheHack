/*-----------------------------------------------------------------------------8
|                                                                              |
|                              JUMPBOX - LINUX                                 |
|                                                                              |
+--------------------------------------4--------------------------------------*/

/*-----------------------------------------------------------------------------8
TODO:  Fix Naming convention and document in the Naming Convention Doc
+--------------------------------------4--------------------------------------*/

# Creates the public IP addresses for Linux jumpboxes
resource "azurerm_public_ip" "jump-linux" {
  count               = length(local.vm-jump-linux)
  name                = "${local.vm-jump-linux[count.index].name}-public-ip"
  location            = var.resource-group[0].location
  resource_group_name = var.resource-group[0].name
  allocation_method   = "Static"
}

/*-----------------------------------------------------------------------------8
TODO:  Change ip_configuration.name to a static value. ex. ipconfig1
+--------------------------------------4--------------------------------------*/

# Creates the NIC and IP address for Linux jumpboxes
resource "azurerm_network_interface" "jump-linux" {
  count               = length(local.vm-jump-linux)
  name                = "${local.vm-jump-linux[count.index].name}-nic1"
  location            = var.resource-group[0].location
  resource_group_name = var.resource-group[0].name

  ip_configuration {
    name                          = "${local.vm-jump-linux[count.index].name}-nic1-ip"
    subnet_id                     = var.subnet-mgmt[0].id
    private_ip_address            = var.infrastructure.vnets.management.subnet_mgmt.is_existing ? local.vm-jump-linux[count.index].private_ip_address : lookup(local.vm-jump-linux[count.index], "private_ip_address", false) != false ? local.vm-jump-linux[count.index].private_ip_address : cidrhost(var.infrastructure.vnets.management.subnet_mgmt.prefix, (count.index + 4 + length(local.vm-jump-win)))
    private_ip_address_allocation = "static"
    public_ip_address_id          = azurerm_public_ip.jump-linux[count.index].id
  }
}

# Manages the association between NIC and NSG for Linux jumpboxes
resource "azurerm_network_interface_security_group_association" "jump-linux" {
  count                     = length(local.vm-jump-linux)
  network_interface_id      = azurerm_network_interface.jump-linux[count.index].id
  network_security_group_id = var.nsg-mgmt[0].id
}


# Manages Linux Virtual Machine for Linux jumpboxes
resource "azurerm_linux_virtual_machine" "jump-linux" {
  count                           = length(local.vm-jump-linux)
  name                            = local.vm-jump-linux[count.index].name
  location                        = var.resource-group[0].location
  resource_group_name             = var.resource-group[0].name
  network_interface_ids           = [azurerm_network_interface.jump-linux[count.index].id]
  size                            = local.vm-jump-linux[count.index].size
  computer_name                   = local.vm-jump-linux[count.index].name
  admin_username                  = local.vm-jump-linux[count.index].authentication.username
  admin_password                  = lookup(local.vm-jump-linux[count.index].authentication, "password", null)
  disable_password_authentication = local.vm-jump-linux[count.index].authentication.type != "password" ? true : false

  os_disk {
    name                 = "${local.vm-jump-linux[count.index].name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = local.vm-jump-linux[count.index].disk_type
  }

  source_image_reference {
    publisher = local.vm-jump-linux[count.index].os.publisher
    offer     = local.vm-jump-linux[count.index].os.offer
    sku       = local.vm-jump-linux[count.index].os.sku
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.vm-jump-linux[count.index].authentication.username
    public_key = file(var.sshkey.path_to_public_key)
  }

  boot_diagnostics {
    storage_account_uri = var.storage-bootdiag.primary_blob_endpoint
  }

  tags = {
    JumpboxName = "LINUX-JUMPBOX"
  }

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.jump-linux[count.index].ip_address
    user        = local.vm-jump-linux[count.index].authentication.username
    private_key = local.vm-jump-linux[count.index].authentication.type == "key" ? file(var.sshkey.path_to_private_key) : null
    password    = lookup(local.vm-jump-linux[count.index].authentication, "password", null)
    timeout     = var.ssh-timeout
  }

  # Copies ssh keypair over to jumpboxes and sets permission
  provisioner "file" {
    source      = lookup(var.sshkey, "path_to_public_key", null)
    destination = "/home/${local.vm-jump-linux[count.index].authentication.username}/.ssh/id_rsa.pub"
  }

  provisioner "file" {
    source      = lookup(var.sshkey, "path_to_private_key", null)
    destination = "/home/${local.vm-jump-linux[count.index].authentication.username}/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 644 /home/${local.vm-jump-linux[count.index].authentication.username}/.ssh/id_rsa.pub",
      "chmod 600 /home/${local.vm-jump-linux[count.index].authentication.username}/.ssh/id_rsa",
    ]
  }
}
