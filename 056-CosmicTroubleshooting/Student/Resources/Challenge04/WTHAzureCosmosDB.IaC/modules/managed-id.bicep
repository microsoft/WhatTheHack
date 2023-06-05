/*
Parameters
*/

@description('The managed identity name')
param managedIdentityName string

@description('The deployment location')
param location string

/*
Resources
*/

/*
Managed Identity
*/
resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: managedIdentityName
  location: location
}


/*
Outputs
*/
output managedIdentityPrincipalId string = msi.properties.principalId
output managedIdentityClientId string = msi.properties.clientId
output managedIdentityId string = msi.id
