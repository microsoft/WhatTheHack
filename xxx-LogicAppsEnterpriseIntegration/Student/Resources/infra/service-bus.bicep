param serviceBusNamespaceName string
param location string
param tags object
param keyVaultName string
param managedIdentityName string

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: serviceBusNamespaceName
  tags: tags
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource serviceBusJsonTopic 'Microsoft.ServiceBus/namespaces/topics@2021-11-01' = {
  name: 'json-topic'
  parent: serviceBusNamespace
}

resource serviceBusStorageSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2021-11-01' = {
  name: 'storage-subscription'
  parent: serviceBusJsonTopic
}

resource serviceBusSqlSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2021-11-01' = {
  name: 'sql-subscription'
  parent: serviceBusJsonTopic
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

var endpoint = '${serviceBusNamespace.id}/AuthorizationRules/RootManageSharedAccessKey'

resource serviceBusNamespaceConnectionString 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'service-bus-connection-string'
  parent: keyVault
  properties: {
    value: 'Endpoint=sb://${serviceBusNamespace.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${listKeys(endpoint, serviceBusNamespace.apiVersion).primaryKey}'
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
}

resource serviceBusDataOwnerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '090c5cfd-751d-490a-894a-3ce6f1109419'
}

resource serviceBusDataOwnerRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: serviceBusNamespace
  name: guid(serviceBusNamespace.id, managedIdentity.name, serviceBusDataOwnerRoleDefinition.name)
  properties: {
    roleDefinitionId: serviceBusDataOwnerRoleDefinition.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

output serviceBusNamespaceName string = serviceBusNamespace.name
