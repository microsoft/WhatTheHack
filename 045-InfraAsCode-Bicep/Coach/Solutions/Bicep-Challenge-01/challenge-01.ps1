$location = 'australiaeast'
$storageAccountName = 'add random chars to create a unique storage account name >=3 chars && <= 24 chars'
$resourceGroupName = 'challenge-01-rg'
$deploymentName = 'challenge-01-deployment'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-01.bicep `
	-location $location `
	-storageAccountName $storageAccountName
