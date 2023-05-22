param location string
param storageAccountName string

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  location: location
  name: storageAccountName
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storage.id

