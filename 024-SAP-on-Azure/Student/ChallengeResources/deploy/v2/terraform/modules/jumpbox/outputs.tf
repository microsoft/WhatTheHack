output "nics-jumpboxes-linux" {
  value = concat(azurerm_network_interface.jump-linux, azurerm_network_interface.rti)
}

output "nics-jumpboxes-windows" {
  value = azurerm_network_interface.jump-win
}

output "public-ips-jumpboxes-linux" {
  value = concat(azurerm_public_ip.jump-linux, azurerm_public_ip.rti)
}

output "public-ips-jumpboxes-windows" {
  value = azurerm_public_ip.jump-win
}

output "jumpboxes-linux" {
  value = concat(local.vm-jump-linux, local.rti)
}

output "rti-info" {
  value = {
    authentication    = local.rti[0].authentication,
    public_ip_address = azurerm_public_ip.rti[0].ip_address
  }
}

# Workaround to create dependency betweeen ../main.tf ansible_execution and module jumpbox
output "prepare-rti" {
  value = null_resource.prepare-rti
}

output "vm-windows" {
  value = azurerm_windows_virtual_machine.jump-win
}
