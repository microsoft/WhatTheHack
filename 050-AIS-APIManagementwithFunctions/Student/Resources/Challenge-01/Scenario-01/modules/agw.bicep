
@description('The name of the Application Gateway resource')
param app_gateway_name string

@description('The capacity (instance count) of the Application Gateway')
param app_gateway_capacity int

@description('The name of the API Management resource')
param apim_name string

@description('The reference to the Public IP resource')
param publicIpId string

@description('The reference to the Public IP resource')
param pip_name string

@description('The reference to the Log Analytics workspace resource')
param log_analytics_workspace_id string

@description('The name of the virtual network resource')
param vnet_name string

@description('The location where the resource would be created')
param location string

resource appGatewayResource 'Microsoft.Network/applicationGateways@2021-05-01' = {
  name: app_gateway_name
  location: location
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
      capacity: app_gateway_capacity
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet_name, 'appGatewaySubnet')
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpId //public_ip_name.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'gatewayBackEnd'
        properties: {
          backendAddresses: [
            {
              fqdn: '${apim_name}.azure-api.net'
            }
          ]
        }
      }
      {
        name: 'devPortalBackend'
        properties: {
          backendAddresses: [
            {
              fqdn: '${apim_name}.developer.azure-api.net'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'apim-gateway-https-setting'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          hostName: '${apim_name}.azure-api.net'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', app_gateway_name, 'apim-gateway-probe')
          }
        }
      }
      {
        name: 'apim-devPortal-https-setting'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          hostName: '${apim_name}.developer.azure-api.net'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', app_gateway_name, 'apim-devPortal-probe')
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'apim-listener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontEndIPConfigurations', app_gateway_name, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontEndPorts', app_gateway_name, 'port_80')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
      {
        name: 'apim-devPortal-listener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontEndIPConfigurations', app_gateway_name, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontEndPorts', app_gateway_name, 'port_80')
          }
          protocol: 'Http'
          requireServerNameIndication: false
          hostName: 'dev.${pip_name}.${location}.cloudapp.azure.com'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'apim-routing-rule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', app_gateway_name, 'apim-listener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', app_gateway_name, 'gatewayBackEnd')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', app_gateway_name, 'apim-gateway-https-setting')
          }
        }
      }
      {
        name: 'apim-devPortal-routing-rule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', app_gateway_name, 'apim-devPortal-listener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', app_gateway_name, 'devPortalBackend')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', app_gateway_name, 'apim-devPortal-https-setting')
          }
        }
      }
    ]
    probes: [
      {
        name: 'apim-gateway-probe'
        properties: {
          protocol: 'Https'
          host: '${apim_name}.azure-api.net'
          port: 443
          path: '/status-0123456789abcdef'
          interval: 30
          timeout: 120
          unhealthyThreshold: 8
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
        }
      }
      {
        name: 'apim-devPortal-probe'
        properties: {
          protocol: 'Https'
          host: '${apim_name}.developer.azure-api.net'
          port: 443
          path: '/signin'
          interval: 30
          timeout: 120
          unhealthyThreshold: 8
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
        }
      }
    ]
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Detection'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
    }
  }
}

resource Microsoft_Insights_diagnosticSettings_logToAnalytics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope: appGatewayResource
  name: 'logToAnalytics'
  properties: {
    workspaceId: log_analytics_workspace_id
    logs: [
      {
        category: 'ApplicationGatewayAccessLog'
        enabled: true
      }
      {
        category: 'ApplicationGatewayPerformanceLog'
        enabled: true
      }
      {
        category: 'ApplicationGatewayFirewallLog'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}
