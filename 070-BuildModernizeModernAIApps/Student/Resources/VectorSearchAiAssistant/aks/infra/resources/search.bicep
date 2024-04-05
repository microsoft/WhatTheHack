param keyvaultName string
param location string = resourceGroup().location
param name string
param sku string
param tags object = {}

resource search 'Microsoft.Search/searchServices@2022-09-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'enabled'
    networkRuleSet: {
      ipRules: []
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {}
    }
  }
  tags: tags
}

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyvaultName
}

resource searchKey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'search-key'
  parent: keyvault
  tags: tags
  properties: {
    value: search.listAdminKeys().primaryKey
  }
}

output endpoint string = 'https://${search.name}.search.windows.net'
output keySecretName string = searchKey.name
output keySecretRef string = searchKey.properties.secretUri
output name string = search.name
