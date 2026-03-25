var suffix = uniqueString('${subscription().subscriptionId}-${resourceGroup().name}')
// param monitors_NewRelicResource_GameDay_name string = 'NewRelicResource-GameDay'

var location = resourceGroup().location

param newRelicAccountId string
param newRelicOrganizationId string

module openai 'modules/foundry.bicep' = {
  name: 'foundryDeployment'
  params: {
    location: location
    name: 'foundry-gameday-wth-${suffix}'
  }
}

module newrelic 'modules/newrelic.bicep' = {
  name: 'newRelicDeployment'
  params: {
    // location: location
    // name: '${monitors_NewRelicResource_GameDay_name}-${suffix}'
    // newRelicAccountId: newRelicAccountId
    // newRelicOrganizationId: newRelicOrganizationId
  }
}
