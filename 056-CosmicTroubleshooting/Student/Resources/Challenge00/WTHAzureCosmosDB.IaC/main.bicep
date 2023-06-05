/*
Parameters
*/
@description('The name for the web app')
param webAppName string

@description('The name for the database')
param databaseName string

@description('The name for the container')
param productsContainerName string

@description('The name for the container')
param shipmentContainerName string

@description('The name for the proxy func app')
param proxyFuncAppName string

@description('Partition key field name')
param partKey string

@description('Location where resources will be deployed. Defaults to resource group location.')
param location string

@description('Location where resources will be deployed. Defaults to resource group location.')
param resourceGroupName string

/*
Deployment target scope
*/
targetScope = 'subscription'

/*
Local variables
*/
var uniquePostfix = uniqueString(rg.id)
var appServicePlanName = toLower('appsp-${webAppName}-${uniquePostfix}')
var webSiteName = toLower('web-${webAppName}-${uniquePostfix}')
var appInsightsName = toLower('appins-${webAppName}-${uniquePostfix}')
var cosmosdbaccountname = 'cosmosdb-sql-${uniquePostfix}'
var loadTestingName = toLower('loadtesting-${webAppName}-${uniqueString(rg.id)}')
var proxyFuncName = toLower('backend-${proxyFuncAppName}-${uniquePostfix}')
var keyVaultName = 'kv-${uniquePostfix}'
var keyVaultFuncAppSecretName = 'proxy-func-key'

/*
Resource Group
*/
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

/*
Managed Identity for App Service
*/
module msiAppPlan 'modules/managed-id.bicep' = {
  name: 'msiAppPlanDeploy'
  params: {
    location: location
    managedIdentityName: 'msi-${webSiteName}'
  }
  scope: rg
}

/*
Cosmos DB account and containers
*/
module cosmosDb 'modules/cosmosdb-products.bicep' = {
  name: 'cosmosDBDeploy'
  dependsOn: [
    msiAppPlan
  ]
  params: {
    location: location
    productsContainerName: productsContainerName
    shipmentContainerName: shipmentContainerName
    databaseName: databaseName
    partKey: partKey
    primaryRegion: location
    principalIdWebApp: msiAppPlan.outputs.managedIdentityPrincipalId
    accountName: cosmosdbaccountname
  }
  scope: rg
}

/*
Azure Web App
*/
module appPlan 'modules/webapp.bicep' = {
  name: 'webAppDeploy'
  dependsOn: [
    msiAppPlan, proxyFunctionApp, kv
  ]
  params: {
    location: location
    appInsightsName: appInsightsName
    appServicePlanName: appServicePlanName
    webSiteName: webSiteName
    msiObjectId: msiAppPlan.outputs.managedIdentityId
    msiClientId: msiAppPlan.outputs.managedIdentityClientId
    cosmosDBAccountEndpoint: cosmosDb.outputs.accountEndpoint
    cosmosDBDatabaseName: databaseName
    cosmosDBProductsContainerName: productsContainerName
    cosmosDBShipmentContainerName: shipmentContainerName
    loadTestingDataPlaneEndpoint: 'https://${loadTesting.outputs.loadtestingNameDataPlaneUri}'
    loadTestId: guid(rg.id, 'loadtest')
    proxyFuncAppHostname: proxyFunctionApp.outputs.hostname
    proxyFuncAppKey: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${keyVaultFuncAppSecretName})'
  }
  scope: rg
}

/*
Load Testing Service
*/
module loadTesting 'modules/load-testing.bicep' = {
  name: 'loadTestingDeploy'
  params: {
    location: location
    loadTestingName: loadTestingName
    managedIdentityPrincipalId: msiAppPlan.outputs.managedIdentityPrincipalId
  }
  scope: rg
}

/*
Function App
*/
module proxyFunctionApp 'modules/functionapp.bicep' = {
  name: 'proxyFuncDeploy'
  dependsOn: [
    kv
  ]
  params: {
    location: location
    appName: proxyFuncName
    appInsightsLocation: location
    runtime: 'dotnet'
    storageAccountType: 'Standard_LRS'
    keyVaultName: keyVaultName
    keyVaultSecretName: keyVaultFuncAppSecretName
  }
  scope: rg
}

/*
Key Vault
*/
module kv 'modules/keyvault.bicep' = {
  name: 'kvDeploy'
  params: {
    name: keyVaultName
    location: location
    msiObjectId: msiAppPlan.outputs.managedIdentityPrincipalId
  }
  scope: rg
}


/*
Outputs, used in subsequents steps of the deployment scripts
*/
output webAppName string = webSiteName
output webAppHostname string = appPlan.outputs.hostname
output cosmosDbAccountEndpoint string = cosmosDb.outputs.accountEndpoint
output cosmosDbConnectionString string = cosmosDb.outputs.connString

var loadTestingNewTestId = guid(rg.id, 'loadtest')
var loadTestingNewTestFileId = guid(rg.id, 'loadtest', loadTestingNewTestId, 'file')
output loadtestingId string = loadTesting.outputs.loadtestingId
output loadTestingDataPlaneUri string = loadTesting.outputs.loadtestingNameDataPlaneUri
output loadTestingNewTestId string = loadTestingNewTestId
output loadTestingNewTestFileId string = loadTestingNewTestFileId


output proxyFuncAppName string = proxyFuncName
output proxyFuncHostname string = proxyFunctionApp.outputs.hostname
