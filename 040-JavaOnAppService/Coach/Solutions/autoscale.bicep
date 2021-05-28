param baseName string = 'wth'

// Default location for the resources
var location = resourceGroup().location
var resourceSuffix = substring(concat(baseName, uniqueString(resourceGroup().id)), 0, 8)

resource appServicePlan 'Microsoft.Web/serverfarms@2020-10-01' existing = {
  name: 'plan-${resourceSuffix}'
}

resource autoscale 'Microsoft.Insights/autoscalesettings@2015-04-01' = {
  name: 'autoscale-${resourceSuffix}'
  location: location
  properties: {
    targetResourceUri: appServicePlan.id
    enabled: true
    profiles: [
      {
        name: 'CPU bound autoscale'
        capacity: {
          minimum: '1'
          maximum: '4'
          default: '1'
        }
        rules: [
          {
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1M'
            }
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricNamespace: 'Microsoft.Web/serverfarms'
              metricResourceUri: appServicePlan.id
              operator: 'GreaterThan'
              statistic: 'Average'
              threshold: 60
              timeAggregation: 'Average'
              timeGrain: 'PT1M'
              timeWindow: 'PT5M'
            }
          }
          {
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1M'
            }
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricNamespace: 'Microsoft.Web/serverfarms'
              metricResourceUri: appServicePlan.id
              operator: 'LessThan'
              statistic: 'Average'
              threshold: 30
              timeAggregation: 'Average'
              timeGrain: 'PT1M'
              timeWindow: 'PT5M'
            }
          }
        ]
      }
    ]
  }
}
