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

param sqlAdminLogin string
@secure()
param sqlAdminPassword string

targetScope = 'subscription'

var uniquePostfix = uniqueString(rg.id)
var aciName = toLower('aci-${uniquePostfix}')
var cosmosDBSecretName = 'cosmosDBConnectionString'
var keyVaultName = 'kv-${uniquePostfix}'
var adlsGen2Name = toLower('adlsg2${uniquePostfix}')
var synapsewsname = 'synapse-${uniquePostfix}'
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
    location: location
    containerName: containerName
    databaseName: databaseName
    partKey: partKey
    primaryRegion: location
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
    location: location
    msiObjectId: msiACI.outputs.managedIdentityPrincipalId
  }
  scope: rg
}

module synapse 'modules/synapse.bicep' = {
  name: 'synapseDeploy'
  params: {
    adlsgen2name: adlsGen2Name
    location: location
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
    synapseWorkspaceName: synapsewsname
  }
  scope: rg
}
