param managedIdentityName string
param location string
param tags object

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
  tags: tags
}

output managedIdentityName string = managedIdentity.name
