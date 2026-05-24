param location string = 'eastus2'
param adminUserLogin string
param adminUserSid string

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink${environment().suffixes.sqlServerHostname}'
  scope: resourceGroup('wth-rg-hub')
}

resource afw 'Microsoft.Network/azureFirewalls@2022-07-01' existing = {
  name: 'wth-afw-hub01'
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
    minimalTlsVersion: '1.2'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'User'
      login: adminUserLogin
      sid: adminUserSid
      tenantId: tenant().tenantId
    }
  }
  resource connectionPolicy 'connectionPolicies@2021-11-01' = {
    name: 'default'
    properties: {
      connectionType: 'Proxy'
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

resource wthspoke1vnetappsvcsubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: 'subnet-appsvc'
  parent: wthspoke1vnet
  dependsOn: [
    wthspoke1vnetpepsubnet
  ]
  properties: {
    addressPrefix: '10.1.12.0/24'
    privateEndpointNetworkPolicies: 'Enabled'
    routeTable: {
      id: routeTable.id
    }
    delegations: [
      {
        name: 'delegation'
        properties: {
          serviceName: 'Microsoft.Web/serverFarms'
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'wth-nsg-sqlpepsubnet'
  location: location
  properties: {}
}

resource nsgSecRuleAllow 'Microsoft.Network/networkSecurityGroups/securityRules@2022-01-01' = {
  name: 'allow-sql-from-onpremandspoke1'
  parent: nsg
  properties: {
    access: 'Allow'
    direction: 'Inbound'
    protocol: '*'
    sourceAddressPrefixes: [
      wthonpremvnet.properties.addressSpace.addressPrefixes[0]
      wthspoke1vnet.properties.addressSpace.addressPrefixes[0]
    ]
    destinationAddressPrefix: wthspoke1vnetpepsubnet.properties.addressPrefix
    priority: 100
    sourcePortRange: '*'
    destinationPortRange: '1433'
  }
}

resource nsgSecRuleAllowAppSvc 'Microsoft.Network/networkSecurityGroups/securityRules@2022-01-01' = {
  name: 'allow-sql-from-appsvcsubnet'
  parent: nsg
  properties: {
    access: 'Allow'
    direction: 'Inbound'
    protocol: '*'
    sourceAddressPrefix: wthspoke1vnetappsvcsubnet.properties.addressPrefix
    destinationAddressPrefix: wthspoke1vnetpepsubnet.properties.addressPrefix
    priority: 102
    sourcePortRange: '*'
    destinationPortRange: '1433'
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
    priority: 1000
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
        // Inspector Gadget settings for SQL connection - App Svc MSI must still be manually granted SQL access
        {
          name: 'DefaultSqlConnectionSqlConnectionString'
          value: replace('Server=<serverName>${environment().suffixes.sqlServerHostname},1433;Initial Catalog=sampleDB;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;', '<serverName>', sqlServer.name)
        }
        {
          name: 'DefaultSqlConnectionUseAzureManagedIdentity'
          value: 'true'
        }
      ]
    }
    httpsOnly: true
    virtualNetworkSubnetId: wthspoke1vnetappsvcsubnet.id
    vnetRouteAllEnabled: true
    publicNetworkAccess: 'Enabled'
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
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', wthspoke1vnet.name, wthspoke1vnetpepsubnet.name)
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

resource privateDnsZones 'Microsoft.Network/privateDnsZones@2018-09-01' existing = {
  name: 'privatelink.azurewebsites.net'
  scope: resourceGroup('wth-rg-hub')
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-03-01' = {
  parent: privateEndpoint_webapp
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

resource routeTable 'Microsoft.Network/routeTables@2022-07-01' = {
  name: 'wth-rt-sqlthroughafw'
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'route-sqlthroughafw'
        properties: {
          addressPrefix: wthspoke1vnetpepsubnet.properties.addressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: reference(afw.id, '2022-01-01').ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
}

resource route 'Microsoft.Network/routeTables/routes@2022-07-01' = {
  name: 'wth-rt-spoke1vmssubnet/route-sqlthroughafw'
  properties: {
    addressPrefix: wthspoke1vnetpepsubnet.properties.addressPrefix
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: reference(afw.id, '2022-01-01').ipConfigurations[0].properties.privateIPAddress
  }
}
