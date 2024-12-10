param capabilities array = [ { name: 'EnableServerless' } ] 
param containers array
param databaseName string
param keyvaultName string
param secretName string = 'cosmosdb-key'
param location string = resourceGroup().location
param name string
param tags object = {}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: name
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: location
      }
    ]
    capabilities: capabilities
  }
  tags: tags
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  parent: cosmosDb
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
  tags: tags
}

resource cosmosContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = [
  for container in containers: {
    parent: database
    name: container.name
    properties: {
      resource: {
        id: container.name
        partitionKey: {
          paths: [
            container.partitionKeyPath
          ]
          kind: 'Hash'
          version: 2
        }
        indexingPolicy: container.indexingPolicy
        vectorEmbeddingPolicy: container.vectorEmbeddingPolicy
      }
    }
    tags: tags
  }
]

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyvaultName
}

resource cosmosKey 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: secretName
  parent: keyvault
  tags: tags
  properties: {
    value: cosmosDb.listKeys().primaryMasterKey
  }
}

output endpoint string = cosmosDb.properties.documentEndpoint
output keySecretName string = cosmosKey.name
output keySecretRef string = cosmosKey.properties.secretUri
output name string = cosmosDb.name
