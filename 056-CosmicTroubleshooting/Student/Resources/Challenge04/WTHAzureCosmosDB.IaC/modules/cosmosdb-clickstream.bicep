@description('Cosmos DB account name, max length 44 characters, lowercase')
param accountName string

@description('The name for the database')
param databaseName string

@description('The name for the container')
param containerName string

@description('Throughput for the container')
param throughput int = 400

@description('Partition key field')
param partKey string

@description('Object ID of the AAD identity. Must be a GUID.')
param principalIdACI string

param keyVaultName string
param keyVaultSecretName string

///////////////////////////////
// Variables
///////////////////////////////
var accountName_var = toLower(accountName)

var roleDefinitionIdACI = guid('sql-role-definition-', principalIdACI, accountName_resource.id)
var roleAssignmentIdACI = guid(roleDefinitionIdACI, principalIdACI, accountName_resource.id)

resource accountName_resource 'Microsoft.DocumentDB/databaseAccounts@2021-01-15' existing = {
  name: accountName_var
}

resource sqlRoleAssignmentACI 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-04-15' = {
  name: '${accountName_resource.name}/${roleAssignmentIdACI}'
  properties: {
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.DocumentDB/databaseAccounts/${databaseName}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    principalId: principalIdACI
    scope: accountName_resource.id
  }
}

resource accountName_databaseName 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-01-15' existing = {
  parent: accountName_resource
  name: databaseName
}

resource accountName_databaseName_containerName 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-01-15' = {
  parent: accountName_databaseName
  name: containerName
  properties: {
    resource: {
      id: containerName
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

resource kvSecretCosmosConnection 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: '${keyVaultName}/${keyVaultSecretName}'
  properties: {
    value: accountName_resource.listConnectionStrings().connectionStrings[0].connectionString
  }
}


output cosmosDBUri string = accountName_resource.properties.documentEndpoint
