variable "allow_ips" {
  description = "The IP addresses that will be allowed by the nsg"
  type        = list(string)
}

variable "az_domain_name" {
  description = "Prefix to be used in the domain name"
}

variable "az_region" {
}

variable "az_resource_group" {
  description = "Which azure resource group to deploy the HANA setup into.  i.e. <myResourceGroup>"
}

variable "bastion_username" {
  description = "The username for the bastion host"
}

variable "private_ip_address" {
  description = "The desired private IP address of this NIC.  If it isn't specified, a dynamic IP will be allocated."
  default     = "10.0.0.4"
}

variable "pw_bastion" {
  description = "The password for the bastion host"
}

variable "vm_size" {
  default = "Standard_D2s_v3"
}

variable "sap_sid" {
  description = "SAP Instance number"
}

variable "subnet_id" {
  default     = "bastion_subnet"
  description = "The id of the subnet the bastion host will be in.  This should be different than the HANA vms."
}

variable "windows_bastion" {
  description = "Whether or not you want a windows bastion host"
  default     = false
}

locals {
  dynamic      = "Dynamic"
  empty_string = ""
  colon        = ":"
  dash         = "-"

  machine_name = "${lower(var.sap_sid)}-win-bastion"
  static       = "Static"
}

