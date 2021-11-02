$location = 'australiaeast'
$resourceGroupName = 'challenge-07-rg'
$deploymentName = 'challenge-07-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-07.bicep `
	-TemplateParameterFile ./challenge-07.parameters.json `
	-CustomScript $(Get-Content '../scripts/install-apache.sh' -Encoding UTF8 -Raw)
