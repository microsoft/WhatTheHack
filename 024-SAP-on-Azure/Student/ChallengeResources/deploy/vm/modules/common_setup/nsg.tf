resource "azurerm_network_security_group" "sap_nsg" {
  count               = var.use_existing_nsg ? 0 : 1
  name                = local.new_nsg_name
  resource_group_name = azurerm_resource_group.hana-resource-group.name
  location            = azurerm_resource_group.hana-resource-group.location

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefixes    = var.allow_ips
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "open-hana-db-ports"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3${var.sap_instancenum}00-3${var.sap_instancenum}99"
    source_address_prefixes    = var.allow_ips
    destination_address_prefix = "*"
  }
}

# Creates Windows jumpbox RDP network security rule
resource "azurerm_network_security_rule" "nsr-rdp" {
  count                       = var.windows_bastion ? 1 : 0
  name                        = "rdp"
  resource_group_name         = azurerm_resource_group.hana-resource-group.name
  network_security_group_name = azurerm_network_security_group.sap_nsg[0].name
  priority                    = 103
  direction                   = "Inbound"
  access                      = "allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 3389
  source_address_prefixes     = var.allow_ips
  destination_address_prefix  = "*"
}

# Creates Windows jumpbox WinRM network security rule
resource "azurerm_network_security_rule" "nsr-winrm" {
  count                       = var.windows_bastion ? 1 : 0
  name                        = "winrm"
  resource_group_name         = azurerm_resource_group.hana-resource-group.name
  network_security_group_name = azurerm_network_security_group.sap_nsg[0].name
  priority                    = 104
  direction                   = "Inbound"
  access                      = "allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [5985, 5986]
  source_address_prefixes     = var.allow_ips
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "hana-xsc-rules" {
  count                       = var.use_existing_nsg ? 0 : var.install_xsa ? 0 : length(local.hana_xsc_rules)
  name                        = element(split(",", local.hana_xsc_rules[count.index]), 0)
  priority                    = element(split(",", local.hana_xsc_rules[count.index]), 1)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = element(split(",", local.hana_xsc_rules[count.index]), 2)
  source_address_prefixes     = local.all_ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hana-resource-group.name
  network_security_group_name = azurerm_network_security_group.sap_nsg[0].name
}

resource "azurerm_network_security_rule" "hana-xsa-rules" {
  count                       = var.use_existing_nsg ? 0 : var.install_xsa ? length(local.hana_xsa_rules) : 0
  name                        = element(split(",", local.hana_xsa_rules[count.index]), 0)
  priority                    = element(split(",", local.hana_xsa_rules[count.index]), 1)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = element(split(",", local.hana_xsa_rules[count.index]), 2)
  source_address_prefixes     = local.all_ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hana-resource-group.name
  network_security_group_name = azurerm_network_security_group.sap_nsg[0].name
}

data "azurerm_network_security_group" "nsg_info" {
  name = element(
    concat(
      azurerm_network_security_group.sap_nsg.*.name,
      [var.existing_nsg_name],
    ),
    0,
  )
  resource_group_name = var.use_existing_nsg ? var.existing_nsg_rg : azurerm_resource_group.hana-resource-group.name
}

