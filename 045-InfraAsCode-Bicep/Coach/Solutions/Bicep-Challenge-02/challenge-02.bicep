/* 
The base parameters file is included in the coach's solution.  It can be created directly, 
or in VSC hitting Shirt-Ctrl-P and searching for "BICEP: Generate Parameters File" will
create the file based on your BICEP template.
*/
param containerName string
param geoRedundancy bool = false
param location string = resourceGroup().location

var storageAccountName = 'bicepwth${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  location: location
  name: storageAccountName
  kind: 'StorageV2'
  sku: {
    name: geoRedundancy ? 'Standard_GRS' : 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storage.name}/default/${containerName}'
  properties: {
    publicAccess: 'Container'
  }
}

output storageAccountId string = storage.id
output storageAccountEndpoint string = storage.properties.primaryEndpoints.blob