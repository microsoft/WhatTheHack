/* variables for the existing Log Analytics resource
    use datasource for existing Log analytics workspace.
*/

# variable "aks_arm_subscription_id" {}

variable "aks_arm_client_id" {}

#variable "aks_arm_tenent_id" {}
variable "keyvault_uri" {}

variable "ssh_keyvault_secret_name" {}
variable "spn_keyvault_secret_name" {}
variable "la_workspace_name" {}
variable "la_resource_group" {}

variable "log_analytics_workspace_sku" {
  default = "Standard"
}

#########################################
##                                     ##
##          AKS variables              ##
##                                     ##
#########################################

variable "aks_resource_group" {}
variable "location" {}
variable "cluster_name" {}
variable "k8s_version" {}
variable "dns_prefix" {}

variable "agent_count" {
  default = 3
}

variable "agent_pool_name" {}
variable "admin_user" {}
variable "vm_size" {}
variable "aksvnet" {}
variable "aksvnet_resource_group" {}
variable "aks_subnetId" {}

variable "namespace" {
  default = "aks-demo"
}