// Parameters

@description('Specifies a suffix used in Azure resource naming.')
@minLength(4)
@maxLength(10)
param suffix string = substring(uniqueString(resourceGroup().id), 0, 6)

@description('Specifies the location for all Azure resources.')
param location string = resourceGroup().location

@description('Specifies the Azure DocumentDB (Cosmos DB for MongoDB API) account name.')
param accountName string = ''

@description('Specifies the MongoDB database name to create.')
param databaseName string = 'sample_mflix'

@description('Enables free tier on the account. Only one free tier account is allowed per subscription.')
param freeTier bool = true

@description('Specifies tags for all resources.')
param tags object = {}

// Resources
resource documentDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: empty(accountName) ? toLower('mflix${suffix}') : accountName
  location: location
  kind: 'MongoDB'
  tags: tags
  properties: {
    databaseAccountOfferType: 'Standard'
    enableFreeTier: freeTier
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    capabilities: [
      {
        name: 'EnableMongo'
      }
    ]
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
  }
}

resource mongoDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2023-04-15' = {
  name: databaseName
  parent: documentDbAccount
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource mongoThroughput 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/throughputSettings@2023-04-15' = {
  name: 'default'
  parent: mongoDatabase
  properties: {
    resource: {
      throughput: 400
    }
  }
}

// Outputs
output deploymentInfo object = {
  subscriptionId: subscription().subscriptionId
  resourceGroupName: resourceGroup().name
  location: location
  accountName: documentDbAccount.name
  databaseName: mongoDatabase.name
}
