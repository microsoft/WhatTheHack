@description('Application/Solution name')
param appName string = uniqueString(resourceGroup().id)

@description('Publisher name (Must be an AAD Global Admin/Subscriptoin Admin)')
param publisherName string = 'Noemi Veneracion'

@description('Publisher email')
param publisherEmail string = 'novenera@microsoft.com'


param resourceTags object = {
  ProjectType: 'What The Hack - Azure Integration Services POC'
  Purpose: 'This is a sample POC environment for the hackathon.'
}

@description('Application Insights name')
param appInsightsName string = toLower('ai-${appName}')

@description('Function runtime')
param functionRuntime string = 'dotnet'

@description('Function app SKU')
param functionSku string = 'Y1'

@description('Storage account name')
param storageAccountName string = toLower('stor${appName}')

@description('Function App name')
param functionAppName string = toLower('func-${appName}-1')

@description('App Service plan name')
param appServicePlanName string = toLower('asp-${appName}')


@description('API Management service name')
param apiManagementServiceName string = toLower('apim-${appName}')

var location = resourceGroup().location

module appInsightsModule 'modules/appInsights.bicep' = {
  name: 'aiDeploy'
  params: {
    location:location
    appInsightsName: appInsightsName
    resourceTags: resourceTags
  }

  
}

module functionModule 'modules/function.bicep' = {
  name: 'functionDeploy'
  params: {
    location:location
    functionRuntime:functionRuntime
    functionSku:functionSku
    storageAccountName:storageAccountName
    functionAppName:functionAppName
    appServicePlanName:appServicePlanName
    appInsightsInstrumentationKey: appInsightsModule.outputs.appInsightsInstrumentationKey
    resourceTags: resourceTags
  }
}

module apimmodule './modules/apim.bicep' = {
  name: 'apimDeploy'
  params: {
    location:location
    apiManagementServiceName: apiManagementServiceName
    sku: 'Developer'
    skuCount: 1
    publisherName: publisherName
    publisherEmail: publisherEmail    
    appInsightsInstrumentationKey: appInsightsModule.outputs.appInsightsInstrumentationKey
    appInsightsResourceId: appInsightsModule.outputs.appInsightsResourceId    
    resourceTags: resourceTags    
  }
}
