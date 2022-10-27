param LawId string
param Location string
param Name string
param PipId string

var Id = resourceId('Microsoft.Network/loadBalancers', Name)

resource lb 'Microsoft.Network/loadBalancers@2020-07-01' = {
  name: Name
  location: Location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'LoadBalancerFrontEnd'
        properties: {
          publicIPAddress: {
            id: PipId
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'BackendPool1'
      }
    ]
    inboundNatPools: [
      {
        name: 'natpool'
        properties: {
          frontendIPConfiguration: {
            id: '${Id}/frontendIPConfigurations/loadBalancerFrontEnd'
          }
          protocol: 'Tcp'
          frontendPortRangeStart: 50000
          frontendPortRangeEnd: 50119
          backendPort: 3389
        }
      }
    ]
    probes: [
      {
        name: 'tcpProbe'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'LBRule'
        properties: {
          frontendIPConfiguration: {
            id: '${Id}/frontendIPConfigurations/LoadBalancerFrontEnd'
          }
          backendAddressPool: {
            id: '${Id}/backendAddressPools/BackendPool1'
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
          probe: {
            id: '${Id}/probes/tcpProbe'
          }
        }
      }
    ]
  }
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'diag-${lb.name}'
  scope: lb
  properties: {
    workspaceId: LawId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 31
        }
      }
    ]
  }
}

output BackendAddressPools array = lb.properties.backendAddressPools
output InboundNatPools array = lb.properties.inboundNatPools
