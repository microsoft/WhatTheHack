$location = 'australiaeast'
$resourceGroupName = 'challenge-02-rg'
$deploymentName = 'challenge-04-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-04.bicep `
	-TemplateParameterFile ./challenge-04.parameters.json
