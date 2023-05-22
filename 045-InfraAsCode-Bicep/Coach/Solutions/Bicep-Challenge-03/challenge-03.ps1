# If self-deploying the challenges, recommend adding a prefix to Azure resources.
# For example, resourceGroupName = "<my initials>-challenge-01-rg"
#
# From PSH terminal in the directory for these files, run ".\challenge-01.ps1"
#
# In challenge 3, new containers are added to the storage account created in Challenge 2.

$resourceGroupName = '<me>-challenge-02-rg'
$deploymentName = '<me>-challenge-03-deployment'
$storageAccountName = '<storage account name from challenge 2>'

New-AzResourceGroupDeployment `
	-Name $deploymentName `
	-ResourceGroupName $resourceGroupName `
	-TemplateFile ./challenge-03.bicep `
	-storageAccountName $storageAccountName `
	-containers 'container2', 'container3', 'container4' `
