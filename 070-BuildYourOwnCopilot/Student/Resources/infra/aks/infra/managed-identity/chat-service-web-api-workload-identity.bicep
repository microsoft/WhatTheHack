param cosmosDbAccountName string
param keyvaultName string
param storageAccountName string
param managedIdentityName string
param federatedIdentityName string
param serviceAccountNamespace string = 'default'
param serviceAccountName string = 'chat-service-web-api'
param location string
param aksOidcIssuer string

@description('Custom tags to apply to the resources')
param tags object = {}

resource chatServiceApiManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

resource storageBlobAdminRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('ba92f5b4-2d11-453d-a403-e96b0029c9fe', chatServiceApiManagedIdentity.id, storage.id)
  scope: storage
  properties: {
    principalId: chatServiceApiManagedIdentity.properties.principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleAssignmentDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalType: 'ServicePrincipal'
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyvaultName
}

resource keyvaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2023-07-01' = {
  name: 'add'
  parent: keyvault
  properties: {
    accessPolicies: [
      {
        objectId: chatServiceApiManagedIdentity.properties.principalId
        permissions: { secrets: [ 'get', 'list' ] }
        tenantId: subscription().tenantId
      }
    ]
  }
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' existing = {
  name: cosmosDbAccountName
}

resource cosmosAccessRole 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-11-15' = {
  name: guid('00000000-0000-0000-0000-000000000002', chatServiceApiManagedIdentity.id, cosmosDb.id)
  parent: cosmosDb
  properties: {
    principalId: chatServiceApiManagedIdentity.properties.principalId
    roleDefinitionId: resourceId('Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions', cosmosDb.name, '00000000-0000-0000-0000-000000000002')
    scope: cosmosDb.id
  }
}

resource asoFederatedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {
  name: federatedIdentityName
  parent: chatServiceApiManagedIdentity
  properties: {
    audiences: [
      'api://AzureADTokenExchange'
    ]
    issuer: aksOidcIssuer
    subject: 'system:serviceaccount:${serviceAccountNamespace}:${serviceAccountName}'
  }
}

output managedIdentityPrincipalId string = chatServiceApiManagedIdentity.properties.principalId
output managedIdentityClientId string = chatServiceApiManagedIdentity.properties.clientId
