@secure()
param adminPassword string

param containerNames array

var storageAccountName = 'bicepwth${uniqueString(resourceGroup().id)}'

//Referencing existing storage account
resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: storageAccountName
}

//Using for loop to create multiple containers in storage account
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for containerName in containerNames: {
  name: '${stg.name}/default/${containerName}'
  properties: {
    publicAccess: 'Container'
  }
}]

//This is only to show you accessed the key vault.  THIS IS AN ANTI-PATTERN AND NOT RECOMMENDED IN NORMAL USE
output kvinfo string = adminPassword

