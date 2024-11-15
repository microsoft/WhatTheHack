@description('Name of the Azure Storage Account.')
param name string

@description('Location where the Azure Storage Account will be created.')
param location string

@description('List of containers to create in the Azure Storage Account.')
param containers array = []

resource account 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices@2019-06-01' = {
  name: 'default'
  parent: account
}

resource containersToCreate 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for container in containers: {
  name: container
  parent: blob
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}]

#disable-next-line outputs-should-not-contain-secrets
output primaryKey string = account.listKeys().keys[0].value

#disable-next-line outputs-should-not-contain-secrets
output connectionString string = 'DefaultEndpointsProtocol=https;AccountName=${name};AccountKey=${account.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
