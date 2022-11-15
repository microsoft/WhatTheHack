param location string = resourceGroup().location // Location for all resources
param loadTestingName string

param managedIdentityPrincipalId string

resource loadtestingName_resource 'Microsoft.LoadTestService/loadtests@2022-04-15-preview' = {
  name: loadTestingName
  location: location
}



resource loadTestingcontributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  // This is the Azure Load Testing Contributor
  name: '749a398d-560b-491b-bb21-08924219302e'
}

// add MSI access to loadtesting service
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, managedIdentityPrincipalId, loadTestingcontributorRoleDefinition.id)
  scope: loadtestingName_resource
  
  properties: {
    roleDefinitionId: loadTestingcontributorRoleDefinition.id
    principalId: managedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
}


output loadtestingId string = loadtestingName_resource.id
output loadtestingNameDataPlaneUri string = loadtestingName_resource.properties.dataPlaneURI
