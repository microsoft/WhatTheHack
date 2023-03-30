$location = 'eastus'
$deploymentName = '<me>-challenge-12-deployment'
$resourceGroupName = '<me>-challenge-12-rg'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzSubscriptionDeployment `
	-Name $deploymentName `
	-TemplateFile ./challenge-12.bicep `
	-ResourceGroupName $resourceGroupName `
	-Location $location `
	-TemplateParameterFile ./challenge-12.parameters.json