param appName string
param region string
param environment string
param location string = resourceGroup().location
param shouldDeployToContainerApps bool = false
param containerAppTrafficControlServiceObject object = {}
param containerAppFineCollectionServiceObject object = {}
param containerAppVehicleRegistrationServiceObject object = {}

module names 'resource-names.bicep' = {
  name: 'resource-names'
  params: {
    appName: appName
    region: region
    env: environment
  }
}

module loggingDeployment 'logging.bicep' = {
  name: 'logging-deployment'
  params: {
    appInsightsName: names.outputs.appInsightsName
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module managedIdentityDeployment 'managed-identity.bicep' = {
  name: 'managed-identity-deployment'
  params: {
    location: location
    managedIdentityName: names.outputs.managedIdentityName
  }
}

module keyVaultDeployment 'key-vault.bicep' = {
  name: 'key-vault-deployment'
  params: {
    #disable-next-line BCP335
    keyVaultName: names.outputs.keyVaultName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
  }
}

module serviceBusDeployment 'service-bus.bicep' = {
  name: 'service-bus-deployment'
  params: {
    serviceBusNamespaceName: names.outputs.serviceBusNamespaceName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module logicAppDeployment 'logic-app.bicep' = {
  name: 'logic-app-deployment'
  params: {
    logicAppName: names.outputs.logicAppName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module containerRegistryDeployment 'container-registry.bicep' = {
  name: 'container-registry-deployment'
  params: {
    containerRegistryName: names.outputs.containerRegistryName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
  }
}

module aksDeployment 'aks.bicep' = if (!shouldDeployToContainerApps) {
  name: 'aks-deployment'
  params: {
    aksName: names.outputs.aksName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
  }
}

module acaEnvironmentDeployment 'managed-environment.bicep' = if (shouldDeployToContainerApps) {
  name: 'aca-environment-deployment'
  params: {
    containerAppEnvironmentName: names.outputs.containerAppEnvironmentName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    appInsightsName: loggingDeployment.outputs.appInsightsName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    serviceBusNamespaceName: serviceBusDeployment.outputs.serviceBusNamespaceName
    logicAppName: logicAppDeployment.outputs.logicAppName
    containerAppTrafficControlServiceObject: containerAppTrafficControlServiceObject
    containerAppFineCollectionServiceObject: containerAppFineCollectionServiceObject
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    redisCacheName: redisCacheDeployment.outputs.redisCacheName
    storageAccountName: storageAccountDeployment.outputs.storageAccountName
    storageAccountEntryCamContainerName: storageAccountDeployment.outputs.storageAccountEntryCamContainerName
    storageAccountExitCamContainerName: storageAccountDeployment.outputs.storageAccountExitCamContainerName
    daprComponentEntryCamInputBindingsName: names.outputs.daprComponentEntryCamInputBindingsName
    daprComponentExitCamInputBindingsName: names.outputs.daprComponentExitCamInputBindingsName
    daprComponentOutputBindingsName: names.outputs.daprComponentOutputBindingsName
    daprComponentStateStoreName: names.outputs.daprComponentStateStoreName
    daprComponentPubSubName: names.outputs.daprComponentPubSubName
    daprComponentSecretsName: names.outputs.daprComponentSecretsName
    eventHubConsumerGroupName: mqttDeployment.outputs.eventHubConsumerGroupName
    eventHubEntryCamName: mqttDeployment.outputs.eventHubEntryCamName
    eventHubExitCamName: mqttDeployment.outputs.eventHubExitCamName
    eventHubNamespaceName: mqttDeployment.outputs.eventHubNamespaceName
    eventHubListenAuthorizationRuleName: mqttDeployment.outputs.eventHubListenAuthorizationRuleName
  }
}

module acaDeployment 'container-app.bicep' = if (shouldDeployToContainerApps) {
  name: 'aca-deployment'
  params: {
    containerAppEnvironmentName: names.outputs.containerAppEnvironmentName
    location: location
    containerAppTrafficControlServiceObject: containerAppTrafficControlServiceObject
    containerAppFineCollectionServiceObject: containerAppFineCollectionServiceObject
    containerAppVehicleRegistrationServiceObject: containerAppVehicleRegistrationServiceObject
    containerRegistryName: containerRegistryDeployment.outputs.containerRegistryName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
  }
}

module redisCacheDeployment 'redis-cache.bicep' = {
  name: 'redis-cache-deployment'
  params: {
    redisCacheName: names.outputs.redisCacheName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module mqttDeployment 'mqtt.bicep' = {
  name: 'mqtt-deployment'
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

module storageAccountDeployment 'storage.bicep' = {
  name: 'storage-account-deployment'
  params: {
    storageAccountName: names.outputs.storageAccountName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    storageAccountEntryCamContainerName: names.outputs.storageAccountEntryCamContainerName
    storageAccountExitCamContainerName: names.outputs.storageAccountExitCamContainerName
  }
}

output aksFQDN string = aksDeployment.outputs.aksfqdn
output aksName string = aksDeployment.outputs.aksName
output aksNodeResourceGroupName string = aksDeployment.outputs.aksNodeResourceGroupName
output aksazurePortalFQDN string = aksDeployment.outputs.aksazurePortalFQDN
output appInsightsInstrumentationKey string = loggingDeployment.outputs.appInsightsInstrumentationKey
output appInsightsName string = loggingDeployment.outputs.appInsightsName
output containerRegistryLoginServerName string = containerRegistryDeployment.outputs.containerRegistryLoginServerName
output containerRegistryName string = containerRegistryDeployment.outputs.containerRegistryName
output eventHubEntryCamName string = mqttDeployment.outputs.eventHubEntryCamName
output eventHubExitCamName string = mqttDeployment.outputs.eventHubExitCamName
output eventHubNamespaceHostName string = mqttDeployment.outputs.eventHubNamespaceHostName
output eventHubNamespaceName string = mqttDeployment.outputs.eventHubNamespaceName
output iotHubName string = mqttDeployment.outputs.iotHubName
output keyVaultName string = keyVaultDeployment.outputs.keyVaultName
output keyVaultResourceId string = keyVaultDeployment.outputs.keyVaultResourceId
output logicAppAccessEndpoint string = logicAppDeployment.outputs.logicAppAccessEndpoint
output logicAppName string = logicAppDeployment.outputs.logicAppName
output redisCacheName string = redisCacheDeployment.outputs.redisCacheName
output resourceGroupName string = resourceGroup().name
output serviceBusConnectionString string = serviceBusDeployment.outputs.serviceBusConnectionString
output serviceBusEndpoint string = serviceBusDeployment.outputs.serviceBusEndpoint
output serviceBusNamespaceName string = serviceBusDeployment.outputs.serviceBusNamespaceName
output storageAccountEntryCamContainerName string = storageAccountDeployment.outputs.storageAccountEntryCamContainerName
output storageAccountExitCamContainerName string = storageAccountDeployment.outputs.storageAccountExitCamContainerName
output storageAccountKey string = storageAccountDeployment.outputs.storageAccountContainerKey
output storageAccountName string = storageAccountDeployment.outputs.storageAccountName
output subscriptionId string = subscription().subscriptionId
output userAssignedManagedIdentityClientId string = managedIdentityDeployment.outputs.userAssignedManagedIdentityClientId
