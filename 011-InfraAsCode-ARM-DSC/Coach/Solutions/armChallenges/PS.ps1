##SETUP##


#Install Azure PowerShell 
#https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps?view=azurermps-4.4.1

Install-Module AzureRM -AllowClobber

#Login and set Azure Subscription
#https://blogs.msdn.microsoft.com/benjaminperkins/2017/08/02/how-to-set-azure-powershell-to-a-specific-azure-subscription/

Login-AzureRmAccount

Set-AzureRmContext -Subscription "<SUBSCRIPTION_NAME>" 


##DEPLOY CHALLENGE ONE##


#https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-deploy

New-AzureRmResourceGroup -Name P20-RG01 -Location eastus2

#With Inputs
New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG01 `
  -TemplateFile challenge-01-basic-output.json `
  -genericInput "Hello World"

 #With Parameters File
 New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG01 `
 -TemplateFile challenge-01-basic-output.json `
 -TemplateParameterFile .\challenge-01.parameters.json


 ##DEPLOY CHALLENGE TWO##


 #With Inputs
  New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG01 `
  -TemplateFile challenge-02-vnet-one-subnet.json `
  -vnetName "P20VNet" `
  -vnetPrefix "10.0.0.0/16" `
  -subnetName "Default" `
  -subnetPrefix "10.0.0.0/24"

  #With Parameters File
  New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG01 `
  -TemplateFile challenge-02-vnet-one-subnet.json `
  -TemplateParameterFile .\challenge-02.parameters.json


 ##DEPLOY CHALLENGE THREE##


 #With Parameters File
 New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG01 `
 -TemplateFile challenge-03-vnet-with-nsg.json `
 -TemplateParameterFile .\challenge-03.parameters.json


##DEPLOY CHALLENGE FOUR##


#Reference - https://github.com/Azure/azure-quickstart-templates/blob/052db5feeba11f85d57f170d8202123511f72044/apache2-on-ubuntu-vm/azuredeploy.json

#With Parameters File
New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG01 `
  -TemplateFile challenge-04-web-server.json `
  -TemplateParameterFile .\challenge-04.parameters.json


##DEPLOY CHALLENGE FIVE##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/052db5feeba11f85d57f170d8202123511f72044/201-2-vms-loadbalancer-lbrules

#With Parameters File
New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG01 `
  -TemplateFile challenge-05-load-balanced-web-server.json `
  -TemplateParameterFile .\challenge-05.parameters.json


##DEPLOY CHALLENGE SIX##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/052db5feeba11f85d57f170d8202123511f72044/101-loadbalancer-with-nat-rule

#With Parameters File
New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG01 `
  -TemplateFile challenge-06-load-balanced-nat-rule.json `
  -TemplateParameterFile .\challenge-06.parameters.json
  

##DEPLOY CHALLENGE SEVEN##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/21c1bf4e90a49e431c85384251e35934bce2a7f4/201-vmss-linux-nat

#With Parameters File
New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG02 `
-TemplateFile challenge-07-vmss-linux.json `
-TemplateParameterFile .\challenge-07.parameters.json


##DEPLOY CHALLENGE EIGHT##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/21c1bf4e90a49e431c85384251e35934bce2a7f4/201-vmss-lapstack-autoscale

#With Parameters File
New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG02 `
-TemplateFile challenge-08-vmss-apache.json `
-TemplateParameterFile .\challenge-08.parameters.json


##DEPLOY CHALLENGE NINE##


#Reference - https://github.com/Azure/azure-quickstart-templates/tree/21c1bf4e90a49e431c85384251e35934bce2a7f4/201-vmss-lapstack-autoscale

#With Parameters File
New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG02 `
-TemplateFile challenge-09-vmss-autoscale.json `
-TemplateParameterFile .\challenge-09.parameters.json


##DEPLOY CHALLENGE TEN##


#Reference - 

#With Parameters File
New-AzureRmResourceGroupDeployment -Name P20Deployment -ResourceGroupName P20-RG03 `
-TemplateFile challenge-10-p20-main.json `
-TemplateParameterFile .\challenge-10.parameters.json