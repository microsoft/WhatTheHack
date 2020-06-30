variable "databases" {
  description = "Details of the HANA database nodes"
}

variable "infrastructure" {
  description = "Details of the Azure infrastructure to deploy the SAP landscape into"
}

variable "jumpboxes" {
  description = "Details of the jumpboxes and RTI box"
}

variable "options" {
  description = "Configuration options"
}

variable "software" {
  description = "Details of the infrastructure components required for SAP installation"
}

variable "ssh-timeout" {
  description = "Timeout for connection that is used by provisioner"
  default     = "30s"
}

variable "sshkey" {
  description = "Details of ssh key pair"
}
