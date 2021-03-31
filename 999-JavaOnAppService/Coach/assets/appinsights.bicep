param baseName string = 'wth'

// Default location for the resources
var location = resourceGroup().location
var resourceSuffix = substring(concat(baseName, uniqueString(resourceGroup().id)), 0, 8)
var appInsightsSecretKey = 'secret-app-insights-key'

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: 'appi-${resourceSuffix}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource appInsightsSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: 'kv-${resourceSuffix}/${appInsightsSecretKey}'
  properties: {
    value: reference(appInsights.id).ConnectionString
  }
}

output appInsights string = '@Microsoft.KeyVault(SecretUri=${reference(appInsightsSecret.id).secretUri})'
