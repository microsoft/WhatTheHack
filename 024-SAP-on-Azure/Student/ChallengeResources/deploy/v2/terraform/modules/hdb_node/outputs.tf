output "nics-dbnodes-admin" {
  value = azurerm_network_interface.nics-dbnodes-admin
}

output "nics-dbnodes-db" {
  value = azurerm_network_interface.nics-dbnodes-db
}

output "loadbalancers" {
  value = azurerm_lb.hana-lb
}

# Workaround to create dependency betweeen ../main.tf ansible_execution and module hdb_node
output "dbnode-data-disk-att" {
  value = azurerm_virtual_machine_data_disk_attachment.vm-dbnode-data-disk
}
