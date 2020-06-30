/*-----------------------------------------------------------------------------8
|                                                                              |
|                                    RTI                                       |
|                                                                              |
+--------------------------------------4--------------------------------------*/

/*-----------------------------------------------------------------------------8
TODO 20200414-MKD: Add Environment variables

  These environment variable should exist in the context that executes the 
  ansible-playbook command

export           ANSIBLE_HOST_KEY_CHECKING=False
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=Yes
+--------------------------------------4--------------------------------------*/

/*-----------------------------------------------------------------------------8
TODO:  Fix Naming convention and document in the Naming Convention Doc
+--------------------------------------4--------------------------------------*/

# Creates the public IP addresses for RTI
resource "azurerm_public_ip" "rti" {
  count               = length(local.rti)
  name                = "${local.rti[count.index].name}-public-ip"
  location            = var.resource-group[0].location
  resource_group_name = var.resource-group[0].name
  allocation_method   = "Static"
}

/*-----------------------------------------------------------------------------8
TODO:  Change ip_configuration.name to a static value. ex. ipconfig1
+--------------------------------------4--------------------------------------*/

# Creates the NIC and IP address for RTI
resource "azurerm_network_interface" "rti" {
  count               = length(local.rti)
  name                = "${local.rti[count.index].name}-nic1"
  location            = var.resource-group[0].location
  resource_group_name = var.resource-group[0].name

  ip_configuration {
    name                          = "${local.rti[count.index].name}-nic1-ip"
    subnet_id                     = var.subnet-mgmt[0].id
    private_ip_address            = var.infrastructure.vnets.management.subnet_mgmt.is_existing ? local.rti[count.index].private_ip_address : lookup(local.rti[count.index], "private_ip_address", false) != false ? local.rti[count.index].private_ip_address : cidrhost(var.infrastructure.vnets.management.subnet_mgmt.prefix, (count.index + 4 + length(local.vm-jump-win) + length(local.vm-jump-linux)))
    private_ip_address_allocation = "static"
    public_ip_address_id          = azurerm_public_ip.rti[count.index].id
  }
}

# Manages the association between NIC and NSG for RTI
resource "azurerm_network_interface_security_group_association" "rti" {
  count                     = length(local.rti)
  network_interface_id      = azurerm_network_interface.rti[count.index].id
  network_security_group_id = var.nsg-mgmt[0].id
}

# Manages Linux Virtual Machine for RTI
resource "azurerm_linux_virtual_machine" "rti" {
  count                           = length(local.rti)
  name                            = local.rti[count.index].name
  location                        = var.resource-group[0].location
  resource_group_name             = var.resource-group[0].name
  network_interface_ids           = [azurerm_network_interface.rti[count.index].id]
  size                            = local.rti[count.index].size
  computer_name                   = local.rti[count.index].name
  admin_username                  = local.rti[count.index].authentication.username
  admin_password                  = lookup(local.rti[count.index].authentication, "password", null)
  disable_password_authentication = local.rti[count.index].authentication.type != "password" ? true : false

  os_disk {
    name                 = "${local.rti[count.index].name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = local.rti[count.index].disk_type
  }

  source_image_reference {
    publisher = local.rti[count.index].os.publisher
    offer     = local.rti[count.index].os.offer
    sku       = local.rti[count.index].os.sku
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.rti[count.index].authentication.username
    public_key = file(var.sshkey.path_to_public_key)
  }

  boot_diagnostics {
    storage_account_uri = var.storage-bootdiag.primary_blob_endpoint
  }

  tags = {
    JumpboxName = "RTI"
  }

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.rti[count.index].ip_address
    user        = local.rti[count.index].authentication.username
    private_key = local.rti[count.index].authentication.type == "key" ? file(var.sshkey.path_to_private_key) : null
    password    = lookup(local.rti[count.index].authentication, "password", null)
    timeout     = var.ssh-timeout
  }

  # Copies ssh keypair over to jumpboxes and sets permission
  provisioner "file" {
    source      = lookup(var.sshkey, "path_to_public_key", null)
    destination = "/home/${local.rti[count.index].authentication.username}/.ssh/id_rsa.pub"
  }

  provisioner "file" {
    source      = lookup(var.sshkey, "path_to_private_key", null)
    destination = "/home/${local.rti[count.index].authentication.username}/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 644 /home/${local.rti[count.index].authentication.username}/.ssh/id_rsa.pub",
      "chmod 600 /home/${local.rti[count.index].authentication.username}/.ssh/id_rsa",
    ]
  }
}

/*-----------------------------------------------------------------------------8
  Prepare RTI:
    1. Copy folder ansible_config_files over to RTI
    2. Install Git/Ansible and clone GitHub repo on RTI
+--------------------------------------4--------------------------------------*/
resource "null_resource" "prepare-rti" {
  depends_on = [azurerm_linux_virtual_machine.rti]
  connection {
    type        = "ssh"
    host        = azurerm_public_ip.rti[0].ip_address
    user        = local.rti[0].authentication.username
    private_key = local.rti[0].authentication.type == "key" ? file(var.sshkey.path_to_private_key) : null
    password    = lookup(local.rti[0].authentication, "password", null)
    timeout     = var.ssh-timeout
  }

  # Copies output.json and inventory file for ansbile on RTI.
  provisioner "file" {
    source      = "${path.root}/../ansible_config_files/"
    destination = "/home/${local.rti[0].authentication.username}"
  }

  # Copies Clustering Service Principal for ansbile on RTI.
  provisioner "file" {
    # Note: We provide a default empty clustering auth script content so this provisioner succeeds.
    # Later in the execution, the script is sourced, but will have no impact if it has been defaulted
    content     = fileexists("${path.cwd}/set-clustering-auth-${local.hana-sid}.sh") ? file("${path.cwd}/set-clustering-auth-${local.hana-sid}.sh") : "# default empty clustering auth script"
    destination = "/home/${local.rti[0].authentication.username}/export-clustering-sp-details.sh"
  }

  # Installs Git, Ansible and clones repository on RTI
  provisioner "remote-exec" {
    inline = [
      # Installs Git
      "sudo apt update",
      "sudo apt-get install git=1:2.7.4-0ubuntu1.6",
      # Install pip3
      "sudo apt -y install python3-pip",
      # Installs Ansible
      "sudo -H pip3 install \"ansible>=2.8,<2.9\"",
      # Install pywinrm
      "sudo -H pip3 install \"pywinrm>=0.3.0\"",
      # Clones project repository
      "git clone https://github.com/Azure/sap-hana.git"
    ]
  }
}
