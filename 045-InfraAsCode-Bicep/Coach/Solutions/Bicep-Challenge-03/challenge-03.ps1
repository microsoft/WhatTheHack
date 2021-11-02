$location = 'australiaeast'
$resourceGroupName = 'challenge-02-rg'
$deploymentName = 'challenge-03-deployment'
$storageAccountName = '<name of existing storage account>'

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-03.bicep `
	-storageAccountName $storageAccountName `
	-containers 'container2', 'container3', 'container4'
