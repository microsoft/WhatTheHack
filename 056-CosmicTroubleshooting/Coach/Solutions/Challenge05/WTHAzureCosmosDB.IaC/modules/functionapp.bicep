@description('The name of the function app that you wish to create.')
param appName string = 'fnapp${uniqueString(resourceGroup().id)}'

var functionAppName = appName

resource functionApp 'Microsoft.Web/sites@2021-03-01' existing = {
  name: functionAppName
}



output hostname string = functionApp.properties.hostNames[0]
