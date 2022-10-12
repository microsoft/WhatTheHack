param appName string
param region string
param environment string
param adminUsername string
param publicSSHKey string
param location string = resourceGroup().location

module names 'resource-names.bicep' = {
  name: 'resource-names'
  params: {
    appName: appName
    region: region
    env: environment
  }
}

module loggingDeployment 'logging.bicep' = {
  name: 'logging'
  params: {
    appInsightsName: names.outputs.appInsightsName
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module keyVaultModule 'key-vault.bicep' = {
  name: 'key-vault-deployment'
  params: {
    keyVaultName: names.outputs.keyVaultName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module serviceBusModule 'service-bus.bicep' = {
  name: 'service-bus-deployment'
  params: {
    serviceBusNamespaceName: names.outputs.serviceBusNamespaceName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module logicAppModule 'logic-app.bicep' = {
  name: 'logic-app-deployment'
  params: {
    logicAppName: names.outputs.logicAppName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module containerRegistryModule 'container-registry.bicep' = {
  name: 'container-registry-deployment'
  params: {
    containerRegistryName: names.outputs.containerRegistryName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module aksModule 'aks.bicep' = {
  name: 'aks-deployment'
  params: {
    aksName: names.outputs.aksName
    adminUsername: adminUsername
    publicSSHKey: publicSSHKey
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module redisCacheModule 'redis-cache.bicep' = {
  name: 'redis-cache-deployment'
  params: {
    redisCacheName: names.outputs.redisCacheName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module mqttModule 'mqtt.bicep' = {
  name: 'mqttDeploy'
  params: {
    iotHubName: names.outputs.iotHubName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    eventHubConsumerGroupName: names.outputs.eventHubConsumerGroupName
    eventHubNamespaceName: names.outputs.eventHubNamespaceName
    eventHubEntryCamName: names.outputs.eventHubEntryCamName
    eventHubExitCamName: names.outputs.eventHubExitCamName
    eventHubListenAuthorizationRuleName: names.outputs.eventHubListenAuthorizationRuleName
  }
}

module storageAccountModule 'storage.bicep' = {
  name: 'storage-account-deployment'
  params: {
    storageAccountName: names.outputs.storageAccountName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    storageAccountEntryCamContainerName: names.outputs.storageAccountEntryCamContainerName
    storageAccountExitCamContainerName: names.outputs.storageAccountExitCamContainerName
  }
}

output subscriptionId string = subscription().subscriptionId
output resourceGroupName string = resourceGroup().name
output serviceBusName string = serviceBusModule.outputs.serviceBusName
output serviceBusEndpoint string = serviceBusModule.outputs.serviceBusEndpoint
output redisCacheName string = redisCacheModule.outputs.redisCacheName
output keyVaultName string = keyVaultModule.outputs.keyVaultName
output logicAppName string = logicAppModule.outputs.logicAppName
output logicAppAccessEndpoint string = logicAppModule.outputs.logicAppAccessEndpoint
output containerRegistryName string = containerRegistryModule.outputs.containerRegistryName
output containerRegistryLoginServerName string = containerRegistryModule.outputs.containerRegistryLoginServerName
output aksName string = aksModule.outputs.aksName
output aksFQDN string = aksModule.outputs.aksfqdn
output aksazurePortalFQDN string = aksModule.outputs.aksazurePortalFQDN
output aksNodeResourceGroupName string = aksModule.outputs.aksNodeResourceGroupName
output iotHubName string = mqttModule.outputs.iotHubName
output eventHubNamespaceName string = mqttModule.outputs.eventHubNamespaceName
output eventHubNamespaceHostName string = mqttModule.outputs.eventHubNamespaceHostName
output eventHubEntryCamName string = mqttModule.outputs.eventHubEntryCamName
output eventHubExitCamName string = mqttModule.outputs.eventHubExitCamName
output storageAccountName string = storageAccountModule.outputs.storageAccountName
output storageAccountEntryCamContainerName string = storageAccountModule.outputs.storageAccountEntryCamContainerName
output storageAccountExitCamContainerName string = storageAccountModule.outputs.storageAccountExitCamContainerName
output storageAccountKey string = storageAccountModule.outputs.storageAccountContainerKey
output appInsightsName string = loggingDeployment.outputs.appInsightsName
output appInsightsInstrumentationKey string = loggingDeployment.outputs.appInsightsInstrumentationKey
output keyVaultResourceId string = keyVaultModule.outputs.keyVaultResourceId
