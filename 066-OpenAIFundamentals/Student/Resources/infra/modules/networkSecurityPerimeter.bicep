// Parameters
@description('Specifies the name of the Network Security Perimeter.')
param name string

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the Azure Key Vault resource id')
param keyVaultId string

@description('Specifies the Azure Storage Account resource id')
param storageAccountId string

// Resources
resource nsp 'Microsoft.Network/networkSecurityPerimeters@2023-08-01-preview' = {
  name: name
  location: location
}

resource nspProfile 'Microsoft.Network/networkSecurityPerimeters/profiles@2023-08-01-preview' = {
  parent: nsp
  name: 'defaultProfile'
  location: location
}

resource nspKeyVaultAssociation 'Microsoft.Network/networkSecurityPerimeters/resourceAssociations@2023-08-01-preview' = {
  parent: nsp
  name: 'nsp-ra-kv'
  properties: {
    privateLinkResource: {
      id: keyVaultId
    }
    profile: {
      id: nspProfile.id
    }
    accessMode: 'Learning'
  }
}

resource nspStorageAccountAssociation 'Microsoft.Network/networkSecurityPerimeters/resourceAssociations@2023-08-01-preview' = {
  parent: nsp
  name: 'nsp-ra-sa'
  properties: {
    privateLinkResource: {
      id: storageAccountId
    }
    profile: {
      id: nspProfile.id
    }
    accessMode: 'Learning'
  }
}

// Outputs
output name string = nsp.name
