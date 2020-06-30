output "resource-group" {
  value = var.infrastructure.resource_group.is_existing ? data.azurerm_resource_group.resource-group : azurerm_resource_group.resource-group
}

output "subnet-mgmt" {
  value = var.infrastructure.vnets.management.subnet_mgmt.is_existing ? data.azurerm_subnet.subnet-mgmt : azurerm_subnet.subnet-mgmt
}

output "nsg-mgmt" {
  value = var.infrastructure.vnets.management.subnet_mgmt.nsg.is_existing ? data.azurerm_network_security_group.nsg-mgmt : azurerm_network_security_group.nsg-mgmt
}

output "subnet-sap-admin" {
  value = var.infrastructure.vnets.sap.subnet_admin.is_existing ? data.azurerm_subnet.subnet-sap-admin : azurerm_subnet.subnet-sap-admin
}

output "nsg-admin" {
  value = var.infrastructure.vnets.sap.subnet_admin.nsg.is_existing ? data.azurerm_network_security_group.nsg-admin : azurerm_network_security_group.nsg-admin
}

output "subnet-sap-db" {
  value = var.infrastructure.vnets.sap.subnet_db.is_existing ? data.azurerm_subnet.subnet-sap-db : azurerm_subnet.subnet-sap-db
}

output "nsg-db" {
  value = var.infrastructure.vnets.sap.subnet_db.nsg.is_existing ? data.azurerm_network_security_group.nsg-db : azurerm_network_security_group.nsg-db
}

output "storage-bootdiag" {
  value = azurerm_storage_account.storage-bootdiag
}

output "storage-sapbits" {
  value = var.software.storage_account_sapbits.is_existing ? data.azurerm_storage_account.storage-sapbits : azurerm_storage_account.storage-sapbits
}

output "random-id" {
  value = random_id.random-id
}

output "nics-iscsi" {
  value = azurerm_network_interface.iscsi
}
