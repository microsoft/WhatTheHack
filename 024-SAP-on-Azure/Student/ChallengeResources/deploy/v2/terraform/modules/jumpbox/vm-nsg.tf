/*-----------------------------------------------------------------------------8
|                                                                              |
|                              JUMPBOX - NSG                                   |
|                                                                              |
+--------------------------------------4--------------------------------------*/

# Creates Windows jumpbox RDP network security rule
resource "azurerm_network_security_rule" "nsr-rdp" {
  count                       = var.infrastructure.vnets.management.subnet_mgmt.nsg.is_existing ? 0 : 1
  name                        = "rdp"
  resource_group_name         = var.nsg-mgmt[0].resource_group_name
  network_security_group_name = var.nsg-mgmt[0].name
  priority                    = 101
  direction                   = "Inbound"
  access                      = "allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 3389
  source_address_prefixes     = var.infrastructure.vnets.management.subnet_mgmt.nsg.allowed_ips
  destination_address_prefix  = var.infrastructure.vnets.management.subnet_mgmt.prefix
}

# Creates Windows jumpbox WinRM network security rule
resource "azurerm_network_security_rule" "nsr-winrm" {
  count                       = var.infrastructure.vnets.management.subnet_mgmt.nsg.is_existing ? 0 : 1
  name                        = "winrm"
  resource_group_name         = var.nsg-mgmt[0].resource_group_name
  network_security_group_name = var.nsg-mgmt[0].name
  priority                    = 102
  direction                   = "Inbound"
  access                      = "allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [5985, 5986]
  source_address_prefixes     = var.infrastructure.vnets.management.subnet_mgmt.nsg.allowed_ips
  destination_address_prefix  = var.infrastructure.vnets.management.subnet_mgmt.prefix
}

# Creates Linux jumpbox and RTI box SSH network security rule
resource "azurerm_network_security_rule" "nsr-ssh" {
  count                       = var.infrastructure.vnets.management.subnet_mgmt.nsg.is_existing ? 0 : 1
  name                        = "ssh"
  resource_group_name         = var.nsg-mgmt[0].resource_group_name
  network_security_group_name = var.nsg-mgmt[0].name
  priority                    = 103
  direction                   = "Inbound"
  access                      = "allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefixes     = var.infrastructure.vnets.management.subnet_mgmt.nsg.allowed_ips
  destination_address_prefix  = var.infrastructure.vnets.management.subnet_mgmt.prefix
}
