/*
Challenge 3 does not use a parameters file like seen in challenge 2.  This is something
to call out to attendees and suggest they can use a parameters file if desired.
*/
param storageAccountName string
param containers array

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for container in containers: {
  name: '${storageAccount.name}/default/${container}'
}]

/*
Alternative, more advanced solution using the parent property


resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' existing = {
  // This is fixed
  name: 'default'
  parent: storageAccount
}

resource container2 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for container in containers: {
  name: container
  parent: blobServices
}]
*/
