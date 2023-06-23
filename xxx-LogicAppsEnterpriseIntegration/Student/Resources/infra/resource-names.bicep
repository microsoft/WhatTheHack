param resourceToken string

var abbrs = loadJsonContent('./abbreviations.json')

output appInsightsName string = '${abbrs.insightsComponents}${resourceToken}'
output containerName string = 'files'
output functionAppName string = '${abbrs.webSitesFunctions}${resourceToken}'
output functionAppPlanName string = '${abbrs.webServerFarms}func-${resourceToken}'
output functionAppStorageAccountName string = toLower('${abbrs.storageStorageAccounts}${resourceToken}func')
output keyVaultName string = '${abbrs.keyVaultVaults}${resourceToken}'
output logAnalyticsWorkspaceName string = '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
output logicAppName string = '${abbrs.logicWorkflows}${resourceToken}'
output logicAppPlanName string = '${abbrs.webServerFarms}logic-${resourceToken}'
output logicAppStorageAccountConnectionStringSecretName string = 'logic-app-storage-account-connection-string'
output logicAppStorageAccountName string = toLower('${abbrs.storageStorageAccounts}${resourceToken}logic')
output managedIdentityName string = '${abbrs.managedIdentityUserAssignedIdentities}${resourceToken}'
output serviceBusNamespaceName string = '${abbrs.serviceBusNamespaces}${resourceToken}'
output sqlDbName string = '${abbrs.sqlServersDatabases}${resourceToken}'
output sqlServerName string = '${abbrs.sqlServers}${resourceToken}'
output storageAccountName string = '${abbrs.storageStorageAccounts}${resourceToken}files'
