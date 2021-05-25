aks_arm_client_id = "<Enter the SPN Application Id here>" # the SPN for AKS (its pwd is in VMPassword secret in kv)
la_workspace_name = "<Enter Log Analytics existing Workspace name here>"
la_resource_group = "<Enter Resourcegroup Name here>"
keyvault_uri = "https://<Keyvault Name here>.vault.azure.net/"
ssh_keyvault_secret_name = "sshkey-pub"
spn_keyvault_secret_name = "VMPassword"


#########################################
##                                     ##
##          AKS variables              ##
##                                     ##
#########################################

aks_resource_group = "<Enter Resourcegroup Name Here>-AKS"
location = "eastus"
cluster_name = "<Enter Resourcegroup Name Here>aksdemo"
k8s_version = "1.13.5"
dns_prefix = "<Enter Resourcegroup Name Here>aksdemo"
agent_count = 3
agent_pool_name = "<Enter Resourcegroup Name Here>tfaks"
admin_user = "demouser"
vm_size = "Standard_D2_v3"
aksvnet_resource_group ="<Enter Resourcegroup Name here>"
aksvnet ="<Enter Resourcegroup Name here>Vnet"
aks_subnetId = "/subscriptions/<Enter Subscription ID here>/resourceGroups/<Enter Resourcegroup Name Here>/providers/Microsoft.Network/virtualNetworks/<Enter Resourcegroup Name Here>Vnet/subnets/aksSubnetName"
