param managedIdentityName string
param federatedIdentityName string
param serviceAccountNamespace string = 'kube-system'
param serviceAccountName string = 'keda-operator'
param location string
param aksOidcIssuer string

@description('Custom tags to apply to the resources')
param tags object = {}

resource kedaManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}

resource kedaFederatedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {
  name: federatedIdentityName
  parent: kedaManagedIdentity
  properties: {
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: aksOidcIssuer
    subject: 'system:serviceaccount:${serviceAccountNamespace}:${serviceAccountName}'
  }
}

output managedIdentityPrincipalId string = kedaManagedIdentity.properties.principalId
output managedIdentityClientId string = kedaManagedIdentity.properties.clientId

