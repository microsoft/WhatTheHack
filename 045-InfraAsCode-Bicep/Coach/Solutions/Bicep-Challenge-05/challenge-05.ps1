# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"
#
# From PSH terminal in the directory for these files, run ".\challenge-05.ps1"

$location = 'eastus'
$resourceGroupName = '<me>-challenge-05-rg'
$deploymentName = '<me>-challenge-05-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

# Remove WhatIf for actual deployment
New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-05.bicep `
	-TemplateParameterFile ./challenge-05.parameters.json `
	-WhatIf
