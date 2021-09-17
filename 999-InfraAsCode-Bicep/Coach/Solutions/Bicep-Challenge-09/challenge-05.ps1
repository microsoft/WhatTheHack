$location = 'australiaeast'
$resourceGroupName = 'challenge-05-rg'
$deploymentName = 'challenge-05-deployment'

# running bicep build is currently required when deploying using PowerShell 
bicep build ./challenge-05.bicep

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-05.json `
	-TemplateParameterFile ./challenge-05.parameters.json `
	-CustomScript $(Get-Content '../scripts/install-apache.sh' -Encoding UTF8 -Raw)
	