/*
Parameters
*/
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

@description('Name of the Key Vault that contains the secret')
param keyVaultName string

@description('Name of the secret in the Key Vault')
param keyVaultSecretName string

/*
Local variables
*/
var accountName_var = toLower(accountName)

var roleDefinitionIdACI = guid('sql-role-definition-', principalIdACI, accountName_resource.id)
var roleAssignmentIdACI = guid(roleDefinitionIdACI, principalIdACI, accountName_resource.id)

/*
Existing Cosmos DB Account
*/
resource accountName_resource 'Microsoft.DocumentDB/databaseAccounts@2021-01-15' existing = {
  name: accountName_var
}

/*
Cosmos DB SQL Role assignment for Managed Identity
Will used the role definition of 00000000-0000-0000-0000-000000000002 which is the built-in role "Cosmos DB Account Contributor"
*/
resource sqlRoleAssignmentACI 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-04-15' = {
  name: '${accountName_resource.name}/${roleAssignmentIdACI}'
  properties: {
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.DocumentDB/databaseAccounts/${databaseName}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    principalId: principalIdACI
    scope: accountName_resource.id
  }
}

/*
Existing Cosmos DB Database
*/
resource accountName_databaseName 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-01-15' existing = {
  parent: accountName_resource
  name: databaseName
}

/*
Existing Cosmos DB Container
*/
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

/*
Cosmos DB Connection String Key Vault Secret
*/
resource kvSecretCosmosConnection 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: '${keyVaultName}/${keyVaultSecretName}'
  properties: {
    value: accountName_resource.listConnectionStrings().connectionStrings[0].connectionString
  }
}

/*
Outputs
*/
output cosmosDBUri string = accountName_resource.properties.documentEndpoint
