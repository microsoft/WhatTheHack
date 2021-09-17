$location = 'australiaeast'
$resourceGroupName = 'challenge-08-rg'
$deploymentName = 'challenge-08-deployment'

# running bicep build is currently required when deploying using PowerShell 
bicep build ./challenge-08.bicep

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-08.json `
	-TemplateParameterFile ./challenge-08.parameters.json
	