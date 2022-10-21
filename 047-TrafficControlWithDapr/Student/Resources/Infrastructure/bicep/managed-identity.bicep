param managedIdentityName string
param location string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

output managedIdentityName string = managedIdentity.name
output userAssignedManagedIdentityClientId string = managedIdentity.properties.clientId
