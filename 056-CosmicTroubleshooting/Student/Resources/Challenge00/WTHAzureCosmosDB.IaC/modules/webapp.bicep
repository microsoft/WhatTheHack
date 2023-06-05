/*
Parameters
*/

@description('SKU of the App Service Plan. Default S1')
param sku string = 'S1'

@description('Location. Defaults to Resource Group location')
param location string = resourceGroup().location

@description('App Service Plan name')
param appServicePlanName string

@description('Web App name')
param webSiteName string

@description('Application Insights name')
param appInsightsName string

@description('Managed Identity Client Id')
param msiClientId string

@description('Managed Identity Id')
param msiObjectId string

@description('Cosmos DB Account endpoint')
param cosmosDBAccountEndpoint string

@description('Cosmos DB Database name')
param cosmosDBDatabaseName string

@description('Cosmos DB Products Container name')
param cosmosDBProductsContainerName string

@description('Cosmos DB Shipments Container name')
param cosmosDBShipmentContainerName string

@description('Load Testing Service Data Plane endpoint')
param loadTestingDataPlaneEndpoint string

@description('Load Test Id')
param loadTestId string

@description('Load Testing Proxy Function app name')
param proxyFuncAppHostname string

@description('Load Testing Proxu Function app key')
param proxyFuncAppKey string


/*
Local variables
*/
var appSettings = [
  {
    name: 'Cosmos:AccountEndpoint'
    value: cosmosDBAccountEndpoint
  }
  {
    name: 'Cosmos:Database'
    value: cosmosDBDatabaseName
  }
  {
    name: 'Cosmos:CollectionName'
    value: cosmosDBProductsContainerName
  }
  {
    name: 'Cosmos:ShipmentCollectionName'
    value: cosmosDBShipmentContainerName
  }
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: appInsights.properties.ConnectionString
  }
  {
    name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
    value: '~2'
  }
  {
    name: 'AZURE_CLIENT_ID'
    value: msiClientId
  }
  {
    name: 'LOADT_DATA_PLANE_ENDPOINT'
    value: loadTestingDataPlaneEndpoint
  }
  {
    name: 'LOADT_TEST_ID'
    value: loadTestId
  }
  {
    name: 'PROXY_FUNC_HOSTNAME'
    value: proxyFuncAppHostname
  }
  {
    name: 'PROXY_FUNC_KEY'
    value: proxyFuncAppKey
  }
]

/*
App Service Plan
*/
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName  
  location: location
  properties: {
    reserved: false
  }
  sku: {
    name: sku
  }
}

/*
Web App
*/
resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true
      appSettings: appSettings
      netFrameworkVersion: 'v6.0'
    }
    keyVaultReferenceIdentity: msiObjectId
  }
  identity:{
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msiObjectId}': {}
    }
  }
}

/*
Application Insights for Web App
*/
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    IngestionMode: 'ApplicationInsightsWithDiagnosticSettings'
  }
}

/*
Outputs
*/
output hostname string = appService.properties.hostNames[0]
