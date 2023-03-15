# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"
#
# From PSH terminal in the directory for these files, run ".\challenge-04.ps1"

$location = 'eastus'
$resourceGroupName = '<me>-challenge-02-rg'
$deploymentName = '<me>-challenge-04-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

# Remove WhatIf for actual deployment
New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-04.bicep `
	-TemplateParameterFile ./challenge-04.parameters.json `
	-WhatIf

