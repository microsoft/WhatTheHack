$location = 'eastus'
$deploymentName = '<me>-challenge-21-deployment'
$resourceGroupName = '<me>-challenge-21-rg'

# generate ssh key; save in aks and aks.pub
ssh-keygen -f aks

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

New-AzSubscriptionDeployment `
	-Name $deploymentName `
	-TemplateFile ./challenge-21.bicep `
	-ResourceGroupName $resourceGroupName `
	-Location $location `
	-TemplateParameterFile ./challenge-21.parameters.json