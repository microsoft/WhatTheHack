@description('naming prefix')
param resourcePrefix string

@description('Number of VM instances (100 or less).')
@maxValue(100)
param vmssInstanceCount int = 2

@description('Subnet Resource ID')
param subnetRef string 

@description('User name for the Virtual Machine.')
param adminUsername string 

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string

@description('The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version. Allowed values: 12.04.5-LTS, 14.04.2-LTS, 15.10.')
@allowed([
  '12.04.5-LTS'
  '14.04.2-LTS'
  '15.10'
  '16.04-LTS'
  '18.04-LTS'
])
param ubuntuOSVersion string = '18.04-LTS'

@description('custom script extention body.')
param customScript string

param forceUpdateTag string = utcNow()

var prefix = '${resourcePrefix}-${uniqueString(resourceGroup().id)}'
var publicIPAddressType = 'Static'
var publicIPAddressName = '${prefix}-pip'
var dnsNameForPublicIP = '${prefix}-dns'

var loadBalancerFrontendIPConfigurationName = 'loadBalancerFrontEnd'
var loadBalancerName = '${prefix}-lb'
var loadBalancerBackendPoolName = 'loadBalancerBackend'
var loadBalancerProbeName = 'tcpProbe'

var vmssName = '${prefix}-vmss'
var vmssAutoScaleSettingName = '${prefix}-vmss-autoscale'
var vmssNicName = '${prefix}-vm-nic'

var vmSize = 'Standard_A0'
var osType = {
  publisher: 'Canonical'
  offer: 'UbuntuServer'
  sku: ubuntuOSVersion
  version: 'latest'
}
var imageReference = osType
var inboundNatPoolName = 'SSH'

// Public IP address for front-end of load balancer.
resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIPAddressName
  sku: {
    name: 'Standard'
  }
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: publicIPAddressType
    dnsSettings: {
      domainNameLabel: dnsNameForPublicIP
    }
  }
}

// Load balancer.
resource loadBalancer 'Microsoft.Network/loadBalancers@2020-06-01' = {
  name: loadBalancerName
  sku: {
    name: 'Standard'
  }
  location: resourceGroup().location
  properties: {
    frontendIPConfigurations: [
      {
        name: loadBalancerFrontendIPConfigurationName
        properties: {
          publicIPAddress: {
            id: publicIPAddress.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: loadBalancerBackendPoolName
      }
    ]
    inboundNatPools: [
      {
        name: inboundNatPoolName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancerName, loadBalancerFrontendIPConfigurationName)
          }
          protocol: 'Tcp'
          frontendPortRangeStart: 10022
          frontendPortRangeEnd: 10050
          backendPort: 22
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'LBRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancerName, loadBalancerFrontendIPConfigurationName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, loadBalancerBackendPoolName)
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', loadBalancerName, loadBalancerProbeName)
          }
        }
      }
    ]
    probes: [
      {
        name: loadBalancerProbeName
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
  }
}

// Virtual machine scale set.
resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2020-06-01' = {
  name: vmssName
  location: resourceGroup().location
  sku: {
    name: vmSize
    tier: 'Standard'
    capacity: vmssInstanceCount
  }
  properties: {
    overprovision: false
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          caching: 'ReadOnly'
          createOption: 'FromImage'
        }
        imageReference: imageReference
      }
      osProfile: {
        computerNamePrefix: resourcePrefix
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: vmssNicName
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig1'
                  properties: {
                    subnet: {
                      id: subnetRef
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: '${loadBalancer.id}/backendAddressPools/${loadBalancerBackendPoolName}'
                      }
                    ]
                    loadBalancerInboundNatPools: [
                      {
                        id: '${loadBalancer.id}/inboundNatPools/${inboundNatPoolName}'
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
      extensionProfile: {
        extensions: [
          {
            name: 'vmcustomscript'
            properties: {
              autoUpgradeMinorVersion: true
              typeHandlerVersion: '2.1'
              publisher: 'Microsoft.Azure.Extensions'
              type: 'CustomScript'
              forceUpdateTag: forceUpdateTag
              settings: {
                skipDos2Unix: false
                script: customScript != '' ? base64(customScript) : ''
              }
            }
          }
        ]
      }
    }
  }
}

// Autoscale for virtual machine scale set.
resource autoscalehost 'Microsoft.Insights/autoscaleSettings@2015-04-01' = {
  name: vmssAutoScaleSettingName
  location: resourceGroup().location
  properties: {
    name: vmssAutoScaleSettingName
    targetResourceUri: vmss.id
    enabled: true
    profiles: [
      {
        name: 'CPUProfile'
        capacity: {
          minimum: '1'
          maximum: '10'
          default: '1'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricNamespace: ''
              metricResourceUri: vmss.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 90
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1M'
            }
          }
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricNamespace: ''
              metricResourceUri: vmss.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 30
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1M'
            }
          }
        ]
      }
    ]
  }
}

output loadBalancerFqdn string = publicIPAddress.properties.dnsSettings.fqdn
