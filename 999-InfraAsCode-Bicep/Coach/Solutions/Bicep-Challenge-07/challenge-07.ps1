$location = 'eastus'
$deploymentName = 'challenge-07-deployment'


New-AzSubscriptionDeployment `
	-Name $deploymentName `
	-TemplateFile ./challenge-07.bicep `
	-Location $location `
	-TemplateParameterFile ./challenge-07.parameters.json