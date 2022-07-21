
module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = "10.52.0.0/16"
  subnet_prefixes     = ["10.52.0.0/24"]
  subnet_names        = ["subnet1"]
  depends_on          = [azurerm_resource_group.example]
  subnet_enforce_private_link_endpoint_network_policies = {
    "subnet1" : true
  }
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

# Grant AKS cluster access to use AKS subnet
resource "azurerm_role_assignment" "aks" {
  principal_id         = module.aks.system_assigned_identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = module.network.vnet_subnets[0]
  depends_on           = [module.aks]
}

module "aks" {
  source                           = "Azure/aks/azurerm"
  version                          = "4.16.0"
  resource_group_name              = azurerm_resource_group.example.name
  client_id                        = var.client_id
  client_secret                    = var.client_secret
  kubernetes_version               = "1.23.5"
  orchestrator_version             = "1.23.5"
  prefix                           = "default"
  cluster_name                     = var.cluster_name
  network_plugin                   = "azure"
  vnet_subnet_id                   = module.network.vnet_subnets[0]
  os_disk_size_gb                  = 50
  sku_tier                         = "Paid" # defaults to Free
  enable_role_based_access_control = true
  rbac_aad_admin_group_object_ids  = var.rbac_aad_admin_group_object_ids
  rbac_aad_managed                 = true
  private_cluster_enabled          = false
  enable_http_application_routing  = true
  enable_azure_policy              = true
  enable_auto_scaling              = true
  enable_host_encryption           = false
  agents_min_count                 = 1
  agents_max_count                 = 1
  agents_count                     = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                  = 100
  agents_pool_name                 = "exnodepool"
  agents_availability_zones        = ["1", "2"]
  agents_type                      = "VirtualMachineScaleSets"
  agents_size                      = "standard_dc2s_v2"

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  enable_ingress_application_gateway      = true
  ingress_application_gateway_name        = "aks-agw"
  ingress_application_gateway_subnet_cidr = "10.52.1.0/24"

  network_policy                 = "azure"
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "172.16.0.1/16"
  net_profile_service_cidr       = "10.0.0.0/16"

  depends_on = [module.network]
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}
