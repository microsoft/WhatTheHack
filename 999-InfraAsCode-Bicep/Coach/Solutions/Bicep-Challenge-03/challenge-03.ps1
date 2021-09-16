$location = 'australiaeast'
$resourceGroupName = 'challenge-02-rg'
$deploymentName = 'challenge-03-deployment'
$storageAccountName = '<name of existing storage account>'

# running bicep build is currently required when deploying using PowerShell 
bicep build ./challenge-03.bicep

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-03.json `
	-storageAccountName $storageAccountName `
	-containers 'container2', 'container3', 'container4'
