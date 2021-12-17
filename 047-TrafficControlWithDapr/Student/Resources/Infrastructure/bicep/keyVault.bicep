param longName string

resource keyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: 'kv-${longName}'
  location: resourceGroup().location 
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: false
    accessPolicies: []
  }  
}

output keyVaultName string = keyVault.name
output keyVaultResourceId string = keyVault.id
