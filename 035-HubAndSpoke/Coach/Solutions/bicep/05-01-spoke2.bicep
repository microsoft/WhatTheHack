param location string = 'eastus2'
param adminUserLogin string
param adminUserSid string

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'wthspoke2${uniqueString(subscription().id)}'
  location: location
  properties: {
    administratorLogin: 'admin-wth'
    administratorLoginPassword: guid(subscription().id,'this_is_a_b0gus_and_disabled_password!')
    version: '12.0'
    publicNetworkAccess: 'Enabled'
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
  dependsOn: [
    withspoke2vnetvmsubnet
  ]
  parent: sqlServer
  properties: {
    virtualNetworkSubnetId: wthspoke2vnet.properties.subnets[0].id
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

resource wthspoke2vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: 'wth-vnet-spoke201'
}

resource withspoke2vnetvmsubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  name: 'subnet-spoke2vms'
  parent: wthspoke2vnet
  properties: {
    addressPrefix: wthspoke2vnet.properties.subnets[0].properties.addressPrefix
    networkSecurityGroup: wthspoke2vnet.properties.subnets[0].properties.networkSecurityGroup
    routeTable: wthspoke2vnet.properties.subnets[0].properties.routeTable
    serviceEndpoints: [
      {
        service: 'Microsoft.SQL'
      }
    ]
  }
}
