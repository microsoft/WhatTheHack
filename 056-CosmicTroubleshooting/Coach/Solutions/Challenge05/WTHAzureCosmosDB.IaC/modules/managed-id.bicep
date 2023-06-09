@description('The managed identity name')
param managedIdentityName string

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
}

output managedIdentityPrincipalId string = msi.properties.principalId
output managedIdentityClientId string = msi.properties.clientId
output managedIdentityId string = msi.id
