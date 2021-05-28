param baseName string = 'wth'


// Default location for the resources
var location = resourceGroup().location
var resourceSuffix = substring(concat(baseName, uniqueString(resourceGroup().id)), 0, 8)

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' existing = {
  name: 'appi-${resourceSuffix}'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-10-01' existing = {
  name: 'plan-${resourceSuffix}'
}

resource mysql 'Microsoft.DBForMySQL/servers@2017-12-01' existing = {
  name: 'mysql-${resourceSuffix}'
}

resource dashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: 'dashboard-${resourceSuffix}'
  location: location
  tags: {
    'hidden-title': 'WTH Java'
  }
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              colSpan: 4
              rowSpan: 3
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {
                content: {
                  options: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: appInsights.id
                          }
                          name: 'requests/duration'
                          aggregationType: 4 // avg
                          namespace: 'Microsoft.Insights/components'
                          metricVisualization: {
                            displayName: 'Server response time'
                            resourceDisplayName: appInsights.name
                          }
                        }
                      ]
                      title: 'Response time'
                      titleKind: 1
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                        disablePinning: true
                      }
                    }
                  }
                }
              }
            }
          }
          {
            position: {
              x: 4
              y: 0
              colSpan: 4
              rowSpan: 3
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {
                content: {
                  options: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: appInsights.id
                          }
                          name: 'requests/count'
                          aggregationType: 7 // count
                          namespace: 'Microsoft.Insights/components'
                          metricVisualization: {
                            displayName: 'Server requests'
                            resourceDisplayName: appInsights.name
                          }
                        }
                        {
                          resourceMetadata: {
                            id: appInsights.id
                          }
                          name: 'requests/failed'
                          aggregationType: 7 // count
                          namespace: 'Microsoft.Insights/components'
                          metricVisualization: {
                            displayName: 'Failed requests'
                            resourceDisplayName: appInsights.name
                          }
                        }
                      ]
                      title: 'Requests'
                      titleKind: 1
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                        disablePinning: true
                      }
                    }
                  }
                }
              }
            }
          }
          {
            position: {
              x: 0
              y: 3
              colSpan: 4
              rowSpan: 3
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {
                content: {
                  options: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: appServicePlan.id
                          }
                          name: 'CpuPercentage'
                          aggregationType: 4 // avg
                          namespace: 'Microsoft.Web/serverfarms'
                          metricVisualization: {
                            displayName: 'CPU Percentage'
                            resourceDisplayName: appServicePlan.name
                          }
                        }
                        {
                          resourceMetadata: {
                            id: appServicePlan.id
                          }
                          name: 'MemoryPercentage'
                          aggregationType: 4 // avg
                          namespace: 'Microsoft.Web/serverfarms'
                          metricVisualization: {
                            displayName: 'Memory Percentage'
                            resourceDisplayName: appServicePlan.name
                          }
                        }
                      ]
                      title: 'Server CPU/Memory'
                      titleKind: 1
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                        disablePinning: true
                      }
                    }
                  }
                }
              }
            }
          }
          {
            position: {
              x: 4
              y: 3
              colSpan: 4
              rowSpan: 3
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {
                content: {
                  options: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: mysql.id
                          }
                          name: 'cpu_percent'
                          aggregationType: 4 // avg
                          namespace: 'Microsoft.DBforMysql/servers'
                          metricVisualization: {
                            displayName: 'CPU Percentage'
                            resourceDisplayName: mysql.name
                          }
                        }
                        {
                          resourceMetadata: {
                            id: mysql.id
                          }
                          name: 'memory_percent'
                          aggregationType: 4 // avg
                          namespace: 'Microsoft.DBforMysql/servers'
                          metricVisualization: {
                            displayName: 'Memory Percentage'
                            resourceDisplayName: mysql.name
                          }
                        }
                      ]
                      title: 'Database CPU/Memory'
                      titleKind: 1
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                        disablePinning: true
                      }
                    }
                  }
                }
              }
            }
          }
        ]
      }
    ]
    metadata: {
      model: {
        timeRange: {
          value: {
            relative: {
              duration: 24
              timeUnit: 1
            }
          }
          type: 'MsPortalFx.Composition.Configuration.ValueTypes.TimeRange'
        }
        filterLocale: {
          value: 'en-us'
        }
        filters: {
          value: {
            MsPortalFx_TimeRange: {
              model: {
                format: 'utc'
                granularity: 'auto'
                relative: '1h'
              }
              displayCache: {
                name: 'UTC Time'
                value: 'Past hour'
              }
            }
          }
        }
      }
    }
  }
}
