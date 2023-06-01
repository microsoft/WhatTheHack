/*
Parameters
*/
@description('Cosmos DB account name, max length 44 characters, lowercase')
param accountName string

@description('Location for the Cosmos DB account.')
param location string = resourceGroup().location

@description('The primary replica region for the Cosmos DB account.')
param primaryRegion string

@description('The default consistency level of the Cosmos DB account.')
@allowed([
  'Eventual'
  'ConsistentPrefix'
  'Session'
  'BoundedStaleness'
  'Strong'
])
param defaultConsistencyLevel string = 'Session'

@description('Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 1000000. Multi Region: 100000 to 1000000.')
@minValue(10)
@maxValue(2147483647)
param maxStalenessPrefix int = 100000

@description('Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.')
@minValue(5)
@maxValue(86400)
param maxIntervalInSeconds int = 300

@description('Enable automatic failover for regions')
param automaticFailover bool = false

@description('The name for the database')
param databaseName string

@description('The name for the container')
param productsContainerName string

@description('The name for the container')
param shipmentContainerName string

@description('Throughput for the container')
param throughput int = 1000

@description('Partition key field')
param partKey string

@description('Object ID of the AAD identity. Must be a GUID.')
param principalIdWebApp string

/*
Local variables
*/
var consistencyPolicy = {
  Eventual: {
    defaultConsistencyLevel: 'Eventual'
  }
  ConsistentPrefix: {
    defaultConsistencyLevel: 'ConsistentPrefix'
  }
  Session: {
    defaultConsistencyLevel: 'Session'
  }
  BoundedStaleness: {
    defaultConsistencyLevel: 'BoundedStaleness'
    maxStalenessPrefix: maxStalenessPrefix
    maxIntervalInSeconds: maxIntervalInSeconds
  }
  Strong: {
    defaultConsistencyLevel: 'Strong'
  }
}
var locations = [
  {
    locationName: primaryRegion
    failoverPriority: 0
    isZoneRedundant: false
  }
]
var roleDefinitionIdWebApp = guid('sql-role-definition-', principalIdWebApp, accountName_resource.id)
var roleAssignmentIdWebApp = guid(roleDefinitionIdWebApp, principalIdWebApp, accountName_resource.id)

/*
Cosmos DB Account
*/
resource accountName_resource 'Microsoft.DocumentDB/databaseAccounts@2021-01-15' = {
  name: toLower(accountName)
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    consistencyPolicy: consistencyPolicy[defaultConsistencyLevel]
    locations: locations
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: automaticFailover
  }
}

/*
Cosmos DB SQL Role assignment for Managed Identity
Will used the role definition of 00000000-0000-0000-0000-000000000002 which is the built-in role "Cosmos DB Account Contributor"
*/
resource sqlRoleAssignmentWebApp 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-04-15' = {
  name: '${accountName_resource.name}/${roleAssignmentIdWebApp}'
  properties: {
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.DocumentDB/databaseAccounts/${databaseName}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    principalId: principalIdWebApp
    scope: accountName_resource.id
  }
}

/*
Cosmos DB Database
*/
resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-01-15' = {
  parent: accountName_resource
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

/*
Products container
*/
resource productsContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-01-15' = {
  parent: cosmosDbDatabase
  name: productsContainerName
  properties: {
    resource: {
      id: productsContainerName
      partitionKey: {
        paths: [
          '/${partKey}'
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
        ]
        excludedPaths: [
          {
            path: '/*'
          }
          {
            path: '/_etag/?'
          }
        ]
      }
    }
    options: {
      throughput: throughput
    }
  }
}

/*
Shipments container
*/
resource shipmentContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-01-15' = {
  parent: cosmosDbDatabase
  name: shipmentContainerName
  properties: {
    resource: {
      id: shipmentContainerName
      partitionKey: {
        paths: [
          '/type'
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
    options: {
      throughput: 400
    }
  }
}

/*
Outputs
*/
output accountEndpoint string = accountName_resource.properties.documentEndpoint
output connString string = accountName_resource.listConnectionStrings().connectionStrings[0].connectionString
