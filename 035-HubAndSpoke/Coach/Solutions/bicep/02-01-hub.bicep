param location string = 'eastus2'

resource wthafw 'Microsoft.Network/azureFirewalls@2022-01-01' existing = {
  name: 'wth-afw-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource wthhubvm01 'Microsoft.Compute/virtualMachines@2022-03-01' existing = {
  name: 'wth-vm-hub01'
  scope: resourceGroup('wth-rg-hub')
}

resource rthubvms 'Microsoft.Network/routeTables@2022-01-01' = {
  name: 'wth-rt-hubvmssubnet'
  location: location
  properties: {
    routes: [
      {
        name: 'route-all-to-afw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress

        }
      }
      {
        name: 'route-onprem-to-afw'
        properties: {
          addressPrefix: '172.16.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
      {
        name: 'route-afw-to-vnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: wthafw.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
    disableBgpRoutePropagation: true
  }
}

resource installinspectorgadget 'Microsoft.Compute/virtualMachines/runCommands@2022-03-01' = {
  name: '${wthhubvm01.name}/wth-runcmd-installinspectorgadget'
  location: location
  properties: {
    asyncExecution: true
    source: {

            /*
      To generate encoded command in PowerShell: 

      $s = @'
        Install-WindowsFeature Web-Server,Web-Asp-Net45 -IncludeManagementTools
        [System.Net.WebClient]::new().DownloadFile('https://raw.githubusercontent.com/jelledruyts/InspectorGadget/main/Page/default.aspx','c:\inetpub\wwwroot\default.aspx')
      '@
      $bytes = [System.Text.Encoding]::Unicode.GetBytes($s)
      [convert]::ToBase64String($bytes) */
      script: 'powershell.exe -ep bypass -encodedcommand IAAgACAAIAAgACAAIAAgAEkAbgBzAHQAYQBsAGwALQBXAGkAbgBkAG8AdwBzAEYAZQBhAHQAdQByAGUAIABXAGUAYgAtAFMAZQByAHYAZQByACwAVwBlAGIALQBBAHMAcAAtAE4AZQB0ADQANQAgAC0ASQBuAGMAbAB1AGQAZQBNAGEAbgBhAGcAZQBtAGUAbgB0AFQAbwBvAGwAcwAKACAAIAAgACAAIAAgACAAIABbAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdABdADoAOgBuAGUAdwAoACkALgBEAG8AdwBuAGwAbwBhAGQARgBpAGwAZQAoACcAaAB0AHQAcABzADoALwAvAHIAYQB3AC4AZwBpAHQAaAB1AGIAdQBzAGUAcgBjAG8AbgB0AGUAbgB0AC4AYwBvAG0ALwBqAGUAbABsAGUAZAByAHUAeQB0AHMALwBJAG4AcwBwAGUAYwB0AG8AcgBHAGEAZABnAGUAdAAvAG0AYQBpAG4ALwBQAGEAZwBlAC8AZABlAGYAYQB1AGwAdAAuAGEAcwBwAHgAJwAsACcAYwA6AFwAaQBuAGUAdABwAHUAYgBcAHcAdwB3AHIAbwBvAHQAXABkAGUAZgBhAHUAbAB0AC4AYQBzAHAAeAAnACkA'
    }
    timeoutInSeconds: 600
  }
}
