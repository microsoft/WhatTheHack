$location = 'australiaeast'
$resourceGroupName = 'challenge-08-rg'
$deploymentName = 'challenge-08-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-08.bicep `
	-TemplateParameterFile ./challenge-08.parameters.json
	