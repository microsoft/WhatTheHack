$location = 'eastus'
$deploymentName = '<me>-challenge-20-deployment'
$resourceGroupName = '<me>-challenge-20-rg'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzSubscriptionDeployment `
	-Name $deploymentName `
	-TemplateFile ./challenge-20.bicep `
	-ResourceGroupName $resourceGroupName `
	-Location $location `
	-TemplateParameterFile ./challenge-20.parameters.json