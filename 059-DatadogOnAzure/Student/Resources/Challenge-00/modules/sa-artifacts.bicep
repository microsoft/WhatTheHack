@description('Name of the blob as it is stored in the blob container')
param VSServerScriptName string = 'SetupVSServer.ps1'
param WebServersScriptName string = 'SetupWebServers.ps1'
param DatadogScriptName string = 'SetupDatadogOnWebServers.ps1'

@description('UTC timestamp used to create distinct deployment scripts for each deployment')
param utcValue string = utcNow()

@description('Name of the blob container')
param containerName string = 'scripts'

@description('Azure region where resources should be deployed')
param location string = resourceGroup().location

@description('Desired name of the storage account')
param artifactsStorageAccountName string = 'bootstrap${uniqueString(resourceGroup().id, deployment().name, 'blob')}'

// Build name of artifacts location to be passed as an output back to main and then passed into the VM.bicep & VMSS.bicep modules
var artifactsURL = 'https://${artifactsStorageAccountName}.blob.core.windows.net/scripts/'

resource artifactsStorage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: artifactsStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource blobService 'blobServices' = {
    name: 'default'

    resource container 'containers' = {
      name: containerName
    }
  }
}

resource bootstrapServerScripts 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'bootstrap-ServerScripts-${utcValue}'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: artifactsStorage.name
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: artifactsStorage.listKeys().keys[0].value
      }
      {
        name: 'VSSERVERSCRIPT'
        value: loadTextContent('../scripts/SetupVSServer.ps1')
      }
      {
        name: 'WEBSERVERSCRIPT'
        value: loadTextContent('../scripts/SetupWebServers.ps1')
      }
      {
        name: 'DATADOGSERVERSCRIPT'
        value: loadTextContent('../scripts/SetupDatadogOnWebServers.ps1')
      }
    ]
    scriptContent: 'echo "$VSSERVERSCRIPT" > ${VSServerScriptName} && az storage blob upload -f ${VSServerScriptName} -c ${containerName} -n ${VSServerScriptName}; echo "$WEBSERVERSCRIPT" > ${WebServersScriptName} && az storage blob upload -f ${WebServersScriptName} -c ${containerName} -n ${WebServersScriptName}; echo "$DATADOGSERVERSCRIPT" > ${DatadogScriptName} && az storage blob upload -f ${DatadogScriptName} -c ${containerName} -n ${DatadogScriptName};'
  }
}

output artifactsURL string = artifactsURL
output artifactsStorageID string = artifactsStorage.id
