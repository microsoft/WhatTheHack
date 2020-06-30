output "hdb_vm_user" {
  value = var.vm_user
}

output "hdb_ip" {
  value = module.create_hdb.fqdn
}

output "windows_bastion_ip" {
  value = module.windows_bastion_host.ip
}

output "windows_bastion_user" {
  value = var.bastion_username_windows
}

