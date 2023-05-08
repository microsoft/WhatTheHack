
# Resources
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfchallenge" {
  name     = var.rgname
  location = var.location
}
##########################################################
module "myvm" {
  source = "./modules/vm"

  rg             = azurerm_resource_group.tfchallenge.name
  location       = azurerm_resource_group.tfchallenge.location
  vmname         = var.vmname
  admin_username = "azureuser"
  ssh_publickey  = tls_private_key.example_ssh.public_key_openssh
  subnet_id      = module.mynetwork.vmsubnetid
}

module "mynetwork" {
  source = "./modules/network"

  rg                 = azurerm_resource_group.tfchallenge.name
  location           = azurerm_resource_group.tfchallenge.location
  vnet_name          = "myvnet"
  address_space      = ["10.0.0.0/16"]
  subnet_name        = "myvmsubnet"
  subnet_addr_prefix = ["10.0.1.0/24"]

}

#####################################################



# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "ssh_private_key" {
  content  = tls_private_key.example_ssh.private_key_pem
  filename = "${path.module}/mysshkey"
}

# Put SSH private key in keyvault
resource "azurerm_key_vault_secret" "ssh_private_key" {
  key_vault_id = azurerm_key_vault.vault.id
  name         = "sshprivatekey"
  value        = tls_private_key.example_ssh.private_key_pem

}
