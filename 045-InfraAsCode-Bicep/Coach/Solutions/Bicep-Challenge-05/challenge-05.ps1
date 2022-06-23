$location = 'australiaeast'
$resourceGroupName = 'challenge-05-rg'
$deploymentName = 'challenge-05-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-05.bicep `
	-TemplateParameterFile ./challenge-05.parameters.json
