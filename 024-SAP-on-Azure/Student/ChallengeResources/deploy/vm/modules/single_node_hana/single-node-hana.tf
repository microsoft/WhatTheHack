# Configure the Microsoft Azure Provider
provider "azurerm" {
  version = "~> 1.30.1"
}

module "common_setup" {
  source            = "../common_setup"
  allow_ips         = var.allow_ips
  az_region         = var.az_region
  az_resource_group = var.az_resource_group
  existing_nsg_name = var.existing_nsg_name
  existing_nsg_rg   = var.existing_nsg_rg
  install_xsa       = var.install_xsa
  sap_instancenum   = var.sap_instancenum
  sap_sid           = var.sap_sid
  use_existing_nsg  = var.use_existing_nsg
  windows_bastion   = var.windows_bastion
}

module "create_hdb" {
  source = "../create_hdb_node"

  az_resource_group         = module.common_setup.resource_group_name
  az_region                 = var.az_region
  hdb_num                   = 0
  az_domain_name            = var.az_domain_name
  hana_subnet_id            = module.common_setup.vnet_subnets
  nsg_id                    = module.common_setup.nsg_id
  private_ip_address        = var.private_ip_address_hdb
  public_ip_allocation_type = var.public_ip_allocation_type
  sap_sid                   = var.sap_sid
  sshkey_path_public        = var.sshkey_path_public
  storage_disk_sizes_gb     = var.storage_disk_sizes_gb
  vm_user                   = var.vm_user
  vm_paswd                  = var.vm_paswd
  vm_size                   = var.vm_size
}

module "windows_bastion_host" {
  source             = "../windows_bastion_host"
  allow_ips          = var.allow_ips
  az_domain_name     = var.az_domain_name
  az_resource_group  = module.common_setup.resource_group_name
  az_region          = var.az_region
  sap_sid            = var.sap_sid
  subnet_id          = module.common_setup.vnet_subnets
  bastion_username   = var.bastion_username_windows
  private_ip_address = var.private_ip_address_windows_bastion
  pw_bastion         = var.pw_bastion_windows
  windows_bastion    = var.windows_bastion
}

# Writes the configuration to a file, which will be used by the Ansible playbook for creating linux bastion host
resource "local_file" "write-config-to-json" {
  content  = "{az_vm_name: \"${local.linux_vm_name}\",az_vnet: \"${module.common_setup.vnet_name}\",az_subnet: \"hdb-subnet\",linux_bastion: ${var.linux_bastion},url_linux_hana_studio: \"${var.url_hana_studio_linux}\", url_linux_sapcar: \"${var.url_sap_sapcar_linux}\",az_resource_group: \"${module.common_setup.resource_group_name}\", az_user: \"${var.vm_user}\", nsg_id: \"${module.common_setup.nsg_id}\", vm_size: \"${var.vm_size}\", private_ip_address: \"${var.private_ip_address_linux_bastion}\",az_public_key: \"${var.sshkey_path_public}\", ssh_private_key_file: \"${var.sshkey_path_private}\"}"
  filename = "temp.json"
}

module "configure_vm" {
  source                   = "../playbook-execution"
  ansible_playbook_path    = var.ansible_playbook_path
  az_resource_group        = module.common_setup.resource_group_name
  sshkey_path_private      = var.sshkey_path_private
  sap_instancenum          = var.sap_instancenum
  sap_sid                  = var.sap_sid
  vm_user                  = var.vm_user
  url_sap_sapcar           = var.url_sap_sapcar_linux
  url_sap_hdbserver        = var.url_sap_hdbserver
  pw_os_sapadm             = var.pw_os_sapadm
  pw_os_sidadm             = var.pw_os_sidadm
  pw_db_system             = var.pw_db_system
  useHana2                 = var.useHana2
  vms_configured           = "${module.create_hdb.machine_hostname}, ${module.windows_bastion_host.machine_hostname}"
  hana1_db_mode            = var.hana1_db_mode
  url_xsa_runtime          = var.url_xsa_runtime
  url_di_core              = var.url_di_core
  url_sapui5               = var.url_sapui5
  url_portal_services      = var.url_portal_services
  url_xs_services          = var.url_xs_services
  url_shine_xsa            = var.url_shine_xsa
  url_xsa_hrtt             = var.url_xsa_hrtt
  url_xsa_webide           = var.url_xsa_webide
  url_xsa_mta              = var.url_xsa_mta
  pwd_db_xsaadmin          = var.pwd_db_xsaadmin
  pwd_db_tenant            = var.pwd_db_tenant
  pwd_db_shine             = var.pwd_db_shine
  email_shine              = var.email_shine
  install_xsa              = var.install_xsa
  install_shine            = var.install_shine
  install_cockpit          = var.install_cockpit
  install_webide           = var.install_webide
  url_cockpit              = var.url_cockpit
  url_sapcar_windows       = var.url_sapcar_windows
  url_hana_studio_windows  = var.url_hana_studio_windows
  bastion_username_windows = var.bastion_username_windows
  pw_bastion_windows       = var.pw_bastion_windows
}

# Destroy the linux bastion host
resource "null_resource" "destroy-vm" {
  provisioner "local-exec" {
    when = destroy

    command = <<EOT
               OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES \
               AZURE_RESOURCE_GROUPS="${var.az_resource_group}" \
               ANSIBLE_HOST_KEY_CHECKING="False" \
               ansible-playbook -u '${var.vm_user}' \
               --private-key '${var.sshkey_path_private}' \
               --extra-vars="{az_resource_group: \"${module.common_setup.resource_group_name}\", az_vm_name: \"${local.linux_vm_name}\", linux_bastion: \"${var.linux_bastion}\"}" ../../ansible/delete_bastion_linux.yml
EOT

  }
}

