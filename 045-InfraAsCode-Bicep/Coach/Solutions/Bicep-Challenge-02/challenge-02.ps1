# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"
#
# From PSH terminal in the directory for these files, run ".\challenge-01.ps1"

$location = 'eastus'
$resourceGroupName = '<me>-challenge-02-rg'
$deploymentName = '<me>-challenge-02-deployment'


New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-02.bicep `
	-containerName 'container1' `
	-globalRedundancy $true `
	-TemplateParameterFile ./challenge-02.parameters.json

