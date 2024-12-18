param containers array = []
param files array = []
param keyvaultName string
param location string = resourceGroup().location
param name string
param tags object = {}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: tags
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storage
  name: 'default'
}

resource blobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = [
  for container in containers: {
    parent: blobService
    name: container.name
  }
]

resource blobFiles 'Microsoft.Resources/deploymentScripts@2020-10-01' = [
  for file in files: {
    name: file.file
    location: location
    kind: 'AzureCLI'
    properties: {
      azCliVersion: '2.26.1'
      timeout: 'PT5M'
      retentionInterval: 'PT1H'
      environmentVariables: [
        {
          name: 'AZURE_STORAGE_ACCOUNT'
          value: storage.name
        }
        {
          name: 'AZURE_STORAGE_KEY'
          secureValue: storage.listKeys().keys[0].value
        }
      ]
      scriptContent: 'echo "${file.content}" > ${file.file} && az storage blob upload -f ${file.file} -c ${file.container} -n ${file.path}'
    }
    dependsOn: [ blobContainers ]
  }
]

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyvaultName
}

resource storageConnectionString 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'storage-connection'
  parent: keyvault
  tags: tags
  properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
  }
}

output connectionSecretName string = storageConnectionString.name
output connectionSecretRef string = storageConnectionString.properties.secretUri
output name string = storage.name
