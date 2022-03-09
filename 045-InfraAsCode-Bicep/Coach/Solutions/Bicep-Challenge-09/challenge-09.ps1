$location = 'australiaeast'
$resourceGroupName = 'challenge-09-rg'
$deploymentName = 'challenge-09-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-09.bicep `
	-TemplateParameterFile ./challenge-09.parameters.json `
	-CustomScript $(Get-Content '../scripts/install-apache.sh' -Encoding UTF8 -Raw)
	