##SETUP##

#Install Azure CLI
#https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

#Login and set Azure Subscription

az login

#Get list of all Azure subscriptions current logged in user has access to.
# Note which one has IsDefault=True to know which subscription the Azure CLI will be executing against!
az account list

#If the account you want is NOT the default, then you can set the one you want
az account set --subscription "<SUBSCRIPTION_NAME>" OR "<subscriptionID>"

#Get a list of core quotas for a given region (important before you start deploying stuff)
# Note: If the quote is not high enough for you, you must open a support ticket in the portal!
az vm list-usage -l eastus2

#Get a list of available VM sizes in a region
az vm list-sizes -l eastus2

#Get a list of top Windows & Linux VM images in the marketplace.
# Note the "offer", "sku", and "publisher" values. These values allow you to set the VM image used in an ARM template!
az vm image list

#Get a list of VMs by various search queries
az vm image list --publisher Oracle -l eastus2 --all  
az vm image list --publisher MicrosoftSQLServer -l eastus2 --all 

#Create a resource group
az group create --name iac-rg --location eastus2

#Deploy templates to a resource group via Azure CLI
#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy-cli

##DEPLOY CHALLENGE FOUR##
az group deployment create --name Challenge4Deployment --resource-group iac-rg --template-file challenge-04-windows-vm.json --parameters @challenge-04.parameters.json

##DEPLOY CHALLENGE FIVE#
az group deployment create --name Challenge5Deployment --resource-group iac-rg --template-file challenge-05-simple-dsc.json --parameters @challenge-05.parameters.json

##DEPLOY CHALLENGE SIX##
az group deployment create --name Challenge6Deployment --resource-group iac-rg --template-file challenge-06-file-server-dsc.json --parameters @challenge-06.parameters.json

##Clean up
az group delete --name iac-rg

