# Configure the Microsoft Azure Provider
provider "azurerm" {
  version = "~> 1.30.1"
}

module "common_setup" {
  source = "../common_setup"

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

resource "azurerm_availability_set" "ha-pair-availset" {
  name                         = "hanaHAPairAvailabilitySet"
  location                     = module.common_setup.resource_group_location
  resource_group_name          = module.common_setup.resource_group_name
  platform_update_domain_count = 20
  platform_fault_domain_count  = 2
  managed                      = true

  tags = {
    environment = "HA-Pair deployment"
  }
}

resource "azurerm_lb" "ha-pair-lb" {
  name                = "ha-pair-lb"
  location            = var.az_region
  resource_group_name = module.common_setup.resource_group_name

  frontend_ip_configuration {
    name                          = "hsr-front"
    subnet_id                     = module.common_setup.vnet_subnets
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address_lb_frontend
  }
}

resource "azurerm_lb_probe" "health-probe" {
  resource_group_name = module.common_setup.resource_group_name
  loadbalancer_id     = azurerm_lb.ha-pair-lb.id
  name                = "health-probe"
  port                = "625${var.sap_instancenum}"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_backend_address_pool" "availability-back-pool" {
  resource_group_name = module.common_setup.resource_group_name
  loadbalancer_id     = azurerm_lb.ha-pair-lb.id
  name                = "BackEndAddressPool-HA"
}

# These are the load balancing rules specifically for HANA1's HA pair pacemaker
resource "azurerm_lb_rule" "lb-hana1-rule" {
  count                          = var.useHana2 ? 0 : length(local.hana1_lb_ports)
  name                           = "lb-rule-${count.index}"
  resource_group_name            = module.common_setup.resource_group_name
  loadbalancer_id                = azurerm_lb.ha-pair-lb.id
  protocol                       = "Tcp"
  frontend_port                  = local.hana1_lb_ports[count.index]
  backend_port                   = local.hana1_lb_ports[count.index]
  backend_address_pool_id        = azurerm_lb_backend_address_pool.availability-back-pool.id
  probe_id                       = azurerm_lb_probe.health-probe.id
  idle_timeout_in_minutes        = 30
  enable_floating_ip             = true
  frontend_ip_configuration_name = "hsr-front"
}

# These are the load balancing rules specifically for HANA2's HA pair pacemaker
resource "azurerm_lb_rule" "lb-hana2-rule" {
  count                          = var.useHana2 ? length(local.hana2_lb_ports) : 0
  name                           = "lb-rule-${count.index}"
  resource_group_name            = module.common_setup.resource_group_name
  loadbalancer_id                = azurerm_lb.ha-pair-lb.id
  protocol                       = "Tcp"
  frontend_port                  = local.hana2_lb_ports[count.index]
  backend_port                   = local.hana2_lb_ports[count.index]
  backend_address_pool_id        = azurerm_lb_backend_address_pool.availability-back-pool.id
  probe_id                       = azurerm_lb_probe.health-probe.id
  idle_timeout_in_minutes        = 30
  enable_floating_ip             = true
  frontend_ip_configuration_name = "hsr-front"
}

module "create_hdb0" {
  source = "../create_hdb_node"

  availability_set_id       = azurerm_availability_set.ha-pair-availset.id
  az_resource_group         = module.common_setup.resource_group_name
  az_region                 = module.common_setup.resource_group_location
  az_domain_name            = var.az_domain_name
  backend_ip_pool_ids       = [azurerm_lb_backend_address_pool.availability-back-pool.id]
  hdb_num                   = "0"
  hana_subnet_id            = module.common_setup.vnet_subnets
  nsg_id                    = module.common_setup.nsg_id
  private_ip_address        = var.private_ip_address_hdb0
  public_ip_allocation_type = var.public_ip_allocation_type
  sap_sid                   = var.sap_sid
  sshkey_path_public        = var.sshkey_path_public
  storage_disk_sizes_gb     = var.storage_disk_sizes_gb
  vm_user                   = var.vm_user
  vm_size                   = var.vm_size
}

module "create_hdb1" {
  source = "../create_hdb_node"

  availability_set_id       = azurerm_availability_set.ha-pair-availset.id
  az_resource_group         = module.common_setup.resource_group_name
  az_region                 = module.common_setup.resource_group_location
  az_domain_name            = var.az_domain_name
  backend_ip_pool_ids       = [azurerm_lb_backend_address_pool.availability-back-pool.id]
  hdb_num                   = "1"
  hana_subnet_id            = module.common_setup.vnet_subnets
  nsg_id                    = module.common_setup.nsg_id
  private_ip_address        = var.private_ip_address_hdb1
  public_ip_allocation_type = var.public_ip_allocation_type
  sap_sid                   = var.sap_sid
  sshkey_path_public        = var.sshkey_path_public
  storage_disk_sizes_gb     = var.storage_disk_sizes_gb
  vm_user                   = var.vm_user
  vm_size                   = var.vm_size
}

module "nic_and_pip_setup_iscsi" {
  source = "../generic_nic_and_pip"

  az_region                 = module.common_setup.resource_group_location
  az_resource_group         = module.common_setup.resource_group_name
  az_domain_name            = var.az_domain_name
  name                      = "iscsi"
  nsg_id                    = module.common_setup.nsg_id
  private_ip_address        = var.private_ip_address_iscsi
  public_ip_allocation_type = var.public_ip_allocation_type
  subnet_id                 = module.common_setup.vnet_subnets
}

module "vm_and_disk_creation_iscsi" {
  source = "../generic_vm_and_disk_creation"

