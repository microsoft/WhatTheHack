param location string = 'eastus2'
param adminUserLogin string
param adminUserSid string

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.database.windows.net'
  scope: resourceGroup('wth-rg-hub')
}

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: 'wthspoke1${uniqueString(subscription().id)}'
  location: location
  properties: {
    administratorLogin: 'admin-wth'
    administratorLoginPassword: guid(subscription().id, 'this_is_a_b0gus_and_disabled_password!')
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

resource wthspoke1vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: 'wth-vnet-spoke101'
}

resource wthonpremvnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: 'wth-vnet-onprem01'
  scope: resourceGroup('wth-rg-onprem')
}

resource wthspoke1vnetpepsubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: 'subnet-sqlpeps'
  parent: wthspoke1vnet
  properties: {
    addressPrefix: '10.1.11.0/24'
    networkSecurityGroup: {
      id: nsg.id
    }
    privateEndpointNetworkPolicies: 'Enabled'
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'wth-nsg-sqlpepsubnet'
  location: location
  properties: {}
}

resource nsgSecRuleAllow 'Microsoft.Network/networkSecurityGroups/securityRules@2022-01-01' = {
  name: 'allow-sql-from-onprem'
  parent: nsg
  properties: {
    access: 'Allow'
    direction: 'Inbound'
    protocol: '*'
    sourceAddressPrefixes: wthonpremvnet.properties.addressSpace.addressPrefixes
    destinationAddressPrefix: wthspoke1vnetpepsubnet.properties.addressPrefix
    priority: 100
    sourcePortRange: '*'
    destinationPortRange: '*'
  }
}

resource nsgSecRuleDeny 'Microsoft.Network/networkSecurityGroups/securityRules@2022-01-01' = {
  name: 'deny-sql-from-any'
  parent: nsg
  properties: {
    access: 'Deny'
    direction: 'Inbound'
    protocol: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: wthspoke1vnetpepsubnet.properties.addressPrefix
    priority: 101
    sourcePortRange: '*'
    destinationPortRange: '*'
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: 'wth-pep-sqlspoke1'
  location: location
  properties: {
    subnet: {
      id: wthspoke1vnetpepsubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'sql'
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}

resource privdns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01' = {
  name: 'link'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'zoneconfig'
        properties: {
          privateDnsZoneId: privateDNSZone.id
        }
      }
    ]
  }
}

var webAppPortalName = 'wth-webapp-${uniqueString(subscription().id)}'
var appServicePlanName = 'wth-asp-${uniqueString(subscription().id)}'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webapp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppPortalName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|jelledruyts/inspectorgadget'
      ftpsState: 'FtpsOnly'
      appSettings: [
        {
            name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
            value: 'false'
        }
    ]
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource privateEndpoint_webapp 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: 'wth-pep-webapp'
  location: location
  properties: {
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets',wthspoke1vnet.name, wthspoke1vnetpepsubnet.name)
    }
    privateLinkServiceConnections: [
      {
        name: 'wth-peplink-webapp'
        properties: {
          privateLinkServiceId: webapp.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}

resource privateDnsZones 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: 'privatelink.azurewebsites.net'
  location: 'global'
  dependsOn: [
    wthspoke1vnet
  ]
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZones
  name: '${privateDnsZones.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: wthspoke1vnet.id
    }
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-03-01' = {
  parent: privateEndpoint
  name: 'dnsgroupname'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: privateDnsZones.id
        }
      }
    ]
  }
}
