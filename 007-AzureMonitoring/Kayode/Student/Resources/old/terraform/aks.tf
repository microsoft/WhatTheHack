################################################
##                                            ##
## Azure Key vault settings. Secret retreival ##
##                                            ##
################################################

data "azurerm_key_vault_secret" "aksvault" {
  name      = "${var.ssh_keyvault_secret_name}"
  vault_uri = "${var.keyvault_uri}"
}

data "azurerm_key_vault_secret" "aksspnsecret" {
  name      = "${var.spn_keyvault_secret_name}"
  vault_uri = "${var.keyvault_uri}"
}

resource "azurerm_resource_group" "aksrg" {
  name     = "${var.aks_resource_group}"
  location = "${var.location}"
}

################################################
##                                            ##
##        AKS cluster create                  ##
##                                            ##
################################################

resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.aksrg.location}"
  resource_group_name = "${azurerm_resource_group.aksrg.name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "${var.k8s_version}"

  linux_profile {
    admin_username = "${var.admin_user}"

    ssh_key {
      key_data = "${data.azurerm_key_vault_secret.aksvault.value}"
    }
  }

  agent_pool_profile {
    name            = "${var.agent_pool_name}"
    count           = "${var.agent_count}"
    vm_size         = "${var.vm_size}"         #"Standard_B2ms"
    os_type         = "Linux"
    os_disk_size_gb = 30
    vnet_subnet_id  = "${var.aks_subnetId}"

    #vnet_subnet_id  = # must be set if network_plugin, in network_profile block is "azure"; resourceid of subnet.
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.aksmon.id}"
    }

    /*http_application_routing {
      enabled                   = true
    } */
  }

  service_principal {
    client_id     = "${var.aks_arm_client_id}"
    client_secret = "${data.azurerm_key_vault_secret.aksspnsecret.value}"
  }

  network_profile {
    network_plugin     = "azure"
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.240.0.10"
    service_cidr       = "10.240.0.0/16"
  }

  tags {
    Enviornment = "Container Insights - AKS"
  }
}

################################################
##                                            ##
##      create NSG in Node RG                 ##
##                                            ##
################################################


/* resource "azurerm_network_security_group" "aks_nsg" {
  name      = "aks-agentpool-nsg"
  location            = "${azurerm_kubernetes_cluster.akscluster.location}"
  resource_group_name = "${azurerm_kubernetes_cluster.akscluster.node_resource_group}"

}

resource "azurerm_subnet_network_security_group_association" "nsg_to_aks_subnet" {
  subnet_id                 = "${var.aks_subnetId}"  #pending test with "${azurerm_kubernetes_cluster.akscluster.agent_pool_profile.0.vnet_subnet_id}"
  network_security_group_id = "${azurerm_network_security_group.aks_nsg.id}"
}
*/
/*    in case you need to associate subnet to routetable

 resource "azurerm_subnet_route_table_association" "nsg_to_aks_subnet" {
  subnet_id      = "${azurerm_subnet.test.id}"
  route_table_id = "${azurerm_route_table.test.id}"
}   */


# to login to aks
# rm -rf ~/.kube/
# az aks get-credentials --resource-group main-rg-hosting-aks --name your-aks-cluster-name
# kubectl get nodes

