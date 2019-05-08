output "ip_address" {
  value = "${azurerm_public_ip.lvmPublicIp.ip_address}"
}

output "vm_fqdn" {
  value = "${azurerm_public_ip.lvmPublicIp.fqdn}"
}