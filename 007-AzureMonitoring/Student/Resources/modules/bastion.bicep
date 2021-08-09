param Location string
param PipId string
param SubnetId string

resource bastion 'Microsoft.Network/bastionHosts@2020-07-01' = {
  name: 'bastion-wth-monitor-d-eus'
  location: Location
  properties: {
    ipConfigurations: [
      {
        properties: {
          subnet: {
            id: SubnetId
          }
          publicIPAddress: {
            id: PipId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
        name: 'IpConfig'
      }
    ]
  }
}
