variable "azurerm" {
  description = "The subscription_id, client_id, client_secret and tenant_id to setup Terraform access"
  type = "map"
}
variable "location" {
  description = "The location where resources are created"
  default     = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources are created"  
}

variable "virtual_network_name" {
    description = "The name for the virtual network"        
}
variable "virtual_network_address_space" {
    description = "The name for the virtual network"   
    type = "list"     
}
variable "subnet" { 
    description = "The name and address prefix for the subnet" 
    type = "map"   
}

variable "nsg" {
    description = "The name of the Network security group"    
}
variable "nsg_security_rule_ssh" {
    description = "The name, priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix for the SSH NSG security rule"
    type = "map"    
}
variable "tags" {    
    description = "The tags for the Azure resource"
    type = "map"  
}