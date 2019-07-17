#Login to Azure account
Login-AzureRmAccount

#List all subscripotions
Get-AzureRmSubscription

#Check which subscription is active
Get-AzureRmContext

#Set current subscription (to the one you'll operate in)
Set-AzureRmContext -SubscriptionName <yourSubNameNere>
#OR
Set-AzureRmContext -SubscriptionID <yourSubIdHere>

#Get a list of core quotas for a given region (important before you start deploying stuff)
# Note: If the quote is not high enough for you, you must open a support ticket in the portal!
Get-AzureRmVMUsage -Location eastus2 

#Get a list of available VM sizes in a region
Get-AzureRmVMSize -Location eastus2

#Get a list of top Windows & Linux VM images in the marketplace.
# Note the "offer", "sku", and "publisher" values. These values allow you to set the VM image used in an ARM template!
# az vm image list   <-- CLI version

Get-AzureRmVMImage
   -Location <String>
   -PublisherName <String>
   -Offer <String>
   -Skus <String>

#Get a list of VMs by various search queries
Get-AzureRmVmImageOffer -Location eastus2 -Publisher MicrosoftSqlServer
Get-AzureRmVmImageOffer -Location eastus2 -Publisher Oracle 


##Create Resource Group##

#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy

New-AzureRmResourceGroup -Name iac-rg -Location eastus2

##DEPLOY CHALLENGE FOUR##

 New-AzureRmResourceGroupDeployment -Name Challenge4Deployment -ResourceGroupName iac-rg `
 -TemplateFile challenge-04-windows-vm.json `
 -TemplateParameterFile .\challenge-04.parameters.json

 ##DEPLOY CHALLENGE FIVE##

 New-AzureRmResourceGroupDeployment -Name Challenge5Deployment -ResourceGroupName iac-rg `
 -TemplateFile challenge-05-simple-dsc.json `
 -TemplateParameterFile .\challenge-05.parameters.json


##DEPLOY CHALLENGE SIX##

 New-AzureRmResourceGroupDeployment -Name Challenge6Deployment -ResourceGroupName iac-rg `
 -TemplateFile challenge-06-file-server-dsc.json `
 -TemplateParameterFile .\challenge-06.parameters.json

##CLEAN UP!  Delete your Resource Group and everything in it!
 Remove-AzureRmResourceGroup -Name iac-rg