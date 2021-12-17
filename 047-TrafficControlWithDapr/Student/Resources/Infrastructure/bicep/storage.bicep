param longName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: toLower('sa${replace(longName, '-', '')}')
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'BlobStorage'
  properties: {
    accessTier: 'Hot'
  }
}

var storageAccountEntryCamContainerName = 'trafficcontrol-entrycam'
var storageAccountExitCamContainerName = 'trafficcontrol-exitcam'

resource storageAccountEntryCamContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageAccount.name}/default/${storageAccountEntryCamContainerName}'
}

resource storageAccountExitCamContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageAccount.name}/default/${storageAccountExitCamContainerName}'
}

output storageAccountName string = storageAccount.name
output storageAccountEntryCamContainerName string = storageAccountEntryCamContainerName
output storageAccountExitCamContainerName string = storageAccountExitCamContainerName
output storageAccountContainerKey string = listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value
