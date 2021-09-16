$location = 'australiaeast'
$resourceGroupName = 'challenge-04-rg'
$deploymentName = 'challenge-04-deployment'

# running bicep build is currently required when deploying using PowerShell 
bicep build ./challenge-04.bicep

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-04.json `
	-TemplateParameterFile ./challenge-04.parameters.json
	