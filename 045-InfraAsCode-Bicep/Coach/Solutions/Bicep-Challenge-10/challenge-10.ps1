$location = 'australiaeast'
$resourceGroupName = 'challenge-10-rg'
$deploymentName = 'challenge-10-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-10.bicep `
	-TemplateParameterFile ./challenge-10.parameters.json `
	-CloudInitScript $(Get-Content '../scripts/cloud-init.txt' -Encoding UTF8 -Raw)
	