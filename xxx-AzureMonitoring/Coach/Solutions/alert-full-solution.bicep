param actionGroupResourceId string = '<your-action-group-resource-id>'
param vmLocation string = resourceGroup().location
param activityLogAlertNameVmStop string = 'alert-vm-stopped'
param metricAlertNameCPU string = 'alert-cpu-over-75-percent'
param metricAlertNameNetwork string = 'alert-network-in'
param activityLogAlertNameSH string = 'alert-service-health'
param metricAlertNameDisk string = 'alert-disk-write-over-20'

resource activityLogAlertsVmStopped 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: activityLogAlertNameVmStop
  location: 'global'
  properties: {
    scopes: [
      resourceGroup().id
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'Administrative'
        }
        {
          field: 'operationName'
          equals: 'Microsoft.Compute/virtualMachines/deallocate/action'
        }
        {
          field: 'resourceType'
          equals: 'Microsoft.Compute/virtualMachines'
        }
      ]
    }
    actions: {
      actionGroups: [
        {
          actionGroupId: actionGroupResourceId
          webhookProperties: {}
        }
      ]
    }
    enabled: true
    description: 'Alert when a VM is deallocated'
  }
}

resource activityLogAlertsServiceHealth 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: activityLogAlertNameSH
  location: 'global'
  properties: {
    scopes: [
      subscription().id
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ServiceHealth'
        }
        {
          field: 'properties.incidentType'
          equals: 'Incident'
        }
      ]
    }
    actions: {
      actionGroups: [
        {
          actionGroupId: actionGroupResourceId
          webhookProperties: {}
        }
      ]
    }
    enabled: true
    description: 'Alert when a Service Health incident happens'
  }
}

resource metricAlertCpu 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertNameCPU
  location: 'global'

  properties: {
    actions: [
      {
        actionGroupId: actionGroupResourceId
        webHookProperties: {}
      }
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: []
          metricName: 'Percentage CPU'
          name: 'MetricCPU'
          operator: 'GreaterThan'
          threshold: 75
          timeAggregation: 'Average'
        }
      ]
    }
    description: 'Alert for CPU Usage over 75 percent'
    enabled: true
    evaluationFrequency: 'PT5M'
    scopes: [
      resourceGroup().id
    ]
    severity: 2
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    targetResourceRegion: vmLocation
    windowSize: 'PT5M'
  }
}

resource metricAlertNetwork 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertNameNetwork
  location: 'global'

  properties: {
    actions: [
      {
        actionGroupId: actionGroupResourceId
        webHookProperties: {}
      }
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: []
          metricName: 'Network In'
          name: 'MetricNetIn'
          operator: 'GreaterThan'
          threshold: 4000000
          timeAggregation: 'Average'
        }
      ]
    }
    description: 'Network In metric has detected a large amount of inbound traffic'
    enabled: true
    evaluationFrequency: 'PT5M'
    scopes: [
      resourceGroup().id
    ]
    severity: 3
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    targetResourceRegion: vmLocation
    windowSize: 'PT5M'
  }
}

resource metricAlertDisk 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertNameDisk
  location: 'global'

  properties: {
    actions: [
      {
        actionGroupId: actionGroupResourceId
        webHookProperties: {}
      }
    ]
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: []
          metricName: 'Disk Write Operations/Sec'
          name: 'MetricDiskWriteSec'
          operator: 'GreaterThan'
          threshold: 20
          timeAggregation: 'Average'
        }
      ]
    }
    description: 'Disk Write Operations/Sec over 20'
    enabled: true
    evaluationFrequency: 'PT5M'
    scopes: [
      resourceGroup().id
    ]
    severity: 3
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    targetResourceRegion: vmLocation
    windowSize: 'PT5M'
  }
}
