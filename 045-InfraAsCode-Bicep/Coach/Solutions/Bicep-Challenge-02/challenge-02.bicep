param containerName string
param globalRedundancy bool = false

var storageAccountName = 'bicepwth${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  location: resourceGroup().location
  name: storageAccountName
  kind: 'StorageV2'
  sku: {
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storage.name}/default/${containerName}'
  properties: {
    publicAccess: 'Container'
  }
}

output storageAccountId string = storage.id
output storageAccountEndpoint string = storage.properties.primaryEndpoints.blob
