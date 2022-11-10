param AppInsightsName string
param Location string

resource billing 'microsoft.insights/components/CurrentBillingFeatures@2015-05-01' = {
  name: '${AppInsightsName}/Basic'
  location: Location
  properties: {
    CurrentBillingFeatures: 'Basic'
    DataVolumeCap: {
      Cap: 100
      WarningThreshold: 90
      ResetTime: 24
    }
  }
}
