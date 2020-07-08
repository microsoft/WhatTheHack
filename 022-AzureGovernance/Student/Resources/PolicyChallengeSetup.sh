#Azure CLI commands to deploy the VMs used for the Azure Governance Policy Challenge

AdminPassword="MyP@ssW0rd!!!!"  #Update password and make sure it follows the Azure password policy

#Create Virtual Machine with unmanaged disk
VmName="unmanageddiskVm"

#Create Resource Group for unmanaged disk VM
ResourceGroupName="CreateVmunmanaged"
az group create --name $ResourceGroupName --location eastus

az vm create \
    --resource-group $ResourceGroupName \
    --name $VmName \
    --image win2016datacenter \
    --admin-username azureuser \
    --admin-password $AdminPassword \
    --size Basic_A1 \
    --use-unmanaged-disk \
    --storage-sku Standard_LRS

#Create Virtual Machine with managed disk
VmName="ADMIN-01"

#Create Resource Group for managed disk VM
ResourceGroupName="Contoso_IaaS"
az group create --name $ResourceGroupName --location eastus

az vm create \
    --resource-group $ResourceGroupName \
    --name $VmName \
    --image win2016datacenter \
    --admin-username azureuser \
    --admin-password $AdminPassword \
    --size Basic_A1 
  