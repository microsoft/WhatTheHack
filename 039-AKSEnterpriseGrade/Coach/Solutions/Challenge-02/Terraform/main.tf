module "network" {
  source  = "Azure/subnets/azurerm"
  version = "1.0.0"

  resource_group_name = azurerm_resource_group.example.name
  subnets = {
    subnet1 = {
      address_prefixes                          = ["10.52.0.0/24"]
      private_endpoint_network_policies_enabled = true
      service_endpoints                         = ["Microsoft.Storage"]
    }
  }
  virtual_network_address_space = ["10.52.0.0/16"]
  virtual_network_location      = azurerm_resource_group.example.location
  virtual_network_name          = "subnet1"
}

resource "azurerm_container_registry" "example" {
  name                = random_string.random.result
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "example" {
  principal_id                     = module.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.example.id
  skip_service_principal_aad_check = true
  depends_on                       = [module.aks]
}

module "aks" {
  source                            = "Azure/aks/azurerm"
  version                           = "8.0.0"
  resource_group_name               = azurerm_resource_group.example.name
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  kubernetes_version                = "1.29.2"
  orchestrator_version              = "1.29.2"
  prefix                            = "default"
  cluster_name                      = var.cluster_name
  network_plugin                    = "azure"
  vnet_subnet_id                    = module.network.vnet_subnets_name_id["subnet1"]
  os_disk_size_gb                   = 50
  sku_tier                          = "Standard"
  role_based_access_control_enabled = true
  rbac_aad_admin_group_object_ids   = var.rbac_aad_admin_group_object_ids
  rbac_aad_managed                  = true
  private_cluster_enabled           = false
  web_app_routing                   = { dns_zone_id = "" }
  enable_auto_scaling               = true
  enable_host_encryption            = false
  agents_min_count                  = 1
  agents_max_count                  = 1
  agents_count                      = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                   = 100
  agents_pool_name                  = "exnodepool"
  agents_availability_zones         = ["1", "2"]
  agents_type                       = "VirtualMachineScaleSets"
  agents_size                       = "standard_dc2s_v2"

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  network_policy             = "azure"
  net_profile_dns_service_ip = "10.0.0.10"
  net_profile_service_cidr   = "10.0.0.0/16"

  # Grant AKS cluster access to use AKS subnet
  network_contributor_role_assigned_subnet_ids = { "subnet1" = module.network.vnet_subnets_name_id["subnet1"] }

  depends_on = [module.network]
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}
