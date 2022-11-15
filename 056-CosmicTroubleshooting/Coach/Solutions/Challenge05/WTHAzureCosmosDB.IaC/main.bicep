@description('The name for the web app')
param webAppName string

@description('The name for the database')
param databaseName string

@description('The name for the proxy func app')
param proxyFuncAppName string

@description('The name for the old Product container')
param oldContainerName string

@description('The name for the Product container')
param productsContainerName string

@description('The name for the Customer Cart container')
param customerCartContainerName string

@description('The name for the Customer Order container')
param customerOrderContainerName string

@description('The name for the Shipment container')
param shipmentContainerName string

@description('Location where resources will be deployed. Defaults to resource group location.')
param location string

@description('Location where resources will be deployed. Defaults to resource group location.')
param resourceGroupName string

param primaryCosmosDbAccountLocation string
param secondaryCosmosDbAccountLocation string

targetScope = 'subscription'

var uniquePostfix = uniqueString(rg.id)
var appServicePlanName = toLower('appsp-${webAppName}-${uniquePostfix}')
var webSiteName = toLower('web-${webAppName}-${uniquePostfix}')
var appInsightsName = toLower('appins-${webAppName}-${uniquePostfix}')
var appServicePlanNameSec = toLower('appsp-sec-${webAppName}-${uniquePostfix}')
var webSiteNameSec = toLower('web-sec-${webAppName}-${uniquePostfix}')
var cosmosdbaccountname = 'cosmosdb-sql-${uniquePostfix}'
var loadTestingName = toLower('loadtesting-${webAppName}-${uniqueString(rg.id)}')
var tmName = toLower('tm-${webAppName}-${uniquePostfix}')
var proxyFuncName = toLower('backend-${proxyFuncAppName}-${uniquePostfix}')
var keyVaultName = 'kv-${uniquePostfix}'
var keyVaultFuncAppSecretName = 'proxy-func-key'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module msiAppPlan 'modules/managed-id.bicep' = {
  name: 'msiAppPlanDeploy'
  params: {
    managedIdentityName: 'msi-${webSiteName}'
  }
  scope: rg
}

module cosmosDb 'modules/cosmosdb-products.bicep' = {
  name: 'cosmosDBDeploy'
  dependsOn: [
    msiAppPlan
  ]
  params: {
    accountName: cosmosdbaccountname
    primaryRegion: primaryCosmosDbAccountLocation
    secondaryRegion: secondaryCosmosDbAccountLocation
  }
  scope: rg
}

module appPlan 'modules/webapp.bicep' = {
  name: 'webAppDeploy-PrimaryRegion'
  dependsOn: [
    msiAppPlan, proxyFunctionApp
  ]
  params: {
    location: toLower(primaryCosmosDbAccountLocation)
    appInsightsName: appInsightsName
    appServicePlanName: appServicePlanName
    webSiteName: webSiteName
    msiObjectId: msiAppPlan.outputs.managedIdentityId
    msiClientId: msiAppPlan.outputs.managedIdentityClientId
    cosmosDBAccountEndpoint: cosmosDb.outputs.accountEndpoint
    oldCosmosDBContainerId: oldContainerName
    cosmosDBProductContainerId: productsContainerName
    cosmosDBCustomerCartContainerId: customerCartContainerName
    cosmosDBCustomerOrderContainerId: customerOrderContainerName
    cosmosDBShipmentContainerId: shipmentContainerName
    cosmosDBDatabaseId: databaseName
    loadTestingDataPlaneEndpoint: 'https://${loadTesting.outputs.loadtestingNameDataPlaneUri}'
    loadTestId: guid(rg.id, 'loadtest')
    proxyFuncAppHostname: proxyFunctionApp.outputs.hostname
    proxyFuncAppKey: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${keyVaultFuncAppSecretName})'
  }
  scope: rg
}

module appPlanSecond 'modules/webapp.bicep' = {
  name: 'webAppDeploy-SecondaryRegion'
  dependsOn: [
    msiAppPlan, proxyFunctionApp
  ]
  params: {
    location: toLower(secondaryCosmosDbAccountLocation)
    appInsightsName: appInsightsName
    appServicePlanName: appServicePlanNameSec
    webSiteName: webSiteNameSec
    msiObjectId: msiAppPlan.outputs.managedIdentityId
    msiClientId: msiAppPlan.outputs.managedIdentityClientId
    cosmosDBAccountEndpoint: cosmosDb.outputs.accountEndpoint
    oldCosmosDBContainerId: oldContainerName
    cosmosDBProductContainerId: productsContainerName
    cosmosDBCustomerCartContainerId: customerCartContainerName
    cosmosDBCustomerOrderContainerId: customerOrderContainerName
    cosmosDBShipmentContainerId: shipmentContainerName
    cosmosDBDatabaseId: databaseName
    loadTestingDataPlaneEndpoint: 'https://${loadTesting.outputs.loadtestingNameDataPlaneUri}'
    loadTestId: guid(rg.id, 'loadtest')
    proxyFuncAppHostname: proxyFunctionApp.outputs.hostname
    proxyFuncAppKey: '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=${keyVaultFuncAppSecretName})'

  }
  scope: rg
}

module loadTesting 'modules/load-testing.bicep' = {
  name: 'loadTestingDeploy'
  params: {
    loadTestingName: loadTestingName
  }
  scope: rg
}

module trafficManager 'modules/trafficmanager.bicep' = {
  name: 'trafficManagerDeploy'
  params: {
    uniqueDnsName: tmName
    primaryEndpointName: webSiteName
    primaryEndpointLocation: toLower(primaryCosmosDbAccountLocation)
    primaryEndpointUrl: appPlan.outputs.webappUrl
    secondaryEndpointName: webSiteNameSec
    secondaryEndpointLocation: toLower(secondaryCosmosDbAccountLocation)
    secondaryEndpointUrl: appPlanSecond.outputs.webappUrl
    tmName: tmName
  }
  scope: rg
}

module proxyFunctionApp 'modules/functionapp.bicep' = {
  name: 'proxyFuncDeploy'
  dependsOn: [
    kv
  ]
  params: {
    appName: proxyFuncName
  }
  scope: rg
}

module kv 'modules/keyvault.bicep' = {
  name: 'kvDeploy'
  params: {
    name: keyVaultName
    msiObjectId: msiAppPlan.outputs.managedIdentityPrincipalId
  }
  scope: rg
}


output webAppNamePrimary string = webSiteName
output webAppNameSecondary string = webSiteNameSec
