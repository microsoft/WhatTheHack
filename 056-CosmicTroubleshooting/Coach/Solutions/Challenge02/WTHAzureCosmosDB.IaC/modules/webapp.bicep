param location string = resourceGroup().location // Location for all resources
param appServicePlanName string
param webSiteName string
param appInsightsName string
param msiClientId string
param msiObjectId string
param cosmosDBAccountEndpoint string
param cosmosDBDatabaseId string
param oldCosmosDBContainerId string
param cosmosDBProductContainerId string
param cosmosDBCustomerCartContainerId string
param cosmosDBCustomerOrderContainerId string
param cosmosDBShipmentContainerId string
param slotName string = 'Secondary'
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
    name: 'Cosmos:ProductCollectionName'
    value: cosmosDBProductContainerId
  }
  {
    name: 'Cosmos:CustomerCartCollectionName'
    value: cosmosDBCustomerCartContainerId
  }
  {
    name: 'Cosmos:CustomerOrderCollectionName'
    value: cosmosDBCustomerOrderContainerId
  }
  {
    name: 'Cosmos:ShipmentCollectionName'
    value: cosmosDBShipmentContainerId
  }
  {
    name: 'Cosmos:CollectionName'
    value: oldCosmosDBContainerId
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

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01'  existing = {
  name: appServicePlanName
}


resource secondarySlot 'Microsoft.Web/sites/slots@2022-03-01' = {
  name: '${webSiteName}/${slotName}'
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
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msiObjectId}': {}
    }
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

output hostname string = secondarySlot.properties.hostNames[0]
