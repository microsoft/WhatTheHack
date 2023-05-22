$location = 'eastus'
$deploymentName = '<me>-challenge-13-deployment'
$resourceGroupName = '<me>-challenge-13-rg'

# generate ssh key; save in aks and aks.pub
ssh-keygen -f aks

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzSubscriptionDeployment `
	-Name $deploymentName `
	-TemplateFile ./challenge-13.bicep `
	-ResourceGroupName $resourceGroupName `
	-Location $location `
	-TemplateParameterFile ./challenge-13.parameters.json