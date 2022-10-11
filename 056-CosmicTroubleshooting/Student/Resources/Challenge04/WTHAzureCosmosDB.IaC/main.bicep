@description('The name for the database')
param databaseName string

@description('The name for the container')
param containerName string

@description('Partition key field')
param partKey string

@description('Location where resources will be deployed. Defaults to resource group location.')
param location string

@description('Location where resources will be deployed. Defaults to resource group location.')
param resourceGroupName string

targetScope = 'subscription'

var uniquePostfix = uniqueString(rg.id)
var aciName = toLower('aci-${uniquePostfix}')
var cosmosDBSecretName = 'cosmosDBConnectionString'
var keyVaultName = 'kv-${uniquePostfix}'
var cosmosdbaccountname = 'cosmosdb-sql-${uniquePostfix}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module msiACI 'modules/managed-id.bicep' = {
  name: 'msiACIDeploy'
  params: {
    location: location
    managedIdentityName: 'msi-${aciName}'
  }
  scope: rg
}

module cosmosDb 'modules/cosmosdb-clickstream.bicep' = {
  name: 'cosmosDBDeploy'
  dependsOn: [
    msiACI
    kv
  ]
  params: {
    containerName: containerName
    databaseName: databaseName
    partKey: partKey
    principalIdACI: msiACI.outputs.managedIdentityPrincipalId
    keyVaultSecretName: cosmosDBSecretName
    keyVaultName: keyVaultName
    accountName: cosmosdbaccountname
  }
  scope: rg
}

module aci 'modules/aci.bicep' = {
  name: 'aciDeploy'
  dependsOn: [
    cosmosDb
  ]
  params: {
    name: aciName
    location: location
    msiObjectId: msiACI.outputs.managedIdentityId
    akvVaultUri: kv.outputs.kvUri
    cosmosDBAccountUri: cosmosDb.outputs.cosmosDBUri
    cosmosDBContainerName: containerName
    cosmosDBDatabaseName: databaseName
  }
  scope: rg
}

module kv 'modules/keyvault.bicep' = {
  name: 'kvDeploy'
  params: {
    name: keyVaultName
    msiObjectId: msiACI.outputs.managedIdentityPrincipalId
  }
  scope: rg
}
