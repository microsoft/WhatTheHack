param storageAccountName string
param containerName string
param location string
param tags object

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: tags
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  #disable-next-line use-parent-property
  name: '${storageAccount.name}/default/${containerName}'
}

output storageAccountName string = storageAccount.name
output containerName string = containerName
