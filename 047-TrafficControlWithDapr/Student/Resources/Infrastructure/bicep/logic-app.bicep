param logicAppName string
param location string
param logAnalyticsWorkspaceName string

var connectionName = 'office365'

resource logicAppConnection 'Microsoft.Web/connections@2016-06-01' = {
  name: connectionName
  location: location
  properties: {
    displayName: 'emailSender@azure.com'
    api: {
      #disable-next-line use-resource-id-functions
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/${connectionName}'
    }
  }
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  dependsOn: [
    logicAppConnection
  ]
  location: location
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: {
        Parse_JSON: {
          inputs: {
            content: '@triggerBody()'
            schema: {
              properties: {
                body: {
                  type: 'string'
                }
                from: {
                  type: 'string'
                }
                subject: {
                  type: 'string'
                }
                to: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
          runAfter: {}
          type: 'ParseJson'
        }
        'Send_an_email_(V2)': {
          inputs: {
            body: {
              Body: '<p>@{body(\'Parse_JSON\')?[\'body\']}</p>'
              Subject: '@body(\'Parse_JSON\')?[\'subject\']'
              To: '@body(\'Parse_JSON\')?[\'to\']'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'office365\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/v2/Mail'
          }
          runAfter: {
            Parse_JSON: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
        }
      }
      contentVersion: '1.0.0.0'
      outputs: {}
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        manual: {
          inputs: {}
          kind: 'Http'
          type: 'Request'
        }
      }
    }
    parameters: {
      '$connections': {
        value: {
          office365: {
            connectionId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/connections/${connectionName}'
            connectionName: connectionName
            id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis/${connectionName}'
          }
        }
      }
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: logicApp
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'WorkflowRuntime'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output logicAppName string = logicApp.name
output logicAppAccessEndpoint string = logicApp.properties.accessEndpoint
