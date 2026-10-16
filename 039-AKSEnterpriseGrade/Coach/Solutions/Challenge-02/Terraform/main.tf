module "network" {
  source              = "Azure/network/azurerm"
  use_for_each        = false
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

resource "azurerm_log_analytics_workspace" "aks" {
  name                = "default-workspace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "aks" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  workspace_name        = azurerm_log_analytics_workspace.aks.name
  workspace_resource_id = azurerm_log_analytics_workspace.aks.id

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_role_assignment" "example" {
  principal_id                     = module.aks.kubelet_identity.object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.example.id
  skip_service_principal_aad_check = true
  depends_on                       = [module.aks]
}

# Grant AKS cluster access to use AKS subnet
resource "azurerm_role_assignment" "aks" {
  principal_id         = module.aks.identity_principal_id
  role_definition_name = "Network Contributor"
  scope                = module.network.vnet_subnets[0]
  depends_on           = [module.aks]
}

module "aks" {
  source    = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version   = "0.8.3"
  name      = coalesce(var.cluster_name, "default-aks")
  location  = azurerm_resource_group.example.location
  parent_id = azurerm_resource_group.example.id

  sku         = { name = "Base", tier = "Standard" }
  enable_rbac = true
  aad_profile = {
    managed                = true
    admin_group_object_ids = var.rbac_aad_admin_group_object_ids
  }
  addon_profile_azure_policy = { enabled = true }
  addon_profile_oms_agent = {
    enabled = true
    config  = { log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.aks.id }
  }
  network_profile = {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    dns_service_ip      = "10.0.0.10"
    service_cidr        = "10.0.0.0/16"
  }
  default_agent_pool = {
    name                  = "exnodepool"
    vm_size               = "Standard_D2s_v5"
    os_disk_size_gb       = 50
    enable_auto_scaling   = true
    min_count             = 1
    max_count             = 1
    max_pods              = 100
    availability_zones    = ["1", "2"]
    type                  = "VirtualMachineScaleSets"
    vnet_subnet_id        = module.network.vnet_subnets[0]
    node_labels           = { nodepool = "defaultnodepool" }
    tags                  = { Agent = "defaultnodepoolagent" }
  }
  ingress_profile = {
    gateway_api = { installation = "Standard" }
    web_app_routing = {
      enabled = true
      gateway_api_implementations = {
        app_routing_istio = { mode = "Enabled" }
      }
      nginx = { default_ingress_controller_type = "None" }
    }
  }

  dns_prefix = "default"

  depends_on = [module.network]
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

