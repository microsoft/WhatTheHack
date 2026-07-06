@description('Name of the subnet')
param subnetName string = 'ApplicationGatewaySubnet'

@description('Application Gateway name')
param applicationGatewayName string = 'wth-appgw-hub01'

@description('Minimum instance count for Application Gateway')
param minCapacity int = 1

@description('Maximum instance count for Application Gateway')
param maxCapacity int = 2

@description('Application Gateway Frontend port')
param frontendPort int = 80

@description('Application gateway Backend port')
param backendPort int = 80

@description('Secret identifier for AppGW TLS private key - ex: https://<keyvaultname>.vault.azure.net/secrets/<certname>/<certVersionId>')
param TLSCertKeyVaultSecretID string // = 'https://wthotlxegowqsmac.vault.azure.net/secrets/wildcard/0de83a6671604affabc155af5bea1d7f'

resource wthspoke1vmnic 'Microsoft.Network/networkInterfaces@2022-01-01' existing = {
  name: 'wth-nic-spoke1vm01'
  scope: resourceGroup('wth-rg-spoke1')
}

resource wthspoke2vmnic 'Microsoft.Network/networkInterfaces@2022-01-01' existing = {
  name: 'wth-nic-spoke2vm01'
  scope: resourceGroup('wth-rg-spoke2')
}

@description('Back end pool ip addresses')
var backendIPAddresses = [
  {
    ipAddress: wthspoke1vmnic.properties.ipConfigurations[0].properties.privateIPAddress
  }
  {
    ipAddress: wthspoke2vmnic.properties.ipConfigurations[0].properties.privateIPAddress
  }
]

@description('Cookie based affinity')
@allowed([
  'Enabled'
  'Disabled'
])
param cookieBasedAffinity string = 'Disabled'

@description('Location for all resources.')
param location string = resourceGroup().location

var appGwSize = 'Standard_v2'

resource hubvnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: 'wth-vnet-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource hubappgwsubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: '${hubvnet.name}/ApplicationGatewaySubnet'
  properties: {
    addressPrefix: '10.0.2.0/24'
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'wth${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    enableSoftDelete: true
    enablePurgeProtection: true
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
    accessPolicies: [
      {
        objectId: userAssignedIdentity.properties.principalId
        permissions: {
          secrets: [
            'all'
          ]
        }
        tenantId: tenant().tenantId
      }
    ]
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: 'wth-pip-appgw01'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'wth-umsi-appgw01'
  location: location
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2020-06-01' = {
  name: applicationGatewayName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    sku: {
      name: appGwSize
      tier: 'Standard_v2'
    }
    autoscaleConfiguration: {
      minCapacity: minCapacity
      maxCapacity: maxCapacity
    }
    sslCertificates: [
      {
        name: 'wth_certificate'
        properties: {
          keyVaultSecretId: TLSCertKeyVaultSecretID
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', hubvnet.name, subnetName)
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'appGatewayFrontendPort'
        properties: {
          port: frontendPort
        }
      }
      {
        name: 'appGatewayFrontendPortHttps'
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'appGatewayBackendPool'
        properties: {
          backendAddresses: backendIPAddresses
        }
      }
      {
        name: 'appGatewayBackendPoolSpoke1'
        properties: {
          backendAddresses: [
            { ipAddress: wthspoke1vmnic.properties.ipConfigurations[0].properties.privateIPAddress }
          ]
        }
      }
      {
        name: 'appGatewayBackendPoolSpoke2'
        properties: {
          backendAddresses: [
            { ipAddress: wthspoke2vmnic.properties.ipConfigurations[0].properties.privateIPAddress }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appGatewayBackendHttpSettings'
        properties: {
          port: backendPort
          protocol: 'Http'
          cookieBasedAffinity: cookieBasedAffinity
        }
      }
      {
        name: 'appGatewayBackendHttpSettingsSpokes'
        properties: {
          port: backendPort
          protocol: 'Http'
          cookieBasedAffinity: cookieBasedAffinity
          path: '/'
        }
      }
    ]
    httpListeners: [
      {
        name: 'appGatewayHttpListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'appGatewayFrontendIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'appGatewayFrontendPort')
          }
          protocol: 'Http'
        }
      }
      {
        name: 'appGatewayHttpsListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'appGatewayFrontendIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'appGatewayFrontendPortHttps')
          }
          protocol: 'Https'
          sslCertificate: {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', applicationGatewayName, 'wth_certificate')
          }
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'requestRoutingRuleDefault'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'appGatewayHttpListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'appGatewayBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'appGatewayBackendHttpSettings')
          }
        }
      }
      {
        name: 'requestRoutingRuleSpokes'
        properties: {
          ruleType: 'PathBasedRouting'
          urlPathMap: {
            id: resourceId('Microsoft.Network/applicationGateways/urlPathMaps', applicationGatewayName, 'urlPathMapSpokes')
          }
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'appGatewayHttpsListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'appGatewayBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'appGatewayBackendHttpSettings')
          }
        }
      }
    ]
    urlPathMaps: [
      {
        name: 'urlPathMapSpokes'
        properties: {
          defaultBackendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'appGatewayBackendPool')
          }
          defaultBackendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'appGatewayBackendHttpSettings')
          }
          pathRules: [
            {
              name: 'spoke1'
              properties: {
                paths: [
                  '/spoke1/*'
                ]
                backendAddressPool: {
                  id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'appGatewayBackendPoolSpoke1')
                }
                backendHttpSettings: {
                  id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'appGatewayBackendHttpSettingsSpokes')
                }
              }
            }
            {
              name: 'spoke2'
              properties: {
                paths: [
                  '/spoke2/*'
                ]
                backendAddressPool: {
                  id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'appGatewayBackendPoolSpoke2')
                }
                backendHttpSettings: {
                  id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'appGatewayBackendHttpSettingsSpokes')
                }
              }
            }
          ]
        }
      }
    ]
    enableHttp2: true
  }
}
