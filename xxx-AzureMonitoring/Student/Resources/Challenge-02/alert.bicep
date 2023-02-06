param ActionGroupResourceId string = '<your-action-group-id>'
param ActivityLogAlertName string = 'alert-vm-stopped'

resource activityLogAlerts_name_resource 'microsoft.insights/activityLogAlerts@2017-04-01' = {
  name: ActivityLogAlertName
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
          actionGroupId: ActionGroupResourceId
          webhookProperties: {}
        }
      ]
    }
    enabled: true
  }
}
