/*-----------------------------------------------------------------------------8
|                                                                              |
|                                Admin - NSG                                   |
|                                                                              |
+--------------------------------------4--------------------------------------*/

# NSGs ===========================================================================================================

# Creates mgmt subnet nsg
resource "azurerm_network_security_group" "nsg-mgmt" {
  count               = var.infrastructure.vnets.management.subnet_mgmt.nsg.is_existing ? 0 : 1
  name                = var.infrastructure.vnets.management.subnet_mgmt.nsg.name
  location            = var.infrastructure.region
  resource_group_name = var.infrastructure.resource_group.is_existing ? data.azurerm_resource_group.resource-group[0].name : azurerm_resource_group.resource-group[0].name
}

# Creates SAP admin subnet nsg
resource "azurerm_network_security_group" "nsg-admin" {
  count               = var.infrastructure.vnets.sap.subnet_admin.nsg.is_existing ? 0 : 1
  name                = var.infrastructure.vnets.sap.subnet_admin.nsg.name
  location            = var.infrastructure.region
  resource_group_name = var.infrastructure.resource_group.is_existing ? data.azurerm_resource_group.resource-group[0].name : azurerm_resource_group.resource-group[0].name
}

# Creates SAP db subnet nsg
resource "azurerm_network_security_group" "nsg-db" {
  count               = var.infrastructure.vnets.sap.subnet_db.nsg.is_existing ? 0 : 1
  name                = var.infrastructure.vnets.sap.subnet_db.nsg.name
  location            = var.infrastructure.region
  resource_group_name = var.infrastructure.resource_group.is_existing ? data.azurerm_resource_group.resource-group[0].name : azurerm_resource_group.resource-group[0].name
}

# Creates SAP app subnet nsg
resource "azurerm_network_security_group" "nsg-app" {
  count               = var.is_single_node_hana ? 0 : lookup(var.infrastructure.sap, "subnet_app.nsg.is_existing", false) ? 0 : 1
  name                = var.infrastructure.vnets.sap.subnet_app.nsg.name
  location            = var.infrastructure.region
  resource_group_name = var.infrastructure.resource_group.is_existing ? data.azurerm_resource_group.resource-group[0].name : azurerm_resource_group.resource-group[0].name
}

# Imports the mgmt subnet nsg data
data "azurerm_network_security_group" "nsg-mgmt" {
  count               = var.infrastructure.vnets.management.subnet_mgmt.nsg.is_existing ? 1 : 0
  name                = split("/", var.infrastructure.vnets.management.subnet_mgmt.nsg.arm_id)[8]
  resource_group_name = split("/", var.infrastructure.vnets.management.subnet_mgmt.nsg.arm_id)[4]
}

# Imports the SAP admin subnet nsg data
data "azurerm_network_security_group" "nsg-admin" {
  count               = var.infrastructure.vnets.sap.subnet_admin.nsg.is_existing ? 1 : 0
  name                = split("/", var.infrastructure.vnets.sap.subnet_admin.nsg.arm_id)[8]
  resource_group_name = split("/", var.infrastructure.vnets.sap.subnet_admin.nsg.arm_id)[4]
}

# Imports the SAP db subnet nsg data
data "azurerm_network_security_group" "nsg-db" {
  count               = var.infrastructure.vnets.sap.subnet_db.nsg.is_existing ? 1 : 0
  name                = split("/", var.infrastructure.vnets.sap.subnet_db.nsg.arm_id)[8]
  resource_group_name = split("/", var.infrastructure.vnets.sap.subnet_db.nsg.arm_id)[4]
}

# Imports the SAP app subnet nsg data
data "azurerm_network_security_group" "nsg-app" {
  count               = var.is_single_node_hana ? 0 : lookup(var.infrastructure.sap, "subnet_app.nsg.is_existing", false) ? 1 : 0
  name                = split("/", var.infrastructure.vnets.sap.subnet_app.nsg.arm_id)[8]
  resource_group_name = split("/", var.infrastructure.vnets.sap.subnet_app.nsg.arm_id)[4]
}
