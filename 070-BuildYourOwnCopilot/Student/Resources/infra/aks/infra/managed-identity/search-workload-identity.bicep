param managedIdentityName string
param federatedIdentityName string
param serviceAccountNamespace string = 'default'
param serviceAccountName string = 'search'
param location string
param aksOidcIssuer string

@description('Custom tags to apply to the resources')
param tags object = {}

resource searchManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}

resource asoFederatedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {
  name: federatedIdentityName
  parent: searchManagedIdentity
  properties: {
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: aksOidcIssuer
    subject: 'system:serviceaccount:${serviceAccountNamespace}:${serviceAccountName}'
  }
}

output managedIdentityPrincipalId string = searchManagedIdentity.properties.principalId
output managedIdentityClientId string = searchManagedIdentity.properties.clientId
