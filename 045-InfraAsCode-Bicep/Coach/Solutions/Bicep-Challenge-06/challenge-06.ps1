# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"
#
# From PSH terminal in the directory for these files, run ".\challenge-06.ps1"

$location = 'eastus'
$resourceGroupName = '<me>-challenge-06-rg'
$deploymentName = '<me>-challenge-06-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

# Remove WhatIf when actually deploying all resources
New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-06.bicep `
	-TemplateParameterFile ./challenge-06.parameters.json `
	-WhatIf
