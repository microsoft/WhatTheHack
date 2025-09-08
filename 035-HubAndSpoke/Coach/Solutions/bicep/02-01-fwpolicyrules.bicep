resource wthafwpolicy 'Microsoft.Network/firewallPolicies@2022-01-01' existing = {
  name: 'wth-fwp-policy01'
  scope: resourceGroup('wth-rg-hub')
}

resource wthafwpip01 'Microsoft.Network/publicIPAddresses@2022-01-01' existing = {
  name: 'wth-pip-afw01'
  scope: resourceGroup('wth-rg-hub')
}

resource wthhubvmnic 'Microsoft.Network/networkInterfaces@2022-01-01' existing = {
  name: 'wth-nic-hubvm01'
  scope: resourceGroup('wth-rg-hub')
}

resource wthspoke1vmnic 'Microsoft.Network/networkInterfaces@2022-01-01' existing = {
  name: 'wth-nic-spoke1vm01'
  scope: resourceGroup('wth-rg-spoke1')
}

resource wthspoke2vmnic 'Microsoft.Network/networkInterfaces@2022-01-01' existing = {
  name: 'wth-nic-spoke2vm01'
  scope: resourceGroup('wth-rg-spoke2')
}

resource wthafwrcgdnat 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-01-01' = {
  name: '${wthafwpolicy.name}/WTH_DNATRulesCollectionGroup'
  properties: {
    priority: 100
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyNatRuleCollection'
        action: {
          type: 'DNAT'
        }
        name: 'dnat-webservers-http'
        priority: 100
        rules: [
          {
            name: 'dnat-tcp8080-to-hub-80'
            ruleType: 'NatRule'
            description: 'DNAT port 8080 to hub'
            destinationAddresses: [
              wthafwpip01.properties.ipAddress
            ]
            destinationPorts: [
              '8080'
            ]
            ipProtocols: [
              'tcp'
            ]
            sourceAddresses: [
              '*'
            ]
            translatedAddress: wthhubvmnic.properties.ipConfigurations[0].properties.privateIPAddress
            translatedPort: '80'
          }
          {
            name: 'dnat-tcp8081-to-spoke1-80'
            ruleType: 'NatRule'
            description: 'DNAT port 8081 to Spoke1'
            destinationAddresses: [
              wthafwpip01.properties.ipAddress
            ]
            destinationPorts: [
              '8081'
            ]
            ipProtocols: [
              'tcp'
            ]
            sourceAddresses: [
              '*'
            ]
            translatedAddress: wthspoke1vmnic.properties.ipConfigurations[0].properties.privateIPAddress
            translatedPort: '80'
          }
          {
            name: 'dnat-tcp8082-to-spoke1-80'
            ruleType: 'NatRule'
            description: 'DNAT port 8082 to Spoke2'
            destinationAddresses: [
              wthafwpip01.properties.ipAddress
            ]
            destinationPorts: [
              '8082'
            ]
            ipProtocols: [
              'tcp'
            ]
            sourceAddresses: [
              '*'
            ]
            translatedAddress: wthspoke2vmnic.properties.ipConfigurations[0].properties.privateIPAddress
            translatedPort: '80'
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyNatRuleCollection'
        action: {
          type: 'DNAT'
        }
        name: 'dnat-rdp'
        priority: 101
        rules: [
          {
            name: 'dnat-tcp33890-to-hub-33899'
            ruleType: 'NatRule'
            description: 'DNAT port 33891 to hub'
            destinationAddresses: [
              wthafwpip01.properties.ipAddress
            ]
            destinationPorts: [
              '33890'
            ]
            ipProtocols: [
              'tcp'
            ]
            sourceAddresses: [
              '*'
            ]
            translatedAddress: wthhubvmnic.properties.ipConfigurations[0].properties.privateIPAddress
            translatedPort: '33899'
          }
          {
            name: 'dnat-tcp33891-to-spoke1-33899'
            ruleType: 'NatRule'
            description: 'DNAT port 33891 to Spoke1'
            destinationAddresses: [
              wthafwpip01.properties.ipAddress
            ]
            destinationPorts: [
              '33891'
            ]
            ipProtocols: [
              'tcp'
            ]
            sourceAddresses: [
              '*'
            ]
            translatedAddress: wthspoke1vmnic.properties.ipConfigurations[0].properties.privateIPAddress
            translatedPort: '33899'
          }
          {
            name: 'dnat-tcp33892-to-spoke1-33899'
            ruleType: 'NatRule'
            description: 'DNAT port 33892 to Spoke2'
            destinationAddresses: [
              wthafwpip01.properties.ipAddress
            ]
            destinationPorts: [
              '33892'
            ]
            ipProtocols: [
              'tcp'
            ]
            sourceAddresses: [
              '*'
            ]
            translatedAddress: wthspoke2vmnic.properties.ipConfigurations[0].properties.privateIPAddress
            translatedPort: '33899'
          }
        ]
      }
    ]
  }
}

resource wthafwrcgnet 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-01-01' = {
  name: '${wthafwpolicy.name}/WTH_NetworkRulesCollectionGroup'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        name: 'allow-network-rules'
        priority: 200
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'allow-any-to-any'
            description: 'Allow any traffic to any destination'
            destinationAddresses: [
              '*'
            ]
            destinationPorts: [
              '*'
            ]
            sourceAddresses: [
              '*'
            ]
            ipProtocols: [
              'Any'
            ]
          }
        ]
      }
    ]
  }
  dependsOn: [
    wthafwrcgdnat
  ]
}

resource wthafwrcgapp 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-01-01' = {
  name: '${wthafwpolicy.name}/WTH_AppRulesCollectionGroup'
  properties: {
    priority: 300
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        priority: 300
        name: 'allow-apprules'
        rules: []
      }
    ]
  }
  dependsOn: [
    wthafwrcgnet
  ]
}
