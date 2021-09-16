$location = 'australiaeast'
$resourceGroupName = 'challenge-02-rg'
$deploymentName = 'challenge-02-deployment'

# running bicep build is currently required when deploying using PowerShell 
bicep build ./challenge-02.bicep

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-02.json `
	-containerName 'container1' `
	-globalRedundancy $true