  sshkey_path_public    = var.sshkey_path_public
  az_resource_group     = module.common_setup.resource_group_name
  az_region             = module.common_setup.resource_group_location
  storage_disk_sizes_gb = [16]
  machine_name          = "${var.az_domain_name}-iscsi"
  vm_user               = var.vm_user
  vm_size               = "Standard_D2s_v3"
  nic_id                = module.nic_and_pip_setup_iscsi.nic_id
  availability_set_id   = azurerm_availability_set.ha-pair-availset.id
  machine_type          = "iscsi"
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

# Write the required configuration variable to a file, that will be used by the Ansible playbook for creating a linux bastion host
resource "local_file" "write-config-to-json" {
  content  = "{az_vm_name: \"${local.linux_vm_name}\",az_vnet: \"${module.common_setup.vnet_name}\",az_subnet: \"hdb-subnet\",linux_bastion: ${var.linux_bastion},url_linux_hana_studio: \"${var.url_hana_studio_linux}\", url_linux_sapcar: \"${var.url_sap_sapcar_linux}\",az_resource_group: \"${module.common_setup.resource_group_name}\", az_user: \"${var.vm_user}\", nsg_id: \"${module.common_setup.nsg_id}\", vm_size: \"${var.vm_size}\", private_ip_address: \"${var.private_ip_address_linux_bastion}\",az_public_key: \"${var.sshkey_path_public}\", ssh_private_key_file: \"${var.sshkey_path_private}\"}"
  filename = "temp.json"
}

resource "null_resource" "install_ansible_roles" {
  provisioner "local-exec" {
    command = "ansible-galaxy install -r ../../ansible/requirements.yml"
  }
}

module "configure_vm" {
  source = "../playbook-execution"

  ansible_playbook_path          = var.ansible_playbook_path
  az_resource_group              = module.common_setup.resource_group_name
  sshkey_path_private            = var.sshkey_path_private
  sap_instancenum                = var.sap_instancenum
  sap_sid                        = var.sap_sid
  vm_user                        = var.vm_user
  url_sap_sapcar                 = var.url_sap_sapcar_linux
  url_sap_hdbserver              = var.url_sap_hdbserver
  private_ip_address_hdb0        = var.private_ip_address_hdb0
  private_ip_address_hdb1        = var.private_ip_address_hdb1
  private_ip_address_lb_frontend = var.private_ip_address_lb_frontend
  pw_hacluster                   = var.pw_hacluster
  pw_os_sapadm                   = var.pw_os_sapadm
  pw_os_sidadm                   = var.pw_os_sidadm
  pw_db_system                   = var.pw_db_system
  useHana2                       = var.useHana2
  vms_configured                 = "${module.create_hdb0.machine_hostname}, ${module.create_hdb1.machine_hostname}, ${module.vm_and_disk_creation_iscsi.machine_hostname}"
  hana1_db_mode                  = var.hana1_db_mode
  url_xsa_runtime                = var.url_xsa_runtime
  url_di_core                    = var.url_di_core
  url_sapui5                     = var.url_sapui5
  url_portal_services            = var.url_portal_services
  url_xs_services                = var.url_xs_services
  url_shine_xsa                  = var.url_shine_xsa
  url_xsa_hrtt                   = var.url_xsa_hrtt
  url_xsa_webide                 = var.url_xsa_webide
  url_xsa_mta                    = var.url_xsa_mta
  pwd_db_xsaadmin                = var.pwd_db_xsaadmin
  pwd_db_tenant                  = var.pwd_db_tenant
  pwd_db_shine                   = var.pwd_db_shine
  email_shine                    = var.email_shine
  url_cockpit                    = var.url_cockpit
  install_xsa                    = var.install_xsa
  install_shine                  = var.install_shine
  install_cockpit                = var.install_cockpit
  install_webide                 = var.install_webide
  url_sapcar_windows             = var.url_sapcar_windows
  url_hana_studio_windows        = var.url_hana_studio_windows
  bastion_username_windows       = var.bastion_username_windows
  pw_bastion_windows             = var.pw_bastion_windows
}

# Delete the linux bastion host vm
resource "null_resource" "destroy-vm" {
  provisioner "local-exec" {
    when = destroy

    command = <<EOT
               OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES \
               AZURE_RESOURCE_GROUPS="${var.az_resource_group}" \
               ANSIBLE_HOST_KEY_CHECKING="False" \
         ansible-playbook -u '${var.vm_user}' \
         --private-key '${var.sshkey_path_private}' \
         --extra-vars="{az_resource_group: \"${module.common_setup.resource_group_name}\", az_vm_name:  \"${local.linux_vm_name}\"}" ../../ansible/delete_bastion_linux.yml
EOT

  }
}

resource "null_resource" "delete-iscsi-public-ip" {
  depends_on = [module.configure_vm]

  provisioner "local-exec" {
    command = <<EOT
               OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES \
               AZURE_RESOURCE_GROUPS="${var.az_resource_group}" \
               ANSIBLE_HOST_KEY_CHECKING="False" \
         ansible-playbook -u '${var.vm_user}' \
         --private-key '${var.sshkey_path_private}' \
         --extra-vars="{ ip_config_name: \"iscsi-nic-configuration\",azure_nic: \"${module.nic_and_pip_setup_iscsi.nic_name}\", azure_vnet:  \"${module.common_setup.vnet_name}\", azure_subnet: \"hdb-subnet\", azure_nsg: \"${module.common_setup.nsg_id}\", azure_private_ip: \"${var.private_ip_address_iscsi}\", azure_resource_group: \"${module.common_setup.resource_group_name}\", azure_public_ip:  \"${module.nic_and_pip_setup_iscsi.pip_name}\"}" ../../ansible/delete_iscsi_public_ip.yml
EOT

  }
}

