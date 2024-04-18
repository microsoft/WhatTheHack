@description('The name of the Azure CosmosDB.')
param name string

@description('Location where the Azure CosmosDB will be created.')
param location string

@description('List of containers to create in the Azure Cosmos DB.')
param containers array = []

resource account 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: name
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Strong'
      maxStalenessPrefix: 1
      maxIntervalInSeconds: 5
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: true
    capabilities: []
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  parent: account
  name: name
  properties: {
    resource: {
      id: name
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = [for container in containers: {
  parent: database
  name: container.name
  properties: {
    resource: {
      id: container.name
      partitionKey: {
        paths: [
          container.partitionKey
        ]
        kind: 'hash'
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
            indexes: [
              {
                kind: 'Hash'
                dataType: 'String'
                precision: -1
              }
            ]
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
    }
    options: {}
  }
}]

output primaryMasterKey string = account.listKeys().primaryMasterKey
output uri string = account.properties.documentEndpoint
