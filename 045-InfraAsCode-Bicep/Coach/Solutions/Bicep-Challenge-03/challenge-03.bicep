param storageAccountName string
param containers array

resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: storageAccountName
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [ for container in containers: {
  name: '${storageAccountName}/default/${container}'
}]
