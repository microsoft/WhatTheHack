variable "allow_ips" {
  description = "The ip addresses that will be allowed by the nsg"
  default     = ["0.0.0.0/0"]
}

variable "ansible_playbook_path" {
  description = "Path from this module to the playbook"
  default     = "../../ansible/ha_pair_playbook.yml"
}

variable "az_domain_name" {
  description = "Prefix to be used in the domain name"
}

variable "az_region" {
}

variable "az_resource_group" {
  description = "Which Azure resource group to deploy the HANA setup into.  i.e. <myResourceGroup>"
}

variable "bastion_username_windows" {
  description = "The username for the bastion host"
  default     = "bastion_user"
}

variable "email_shine" {
  description = "e-mail address for SHINE user"
  default     = "shinedemo@microsoft.com"
}

variable "existing_nsg_name" {
  description = "The name of the pre-existing nsg that you would like to use"
  default     = ""
}

variable "existing_nsg_rg" {
  description = "The name of the pre-existing resource group that you would like to use"
  default     = ""
}

variable "install_cockpit" {
  description = "Flag that determines whether to install Cockpit on the host"
  default     = false
}

variable "install_shine" {
  description = "Flag that determines whether to install SHINE on the host"
  default     = false
}

variable "install_xsa" {
  description = "Flag that determines whether to install XSA on the host"
  default     = false
}

variable "install_webide" {
  description = "Flag that determines whether to install WebIDE on the host"
  default     = false
}

variable "private_ip_address_hdb0" {
  default = "10.0.0.6"
}

variable "private_ip_address_hdb1" {
  default = "10.0.0.7"
}

variable "private_ip_address_iscsi" {
  default = "10.0.0.17"
}

variable "private_ip_address_linux_bastion" {
  default = "10.0.0.5"
}

variable "private_ip_address_lb_frontend" {
  default = "10.0.0.13"
}

variable "private_ip_address_windows_bastion" {
  description = "The desired private IP address of this NIC.  If it isn't specified, a dynamic IP will be allocated."
  default     = "10.0.0.4"
}

variable "public_ip_allocation_type" {
  description = "Defines whether the IP address is static or dynamic. Options are Static or Dynamic."
  default     = "Dynamic"
}

variable "pw_bastion_windows" {
  description = "The password for the bastion host.  Must be replaced if you plan on having a Windows bastion host"
  default     = ""
}

variable "pw_db_system" {
  description = "Password for the database user SYSTEM"
}

variable "pw_hacluster" {
  type        = string
  description = "Password for the HA cluster nodes"
}

variable "pw_os_sapadm" {
  description = "Password for the SAP admin, which is an OS user"
}

variable "pw_os_sidadm" {
  description = "Password for this specific sidadm, which is an OS user"
}

variable "pwd_db_shine" {
  description = "Password for SHINE user"
  default     = ""
}

variable "pwd_db_tenant" {
  description = "Password for SYSTEM user (tenant DB)"
  default     = ""
}

variable "pwd_db_xsaadmin" {
  description = "Password for XSAADMIN user"
  default     = ""
}

variable "sap_instancenum" {
  description = "The SAP instance number which is in range 00-99"
}

variable "sap_sid" {
  default = "PV1"
}

variable "sshkey_path_private" {
  description = "The path on the local machine to where the private key is"
}

variable "sshkey_path_public" {
  description = "The path on the local machine to where the public key is"
}

variable "storage_disk_sizes_gb" {
  description = "List disk sizes in GB for all disks this VM will need"
  default     = [512, 512, 512]
}

variable "url_cockpit" {
  description = "URL for HANA Cockpit"
  default     = ""
}

variable "url_di_core" {
  description = "URL for DI Core"
  default     = ""
}

variable "url_hana_studio_windows" {
  description = "URL for the Windows version of HANA Studio to install on the bastion host"
  default     = ""
}

variable "url_hana_studio_linux" {
  description = "URL for the Linux version of HANA Studio to install on the bastion host"
  default     = ""
}

variable "url_portal_services" {
  description = "URL for Portal Services"
  default     = ""
}

variable "url_sap_hdbserver" {
  type        = string
  description = "The url that points to the HDB server 122.17 bits"
}

variable "url_sapcar_windows" {
  description = "URL for SAPCAR for Windows to run on the bastion host"
  default     = ""
}

variable "url_sap_sapcar_linux" {
  description = "URL for SAPCAR for Linux to run on the bastion host"
  default     = ""
}

variable "url_sapui5" {
  description = "URL for SAPUI5"
  default     = ""
}

variable "url_shine_xsa" {
  description = "URL for SHINE XSA"
  default     = ""
}

variable "url_xs_services" {
  description = "URL for XS Services"
  default     = ""
}

variable "url_xsa_runtime" {
  description = "URL for XSA runtime"
  default     = ""
}

variable "url_xsa_hrtt" {
  description = "URL for HRTT"
  default     = ""
}

variable "url_xsa_webide" {
  description = "URL for WebIDE"
  default     = ""
}

variable "url_xsa_mta" {
  description = "URL for MTA ext"
  default     = ""
}

variable "use_existing_nsg" {
  default = false
}

variable "useHana2" {
  description = "A boolean that will choose between HANA 1.0 and 2.0"
  default     = false
}

variable "hana1_db_mode" {
  description = "The database mode to use if deploying HANA 1. The acceptable values are: single_container, multiple_containers"
  default     = "multiple_containers"
}

variable "vm_size" {
  default = "Standard_E8s_v3"
}

variable "vm_user" {
  description = "The username of your HANA database VM."
}

variable "windows_bastion" {
  description = "Whether or not you want a windows bastion host"
  default     = false
}

variable "linux_bastion" {
  description = "Whether or not you want a linux bastion host"
  default     = false
}

locals {
  # name of the linux vm
  linux_vm_name = "${var.az_domain_name}-linux-bastion"

  # These are the load balancing ports specifically for HANA1 pacemaker. DO NOT ALTER
  hana1_lb_ports = [
    "3${var.sap_instancenum}15",
    "3${var.sap_instancenum}17",
  ]

  # These are the load balancing ports specifically for HANA2 pacemaker. DO NOT ALTER
  hana2_lb_ports = [
    "3${var.sap_instancenum}13",
    "3${var.sap_instancenum}14",
    "3${var.sap_instancenum}40",
    "3${var.sap_instancenum}41",
    "3${var.sap_instancenum}42",
  ]
}

