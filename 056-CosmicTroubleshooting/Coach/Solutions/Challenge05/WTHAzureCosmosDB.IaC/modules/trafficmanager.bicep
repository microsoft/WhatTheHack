@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param uniqueDnsName string

param tmName string
param primaryEndpointName string
param secondaryEndpointName string
param primaryEndpointUrl string
param primaryEndpointLocation string
param secondaryEndpointUrl string
param secondaryEndpointLocation string

resource webAppPrimary 'Microsoft.Web/sites@2022-03-01' existing = {
  name: primaryEndpointName
}

resource webAppSecondary 'Microsoft.Web/sites@2022-03-01' existing = {
  name: secondaryEndpointName
}

resource tmprofile 'Microsoft.Network/trafficmanagerprofiles@2018-08-01' = {
  name: tmName
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Performance'
    dnsConfig: {
      relativeName: uniqueDnsName
      ttl: 30
    }
    monitorConfig: {
      protocol: 'HTTPS'
      port: 443
      path: '/'
      expectedStatusCodeRanges: [
        {
          min: 200
          max: 202
        }
        {
          min: 301
          max: 302
        }
      ]
    }
    endpoints: [
      {
        type: 'Microsoft.Network/TrafficManagerProfiles/AzureEndpoints'
        name: 'endpoint1'
        properties: {
          target: primaryEndpointUrl
          endpointStatus: 'Enabled'
          endpointLocation: primaryEndpointLocation
          targetResourceId: webAppPrimary.id
        }
      }
      {
        type: 'Microsoft.Network/TrafficManagerProfiles/AzureEndpoints'
        name: 'endpoint2'
        properties: {
          target: secondaryEndpointUrl
          endpointStatus: 'Enabled'
          endpointLocation: secondaryEndpointLocation
          targetResourceId: webAppSecondary.id
        }
      }
    ]
  }
}
