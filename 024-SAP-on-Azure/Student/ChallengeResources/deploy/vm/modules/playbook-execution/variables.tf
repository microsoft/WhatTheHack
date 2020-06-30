variable "ansible_playbook_path" {
  description = "Path from this module to the playbook"
}

variable "az_resource_group" {
  description = "Which azure resource group to deploy the HANA setup into.  i.e. <myResourceGroup>"
}

variable "bastion_username_windows" {
  description = "The username for the bastion host"
}

variable "email_shine" {
  description = "e-mail address for SHINE user"
  default     = "shinedemo@microsoft.com"
}

variable "install_cockpit" {
  description = "Flag to determine whether to install Cockpit on the host VM"
  default     = false
}

variable "install_shine" {
  description = "Flag to determine whether to install SHINE on the host VM"
  default     = false
}

variable "install_xsa" {
  description = "Flag to determine whether to install XSA on the host VM"
  default     = false
}

variable "install_webide" {
  description = "Flag that determines whether to install WebIDE on the host"
  default     = false
}

variable "private_ip_address_hdb0" {
  description = "Private ip address of hdb0 in HA pair"
  default     = "" # not needed in single node case
}

variable "private_ip_address_hdb1" {
  description = "Private ip address of hdb1 in HA pair"
  default     = "" # not needed in single node case
}

variable "private_ip_address_lb_frontend" {
  description = "Private ip address of the load balancer front end in HA pair"
  default     = "" # not needed in single node case
}

variable "pw_bastion_windows" {
  description = "The password for the bastion host"
}

variable "pw_db_system" {
  description = "Password for the database user SYSTEM"
}

variable "pw_hacluster" {
  type        = "string"
  description = "Password for the HA cluster nodes"
  default     = "" #single node case doesn't need one
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
}

variable "url_portal_services" {
  description = "URL for Portal Services"
  default     = ""
}

variable "url_sap_hdbserver" {
  type        = "string"
  description = "The URL that points to the HDB server 122.17 bits"
}

variable "url_sap_sapcar" {
  type        = "string"
  description = "The URL that points to the SAPCAR bits"
}

variable "url_sapcar_windows" {
  description = "URL for SAPCAR for Windows to run on the bastion host"
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

variable "url_timeout" {
  description = "Timeout in seconds for URL request."
  default     = 30
}

variable "url_retries_cnt" {
  description = "The number of attempts to download the installation bits from the URLs."
  default     = 10
}

variable "url_retries_delay" {
  description = "The time (in seconds) between each attempt to download the installation bits from the URLs"
  default     = 10
}

variable "package_retries_cnt" {
  description = "The number of attempts to install packages"
  default     = 10
}

variable "package_retries_delay" {
  description = "The time (in seconds) between each attempt to install packages"
  default     = 10
}

variable "useHana2" {
  description = "If this is set to true, then, ports specifically for HANA 2.0 will be opened."
  default     = false
}

variable "hana1_db_mode" {
  description = "The database mode to use if deploying HANA 1. The acceptable values are: single_container, multiple_containers"
  default     = "multiple_containers"
}

variable "vm_user" {
  description = "The username of your HANA database VM."
}

variable "vms_configured" {
  description = "The hostnames of the machines that need to be configured in order to correctly run this playbook."
}

variable "linux_bastion" {
  description = "flag to determine if linux bastion host is needed or not"
  default     = false
}

