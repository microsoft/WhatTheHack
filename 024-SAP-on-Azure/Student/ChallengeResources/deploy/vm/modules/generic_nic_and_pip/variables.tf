variable "az_region" {
}

variable "az_resource_group" {
  description = "Which Azure resource group to deploy the HANA setup into.  i.e. <myResourceGroup>"
}

variable "az_domain_name" {
  description = "Prefix to be used in the domain name"
}

variable "backend_ip_pool_ids" {
  type        = list(string)
  description = "The ids that associate the load balancer's back end IP pool with this NIC."
  default     = []
}

variable "name" {
  description = "A name that will be used to identify the resource this NIC and PIP are related to."
}

variable "nsg_id" {
  description = "The NSG id for the NSG that will control this VM."
}

variable "private_ip_address" {
  description = "The desired private IP address of this NIC.  If it isn't specified, a dynamic IP will be allocated."
  default     = ""
}

variable "public_ip_allocation_type" {
  description = "Defines whether the IP address is static or dynamic. Options are Static or Dynamic."
}

variable "subnet_id" {
  description = "The subnet that this node needs to be on"
}

locals {
  dynamic      = "Dynamic"
  empty_string = ""
  static       = "Static"
}

