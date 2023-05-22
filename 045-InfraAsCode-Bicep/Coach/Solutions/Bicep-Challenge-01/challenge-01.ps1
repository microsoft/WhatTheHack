# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"
#
# From PSH terminal in the directory for these files, run ".\challenge-01.ps1"

$location = 'eastus'
$storageAccountName = '<me>ch01'
$resourceGroupName = '<me>-challenge-01-rg'
$deploymentName = '<me>-challenge-01-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

# The -WhatIf is added to allow you to see the outcomes of the BICEP deployment.
# Remove it along with the previous lines ` mark to actually deploy the resources
New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-01.bicep `
	-location $location `
	-storageAccountName $storageAccountName `
	-WhatIf
