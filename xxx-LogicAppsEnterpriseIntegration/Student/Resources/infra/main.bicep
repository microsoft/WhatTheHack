targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string
param resourceGroupName string = ''
param sqlAdminLoginName string
param sqlAdminLoginObjectId string
param sqlClientIpAddress string

var abbrs = loadJsonContent('./abbreviations.json')

// tags that should be applied to all resources.
var tags = {
  // Tag all resources with the environment name.
  'azd-env-name': environmentName
}

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

// Organize resources in a resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

module names 'resource-names.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'resource-names'
  params: {
    resourceToken: resourceToken
  }
}

module loggingDeployment 'logging.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'logging-deployment'
  params: {
    appInsightsName: names.outputs.appInsightsName
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
    location: location
    tags: tags
  }
}

module managedIdentityDeployment 'managed-identity.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'managed-identity-deployment'
  params: {
    location: location
    managedIdentityName: names.outputs.managedIdentityName
    tags: tags
  }
}

module keyVaultDeployment 'key-vault.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'key-vault-deployment'
  params: {
    keyVaultName: names.outputs.keyVaultName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    tags: tags
    userObjectId: sqlAdminLoginObjectId
  }
}

module serviceBusDeployment 'service-bus.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'service-bus-deployment'
  params: {
    serviceBusNamespaceName: names.outputs.serviceBusNamespaceName
    location: location
    tags: tags
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
  }
}

module functionAppDeployment 'function.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'function-app-deployment'
  params: {
    location: location
    appInsightsName: loggingDeployment.outputs.appInsightsName
    appServicePlanName: names.outputs.functionAppPlanName
    functionAppStorageAccountName: names.outputs.functionAppStorageAccountName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    tags: tags
    functionAppName: names.outputs.functionAppName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
  }
}

module logicApp 'logic-app.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'logic-app-deployment'
  params: {
    appInsightsName: loggingDeployment.outputs.appInsightsName
    appServicePlanName: names.outputs.logicAppPlanName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    logicAppName: names.outputs.logicAppName
    logicAppStorageAccountConnectionStringSecretName: names.outputs.logicAppStorageAccountConnectionStringSecretName
    logicAppStorageAccountName: names.outputs.logicAppStorageAccountName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    tags: tags
    containerName: storage.outputs.containerName
    sqlDbName: sql.outputs.sqlDbName
    sqlServerName: sql.outputs.sqlServerName
  }
}

module sql 'sql.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'sql-deployment'
  params: {
    location: location
    sqlAdminLoginName: sqlAdminLoginName
    sqlAdminLoginObjectId: sqlAdminLoginObjectId
    sqlDbName: names.outputs.sqlDbName
    sqlServerName: names.outputs.sqlServerName
    tags: tags
    sqlClientIpAddress: sqlClientIpAddress
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
  }
}

module storage 'storage.bicep' = {
  scope: az.resourceGroup(resourceGroup.name)
  name: 'storage-deployment'
  params: {
    location: location
    storageAccountName: names.outputs.storageAccountName
    tags: tags
    containerName: names.outputs.containerName
  }
}

output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
