/*
Parameters
*/
@description('The managed identity name')
param managedIdentityName string

@description('The deployment location')
param location string

/*
Managed Identity
*/
resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

/*
Outputs
*/
output managedIdentityPrincipalId string = msi.properties.principalId
output managedIdentityClientId string = msi.properties.clientId
output managedIdentityId string = msi.id
