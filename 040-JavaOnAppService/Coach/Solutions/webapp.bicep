param baseName string = 'wth'

param mysqlUser string
@secure()
param mysqlPassword string
param mysqlUrl string


// Default location for the resources
var location = resourceGroup().location
var resourceSuffix = substring(concat(baseName, uniqueString(resourceGroup().id)), 0, 8)

resource plan 'Microsoft.Web/serverfarms@2020-09-01' = {
  name: 'plan-${resourceSuffix}'
  location: location
  sku: {
    name: 'P1V2' 
  }
  properties: {
    reserved: true // makes this a Linux plan
  } 
}

resource webApp 'Microsoft.Web/sites@2020-09-01' = {
  name: 'web-${resourceSuffix}'
  location: location
  identity: {
    type: 'SystemAssigned' // managed identity to access the KeyVault
  }
  properties: {
    siteConfig: {
      linuxFxVersion: 'JAVA|8'
    }
    serverFarmId: plan.id
    httpsOnly: true
  }
}

module webAppSettings './appsettings.bicep' = {
  name: 'appsettings'
  params: {
    webAppName: webApp.name
    mysqlUrl: mysqlUrl
    mysqlUser: mysqlUser
    mysqlPassword: mysqlPassword
  }
}

output webAppName string = webApp.name
