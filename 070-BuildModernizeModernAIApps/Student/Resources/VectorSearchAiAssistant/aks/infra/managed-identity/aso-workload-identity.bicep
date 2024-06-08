param managedIdentityName string
param federatedIdentityName string
param serviceAccountNamespace string = 'azureserviceoperator-system'
param serviceAccountName string = 'azureserviceoperator-default'
param location string
param aksOidcIssuer string

@description('Custom tags to apply to the resources')
param tags object = {}

resource asoManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}

resource asoFederatedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {
  name: federatedIdentityName
  parent: asoManagedIdentity
  properties: {
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: aksOidcIssuer
    subject: 'system:serviceaccount:${serviceAccountNamespace}:${serviceAccountName}'
  }
}

output managedIdentityPrincipalId string = asoManagedIdentity.properties.principalId
output managedIdentityClientId string = asoManagedIdentity.properties.clientId
