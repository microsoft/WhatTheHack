##SETUP##
#change

#Install Azure CLI
#https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

#Login and set Azure Subscription

az login

az account set --subscription "<SUBSCRIPTION_NAME>" 


##DEPLOY CHALLENGE ONE##


#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy-cli

az group create --name IAC-RG01 --location "eastus2"

#With Inputs
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG01 \
    --template-file challenge-01-basic-output.json \
    --parameters genericInput="Hello World"

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG01 \
    --template-file challenge-01-basic-output.json \
    --parameters challenge-01.parameters.json


##DEPLOY CHALLENGE TWO##


#With Inputs
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG01 \
    --template-file challenge-02-vnet-one-subnet.json \
    --parameters vnetName="IACVNet" vnetPrefix="10.0.0.0/16" subnetName="Default" subnetPrefix="10.0.0.0/24"

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG01 \
    --template-file challenge-02-vnet-one-subnet.json \
    --parameters challenge-02.parameters.json


##DEPLOY CHALLENGE THREE##


#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG01 \
    --template-file challenge-03-vnet-with-nsg.json \
    --parameters challenge-03.parameters.json


##DEPLOY CHALLENGE FOUR##


#Reference - https://github.com/Azure/azure-quickstart-templates/blob/052db5feeba11f85d57f170d8202123511f72044/apache2-on-ubuntu-vm/azuredeploy.json

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG01 \
    --template-file challenge-04-web-server.json \
    --parameters challenge-04.parameters.json


##DEPLOY CHALLENGE FIVE##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/052db5feeba11f85d57f170d8202123511f72044/201-2-vms-loadbalancer-lbrules

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG01 \
    --template-file challenge-05-load-balanced-web-server.json \
    --parameters challenge-05.parameters.json


##DEPLOY CHALLENGE SIX##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/052db5feeba11f85d57f170d8202123511f72044/101-loadbalancer-with-nat-rule

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG01 \
    --template-file challenge-06-load-balanced-nat-rule.json \
    --parameters challenge-06.parameters.json
    

##DEPLOY CHALLENGE SEVEN##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/21c1bf4e90a49e431c85384251e35934bce2a7f4/201-vmss-linux-nat

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG02 \
    --template-file challenge-07-vmss-linux.json \
    --parameters challenge-07.parameters.json


##DEPLOY CHALLENGE EIGHT##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/21c1bf4e90a49e431c85384251e35934bce2a7f4/201-vmss-lapstack-autoscale

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG02 \
    --template-file challenge-08-vmss-apache.json \
    --parameters challenge-08.parameters.json


##DEPLOY CHALLENGE NINE##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/21c1bf4e90a49e431c85384251e35934bce2a7f4/201-vmss-lapstack-autoscale

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG02 \
    --template-file challenge-09-vmss-autoscale.json \
    --parameters challenge-09.parameters.json


##DEPLOY CHALLENGE TEN##


#Reference - 

#With Parameters File
az group deployment create \
    --name IACDeployment \
    --resource-group IAC-RG03 \
    --template-file challenge-10-p20-main.json \
    --parameters challenge-10.parameters.json