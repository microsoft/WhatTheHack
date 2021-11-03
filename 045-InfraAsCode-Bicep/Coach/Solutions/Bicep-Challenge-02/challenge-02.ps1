$location = 'australiaeast'
$resourceGroupName = 'challenge-02-rg'
$deploymentName = 'challenge-02-deployment'


New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-02.bicep `
	-containerName 'container1' `
	-globalRedundancy $true
