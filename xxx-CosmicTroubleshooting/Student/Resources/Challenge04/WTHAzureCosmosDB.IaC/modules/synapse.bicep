param synapseWorkspaceName string
param adlsgen2name string
param location string
param sqlAdminLogin string
@secure()
param sqlAdminPassword string

var storageRoleUniqueId = guid(resourceId('Microsoft.Storage/storageAccounts', synapseWorkspaceName), adlsgen2name)
var storageBlobDataContributorRoleID = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

resource adlsgen2 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: adlsgen2name
  location: location
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: true
  }
  sku: {
    name: 'Standard_LRS'
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  name: '${adlsgen2.name}/default'
}

resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${adlsgen2.name}/default/data'
  dependsOn: [
    blob
  ]
}

resource synapse 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: synapseWorkspaceName
  location: location
  properties: {
    defaultDataLakeStorage: {
      accountUrl: format('https://{0}.dfs.core.windows.net', adlsgen2.name)
      filesystem: 'data'
    }
    sqlAdministratorLogin: sqlAdminLogin
    sqlAdministratorLoginPassword: sqlAdminPassword
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource synapseRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: storageRoleUniqueId
  scope: adlsgen2
  properties: {
    principalId: synapse.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleID)
  }
}

resource manageid4Pipeline 'Microsoft.Synapse/workspaces/managedIdentitySqlControlSettings@2021-06-01' = {
  name: 'default'
  properties: {
    grantSqlControlToManagedIdentity: {
      desiredState:'Enabled'
    }
  }
  parent:synapse
}
