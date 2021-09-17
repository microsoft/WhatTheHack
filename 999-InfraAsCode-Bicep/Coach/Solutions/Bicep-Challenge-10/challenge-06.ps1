$location = 'australiaeast'
$resourceGroupName = 'challenge-06-rg'
$deploymentName = 'challenge-06-deployment'

# running bicep build is currently required when deploying using PowerShell 
bicep build ./challenge-06.bicep

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-06.json `
	-TemplateParameterFile ./challenge-06.parameters.json `
	-CloudInitScript $(Get-Content '../scripts/cloud-init.txt' -Encoding UTF8 -Raw)
	