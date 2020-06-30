output "ansible-jumpbox-public-ip-address" {
  value = module.jumpbox.rti-info.public_ip_address
}

output "ansible-jumpbox-username" {
  value = module.jumpbox.rti-info.authentication.username
}
