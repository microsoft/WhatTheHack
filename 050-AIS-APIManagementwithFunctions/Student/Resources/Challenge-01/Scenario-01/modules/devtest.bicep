@description('The location where the resource would be created')
param location string

@description('The jumpbox VM name')
param virtualMachineName string

@description('The jumpbox VM resource id')
param virtualMachineResourceId string

@description('The VM auto-shutdown status')
param autoShutdownStatus string

@description('The VM auto-shutdown time')
param autoShutdownTime string

@description('The VM auto-shutdown time zone')
param autoShutdownTimeZone string

resource vmAutoShutdownSchedule 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${virtualMachineName}'
  location: location
  properties: {
    status: autoShutdownStatus
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: autoShutdownTime
    }
    timeZoneId: autoShutdownTimeZone
    targetResourceId: virtualMachineResourceId
  }
}
