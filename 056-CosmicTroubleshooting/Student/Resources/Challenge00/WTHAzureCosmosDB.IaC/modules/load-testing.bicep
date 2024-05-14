/*
Parameters
*/
@description('Resource location. Defaults to Resource Group location')
param location string = resourceGroup().location // Location for all resources

@description('Load Testing Service name')
param loadTestingName string

@description('Managed Identity principal id')
param managedIdentityPrincipalId string

/*
Load Testing Service
*/
resource loadtestingName_resource 'Microsoft.LoadTestService/loadTests@2022-12-01' = {
  name: loadTestingName
  location: location
}


/*
Load Testing role definition
*/
resource loadTestingcontributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  // This is the Azure Load Testing Contributor
  name: '749a398d-560b-491b-bb21-08924219302e'
}

/*
Role assignment - Managed Identity to Load Testing Service
*/
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, managedIdentityPrincipalId, loadTestingcontributorRoleDefinition.id)
  scope: loadtestingName_resource
  
  properties: {
    roleDefinitionId: loadTestingcontributorRoleDefinition.id
    principalId: managedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
}

/*
Outputs
*/
output loadtestingId string = loadtestingName_resource.id
output loadtestingNameDataPlaneUri string = loadtestingName_resource.properties.dataPlaneURI
