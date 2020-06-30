variable "availability_set_id" {
  description = "The id associated with the availability set to put this VM into."
  default     = ""
}

variable "az_region" {
}

variable "az_resource_group" {
  description = "Which Azure resource group to deploy the HANA setup into.  i.e. <myResourceGroup>"
}

variable "machine_name" {
  description = "The name for the VM that is being created."
}

variable "machine_type" {
  description = "The use of the VM to help later with configurations."
}

variable "nic_id" {
  description = "The id of the network interface that should be associated with this VM."
}

variable "sshkey_path_public" {
  description = "The path on the local machine to where the public key is"
}

variable "storage_disk_sizes_gb" {
  type        = list(string)
  description = "List disk sizes in GB for all disks this VM will need"
}

variable "tags" {
  type        = map(string)
  description = "tags to add to the machine"
  default     = {}
}

variable "vm_size" {
  description = "The size of the VM to create."
}

variable "vm_user" {
  description = "The username of your VM."
}

variable "vm_paswd" {
  description = "The OS password of your VM."
}
