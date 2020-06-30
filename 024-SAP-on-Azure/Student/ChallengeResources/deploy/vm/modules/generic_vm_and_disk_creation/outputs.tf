output "machine_hostname" {
  depends_on = [azurerm_virtual_machine_data_disk_attachment.disk]

  value = var.machine_name
}

