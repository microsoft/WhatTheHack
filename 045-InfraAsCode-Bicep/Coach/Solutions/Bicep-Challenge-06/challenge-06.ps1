$location = 'australiaeast'
$resourceGroupName = 'challenge-06-rg'
$deploymentName = 'challenge-06-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-06.bicep `
	-TemplateParameterFile ./challenge-06.parameters.json
