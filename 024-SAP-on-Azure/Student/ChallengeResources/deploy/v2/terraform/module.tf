# Initalizes Azure rm provider
provider "azurerm" {
  version = "~> 2.0"
  features {}
}

# Setup common infrastructure
module "common_infrastructure" {
  source              = "./modules/common_infrastructure"
  is_single_node_hana = "true"
  databases           = var.databases
  infrastructure      = var.infrastructure
  jumpboxes           = var.jumpboxes
  options             = var.options
  software            = var.software
  ssh-timeout         = var.ssh-timeout
  sshkey              = var.sshkey
}

# Create Jumpboxes and RTI box
module "jumpbox" {
  source            = "./modules/jumpbox"
  databases         = var.databases
  infrastructure    = var.infrastructure
  jumpboxes         = var.jumpboxes
  options           = var.options
  software          = var.software
  ssh-timeout       = var.ssh-timeout
  sshkey            = var.sshkey
  resource-group    = module.common_infrastructure.resource-group
  subnet-mgmt       = module.common_infrastructure.subnet-mgmt
  nsg-mgmt          = module.common_infrastructure.nsg-mgmt
  storage-bootdiag  = module.common_infrastructure.storage-bootdiag
  output-json       = module.output_files.output-json
  ansible-inventory = module.output_files.ansible-inventory
  random-id         = module.common_infrastructure.random-id
}

# Create HANA database nodes
module "hdb_node" {
  source           = "./modules/hdb_node"
  databases        = var.databases
  infrastructure   = var.infrastructure
  jumpboxes        = var.jumpboxes
  options          = var.options
  software         = var.software
  ssh-timeout      = var.ssh-timeout
  sshkey           = var.sshkey
  resource-group   = module.common_infrastructure.resource-group
  subnet-sap-admin = module.common_infrastructure.subnet-sap-admin
  nsg-admin        = module.common_infrastructure.nsg-admin
  subnet-sap-db    = module.common_infrastructure.subnet-sap-db
  nsg-db           = module.common_infrastructure.nsg-db
  storage-bootdiag = module.common_infrastructure.storage-bootdiag
}

# Generate output files
module "output_files" {
  source                       = "./modules/output_files"
  databases                    = var.databases
  infrastructure               = var.infrastructure
  jumpboxes                    = var.jumpboxes
  options                      = var.options
  software                     = var.software
  ssh-timeout                  = var.ssh-timeout
  sshkey                       = var.sshkey
  storage-sapbits              = module.common_infrastructure.storage-sapbits
  nics-iscsi                   = module.common_infrastructure.nics-iscsi
  nics-jumpboxes-windows       = module.jumpbox.nics-jumpboxes-windows
  nics-jumpboxes-linux         = module.jumpbox.nics-jumpboxes-linux
  public-ips-jumpboxes-windows = module.jumpbox.public-ips-jumpboxes-windows
  public-ips-jumpboxes-linux   = module.jumpbox.public-ips-jumpboxes-linux
  jumpboxes-linux              = module.jumpbox.jumpboxes-linux
  nics-dbnodes-admin           = module.hdb_node.nics-dbnodes-admin
  nics-dbnodes-db              = module.hdb_node.nics-dbnodes-db
  loadbalancers                = module.hdb_node.loadbalancers
}
