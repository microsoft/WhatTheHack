# Challenge 9: Automate AVD Tasks

[< Previous Challenge](./08-Plan-Implement-BCDR.md) - **[Home](./README.md)** - [Next Challenge>](./10-Monitor-Manage-Performance-Health.md)

## Notes & Guidance

To complete the tasks in this challenge, students should use Azure Cloud Shell to run the commands below:

### 1. Replace the AVD session hosts in the UK South host pool with a new image

1.1: Turn drain mode on for the session hosts using PowerShell.

```powershell
Update-AzWvdSessionHost -ResourceGroupName 'rg-wth-avd-d-uks' -HostPoolName <Host Pool Name> -Name <Session Host Name> -AllowNewSession:$false
```

1.2: Validate no sessions exist on the session hosts using PowerShell.

```powershell
Get-AzWvdUserSession -ResourceGroupName 'rg-wth-avd-d-uks' -HostPoolName <Host Pool Name> -SessionHostName <Session Host Name>
```

1.3: Remove all the session hosts from the host pool using PowerShell.

```powershell
Remove-AzWvdSessionHost -ResourceGroupName 'rg-wth-avd-d-uks' -HostPoolName <Host Pool Name> -SessionHostName <Session Host Name>
```

1.4: Delete the session hosts using Azure CLI.

```shell
az vm delete --resource-group "rg-wth-avd-d-uks" --name <Virtual Machine Name> --yes
```

1.5: Get the registration key using Azure CLI.

```shell
az desktopvirtualization hostpool update --resource-group "rg-wth-avd-d-uks" --name <Host Pool Name> --registration-info expiration-time="<date time>" registration-token-operation="Update"
```

1.6: Deploy new session hosts using Azure CLI and an ARM Template.

[ARM template example](https://raw.githubusercontent.com/Azure/RDS-Templates/master/ARM-wvd-templates/AddVirtualMachinesToHostPool/AddVirtualMachinesTemplate.json)

```shell
az group deployment create --resource-group "rg-wth-avd-d-uks" --template-uri <URI>

# OR

az group deployment create --resource-group "rg-wth-avd-d-uks" --template-file <File Path>
```

### 2. Update properties on the East US host pool

2.1: Reset all the custom RDP properties on the host pool using Azure CLI.

```shell
az desktopvirtualization hostpool update --resource-group "rg-wth-avd-d-eus" --name <Host Pool Name> --custom-rdp-property ""
```

2.2: Add the following RDP properties using Azure CLI: enable camera redirection, enable microphone redirection, and disable multiple display support.

```shell
az desktopvirtualization hostpool update --resource-group "rg-wth-avd-d-eus" --name <Host Pool Name> --custom-rdp-property "audiocapturemode:i:1;camerastoredirect:s:*;use multimon:i:0;"
```

2.3: Change the load balancing algorithm to breadth-first using Azure CLI.

```shell
az desktopvirtualization hostpool update --resource-group "rg-wth-avd-d-eus" --name <Host Pool Name> --load-balancer-type DepthFirst
```

### 3. Publish a Remote App on the UK South host pool

3.1: Create an application group called "Monet" using Azure CLI.

```shell
az desktopvirtualization applicationgroup create --resource-group "rg-wth-avd-d-uks" --name <App Group Name> --application-group-type RemoteApp --host-pool-arm-path <Resource ID for Host Pool> --location <Azure region>
```

3.2: Publish Paint as an application in the Monet application group using PowerShell.

```powershell
New-AzWvdApplication -ResourceGroupName 'rg-wth-avd-d-uks' -GroupName Monet -Name Paint -FilePath 'C:\windows\system32\mspaint.exe' -IconIndex 0 -IconPath 'C:\windows\system32\mspaint.exe' -CommandLineSetting 'Allow' -ShowInPortal:$true
```

3.3: Change the display name for the Paint app to "Monet" using PowerShell.

```powershell
Update-AzWvdApplication -ResourceGroupName 'rg-wth-avd-d-uks' -GroupName Monet -Name Paint -FriendlyName 'Monet'
```

3.4: Assign the Monet application group to the workspace.

```shell
az desktopvirtualization workspace update --resource-group "rg-wth-avd-d-uks" --name <Workspace Name> --application-group-references <Resource IDs for all Application Groups>
```

3.5: Create an RBAC assignment for the Monet application group adding only "hulk" using Azure CLI.

```shell
az role assignment create --assignee <UPN or Object ID> --role "Desktop Virtualization User" --scope <Resource ID for Application Group>
```

### 4. Enable the Scaling Automation solution for the UK South and East US host pools using PowerShell

[Scaling Automation scripts](https://docs.microsoft.com/en-us/azure/virtual-desktop/set-up-scaling-script)

Add image of a properly configured logic app

### 5. Configure the Start VM On Connect solution for the Japan West host pool using PowerShell

```powershell
Update-AzWvdHostPool -ResourceGroupName 'rg-wth-avd-d-jw' -HostPoolName <Host Pool Name> -StartVMOnConnect
```

## Learning Resources

- [PowerShell: Desktop Virtualization](https://docs.microsoft.com/en-us/powershell/module/az.desktopvirtualization)
- [Azure CLI: Desktop Virtualization](https://docs.microsoft.com/en-us/cli/azure/ext/desktopvirtualization/desktopvirtualization)
- [Run the Azure Resource Manager template to provision a new host pool](https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-azure-marketplace#run-the-azure-resource-manager-template-to-provision-a-new-host-pool)
- [Scale session hosts using Azure Automation](https://docs.microsoft.com/en-us/azure/virtual-desktop/set-up-scaling-script)
