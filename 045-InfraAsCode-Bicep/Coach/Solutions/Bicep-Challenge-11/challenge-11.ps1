$location = 'eastus'
$deploymentName = 'challenge-11-deployment'


New-AzSubscriptionDeployment `
	-Name $deploymentName `
	-TemplateFile ./challenge-11.bicep `
	-Location $location `
	-TemplateParameterFile ./challenge-11.parameters.json