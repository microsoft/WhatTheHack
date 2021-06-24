#output "aks-is-reporting-to-LogAnalytics-workspace" {
#  value = "${azurerm_kubernetes_cluster.akscluster.addon_profile}"
#}
/*
output "client_key" {
  value = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.client_key}"
}

output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.cluster_ca_certificate}"
}

output "cluster_username" {
  value = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.username}"
}

output "cluster_password" {
  value = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.password}"
}
*/

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.akscluster.kube_config_raw}"
}

output "host" {
  value = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.host}"
}

output "aksclusterprofile" {
  value = {
    network_profile           = "${azurerm_kubernetes_cluster.akscluster.network_profile}"
    AKS-LogAnalyticsWorkspace = "${azurerm_kubernetes_cluster.akscluster.addon_profile}"
    agent_pool_Profile        = "${azurerm_kubernetes_cluster.akscluster.agent_pool_profile}"
  }
}

output "configure" {
  value = <<CONFIGURE

Run the following commands to configure kubernetes client:

$ terraform output kube_config > ~/.kube/aksconfig
$ export KUBECONFIG=~/.kube/aksconfig

Test configuration using kubectl

$ kubectl get nodes
CONFIGURE
}

/*
output "NSG and subnets" {
  value ={
    NSGID-nsgassociation = "${azurerm_subnet_network_security_group_association.nsg_to_aks_subnet.network_security_group_id}"
    SubNetID-NSGassociation = "${azurerm_subnet_network_security_group_association.nsg_to_aks_subnet.subnet_id}"
    NSGIDfromNSG = "${azurerm_network_security_group.aks_nsg.id}"
    subnetIdFromAgentPool= "${azurerm_kubernetes_cluster.akscluster.agent_pool_profile.0.vnet_subnet_id}"
  }
}
*/

