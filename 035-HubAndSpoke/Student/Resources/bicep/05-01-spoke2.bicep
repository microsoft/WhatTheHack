param location string = 'eastus2'
param adminUserLogin string
param adminUserSid string

resource rtspoke2vms 'Microsoft.Network/routeTables@2022-01-01' existing = {
  name: 'wth-rt-spoke2vmssubnet'
}

resource nsgspoke2vms 'Microsoft.Network/networkSecurityGroups@2022-01-01' existing = {
  name: 'wth-nsg-spoke2vmssubnet'
}

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'wthspoke2${uniqueString(subscription().id)}'
  location: location
  properties: {
    administratorLogin: 'admin-wth'
    administratorLoginPassword: guid(subscription().id,'this_is_a_b0gus_and_disabled_password!')
    version: '12.0'
    publicNetworkAccess: 'Disabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'User'
      login: adminUserLogin
      sid: adminUserSid
      tenantId: tenant().tenantId
    }
  }
}

resource sqlServerFirewall 'Microsoft.Sql/servers/virtualNetworkRules@2021-11-01' = {
  name: 'rule'
  parent: sqlServer
  properties: {
    virtualNetworkSubnetId: wthspoke1vnet.properties.subnets[0].id
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  name: 'sampleDB'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    autoPauseDelay: 240
    maxSizeBytes: 1073741824
    sampleName: 'AdventureWorksLT'
    zoneRedundant: false 
  }
}

resource wthspoke1vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: 'wth-vnet-spoke201'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-spoke1vms'
        properties: {
          addressPrefix: '10.2.10.0/24'
          networkSecurityGroup: {
            id: nsgspoke2vms.id
          }
          routeTable: { 
            id: rtspoke2vms.id 
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.SQL'
            }
          ]
        }
      }
    ]
  }
}

