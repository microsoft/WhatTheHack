param Location string
param Name string
param NodeResourceGroup string
param OmsWorkspaceId string
param SubnetId string

resource aks 'Microsoft.ContainerService/managedClusters@2021-02-01' = {
  name: Name
  location: Location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enableRBAC: true
    dnsPrefix: 'aks'
    addonProfiles:{
      httpApplicationRouting: {
        enabled: true
      }
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: OmsWorkspaceId
        }
      }
    }
    agentPoolProfiles: [
      {
        name: 'agentpool01'
        count: 1
        mode: 'System'
        vmSize: 'Standard_D2_v3'
        type: 'VirtualMachineScaleSets'
        osType: 'Linux'
        osDiskSizeGB: 0
        enableAutoScaling: false
        vnetSubnetID: SubnetId
        maxPods: 30
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    nodeResourceGroup: NodeResourceGroup
    networkProfile: {
      networkPlugin: 'kubenet'
      loadBalancerSku: 'standard'
      serviceCidr: '10.240.0.0/16'
      dnsServiceIP: '10.240.0.10'
      dockerBridgeCidr: '172.17.0.1/16'

    }
  }
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
}

output id string = aks.id
output apiServerAddress string = aks.properties.fqdn
output aksName string = aks.name
