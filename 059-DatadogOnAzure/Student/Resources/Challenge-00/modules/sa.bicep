param Location string
param StorageAccountName string

resource sa 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  name: StorageAccountName
  location: Location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: false
    supportsHttpsTrafficOnly: true
    isNfsV3Enabled: false
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
}

output Name string = sa.name
output Key string = listKeys(sa.name, sa.apiVersion).keys[0].value
