param sku string = 'S1' // The SKU of App Service Plan
param location string = resourceGroup().location // Location for all resources
param appServicePlanName string
param webSiteName string
param appInsightsName string
param msiClientId string
param msiObjectId string
param cosmosDBAccountEndpoint string
param cosmosDBDatabaseId string
param cosmosDBProductsContainerId string
param cosmosDBShipmentContainerId string
param loadTestingDataPlaneEndpoint string
param loadTestId string
param proxyFuncAppHostname string
param proxyFuncAppKey string

var appSettings = [
  {
    name: 'Cosmos:AccountEndpoint'
    value: cosmosDBAccountEndpoint
  }
  {
    name: 'Cosmos:Database'
    value: cosmosDBDatabaseId
  }
  {
    name: 'Cosmos:CollectionName'
    value: cosmosDBProductsContainerId
  }
  {
    name: 'Cosmos:ShipmentCollectionName'
    value: cosmosDBShipmentContainerId
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

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    IngestionMode: 'ApplicationInsightsWithDiagnosticSettings'
  }
}


output hostname string = appService.properties.hostNames[0]
