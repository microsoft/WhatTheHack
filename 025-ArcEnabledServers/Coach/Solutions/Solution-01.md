# Challenge 01: Onboarding servers with Azure Arc - Coach's Guide

**[Home](../readme.md)** - [Next Challenge>](./Solution-02.md)

## Notes & Guidance

In this challenge, you will need to deploy a server to your Azure subscription. This server is deployed in Azure for the purpose of the lab, the actions you take to enable it as an Azure Arc enabled server are exactly the same if they were on-premises or in a different cloud provider.

Once deployed, you will install the Azure Arc agent on the server and confirm that the server is visible from the Azure portal as a resource by using [Resource Graph Explorer](https://docs.microsoft.com/en-us/azure/governance/resource-graph/first-query-portal).

1. Deploy a server running a [supported OS](https://docs.microsoft.com/en-us/azure/azure-arc/servers/agent-overview#supported-operating-systems) to your Azure subscription. Be sure that the server you deploy has a public IP address. 

- In the browser window where you signed to your Azure subscription, in the PowerShell session in the Cloud Shell pane, run the following to create a resource group that will be hosting the lab VM, from which you will be running the challenges (replace the `[Azure_region]` placeholder with the name of an Azure region you intend to use to host Azure resources):

   ```pwsh
   $location = '[Azure_region]'
   $rgName = 'arc-chvms-rg'
   New-AzResourceGroup -Name $rgName -Location $location
   ```

- In the browser window, open another tab, navigate to the [301-nested-vms-in-virtual-network Azure QuickStart template](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/nested-vms-in-virtual-network), and select **Deploy to Azure**. This will automatically redirect the browser to the **Hyper-V Host Virtual Machine with nested VMs** blade in the Azure portal.
- On the **Hyper-V Host Virtual Machine with nested VMs** blade in the Azure portal, specify the following settings (leave others with their default values):

    | Setting | Value |
    | --- | --- |
    | Subscription | the name of the Azure subscription you are using in this lab |
    | Resource group | **arc-chvms-rg** |
    | Host Public IP Address Name | **arcchhv-vm-pip** |
    | Virtual Network Name | **arcchhv-vnet** |
    | Host Network Interface1Name | **arcchhv-vm-nic1** |
    | Host Network Interface2Name | **arcchhv-vm-nic2** |
    | Host Virtual Machine Name | **arcchhv-vm** |
    | Host Admin Username | **demouser** |
    | Host Admin Password | **demo@pass123** |

- Once deployment completes, add a rule allowing inbound RDP connectivity to the network security group associated with the **archhv-vm-nic1** network adapter.
- Connect to the newly deployed Azure VM **arcchhv-vm** via Remote Desktop. 
- Within the Remote Desktop session to **arcchhv-vm**, disable Internet Explorer Enhanced Security, use Internet Explorer to navigate to [Windows Server Evaluations](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019), and download the Windows Server 2019 **VHD** file to the **F:\VHDs** folder.
- Start Hyper-V manager and create a new Hyper-V VM with the following settings (leave others with their default values):

    | Setting | Value |
    | --- | --- |
    | Name | **arcch-vm1** |
    | Store the virtual machine in a different location | selected |
    | Connection | the nested virtual switch |
    | Location | **F:\VMs** |
    | Use an existing virtual disk | The full path to the downloaded VHD file |

- Start and connect to the Hyper-V VM, set its name to **arch-vm1**, restart it and sign in back.
- From the nested Hyper-V VM **arch-vm1**, disable Internet Explorer Enhanced Security, use Internet Explorer to navigate to the Azure portal, sign-in, and from a PowerShell session of Cloud Shell pane, run the following to create a resource group that will host resources representing the Azure Arc enabled servers:

   ```pwsh
   $rgName = 'arc-chvm-rg'
   $location = (Get-AzResourceGroup -ResourceGroupName $rgName).Location
   $arcEnabledServersrgName = 'arc-enabled-servers-rg'
   New-AzResourceGroup -Name $arcEnabledServersrgName -Location $location
   ```

- From the nested Hyper-V VM **arcchhv-vm** , within the Remote Desktop session, from the Azure portal, [generate the installation script](https://docs.microsoft.com/en-us/azure/azure-arc/servers/learn/quick-enable-hybrid-vm) that references the newly created resource group as the location of the resources representing Azure Arc enabled server, download the script, and run it to [install the agent (https://docs.microsoft.com/en-us/azure/azure-arc/servers/learn/quick-enable-hybrid-vm). When prompted, launch Internet Explorer, navigate to https://microsoft.com/devicelogin, provide the code displayed in the PowerShell console, and authenticate using the same credentials you used to provision Azure resources in this challenge.

   >**Note**: You will need to *unblock* the script once you download it to the Azure VM running Windows Server. Alternatively, you can bypass the Windows PowerShell execution policy by running:

   ```pwsh
   Set-ExecutionPolicy Bypass -Scope Process
   ```

- Once the installation completes, verify that you can see the server resource on the **Servers - Azure Arc** blade in fthe Azure Portal with the **Connected** status.

2. Add a tag to the server and use Resource Graph Explorer to run a query showing all resources that have that tag.

- Use the Azure portal to add a tag named **arcchallenge1** to the Arc enabled server resource and set its value to **Completed**.
- Use the **Resource Graph Explorer** blade in the Azure portal to run and review the output of the Kusto query:

   ```kusto
   Resources
   | where tags.arcchallenge1=~'Completed'
   | project name
   ```

- Alternatively, you can use a Bash session in the Cloud Shell and run the following query (confirm when prompted to install the extension **resource-graph**).

   ```bash
   az graph query -q "Resources | where tags.arcchallenge=~'Completed' | project name" --output tsv
   ```

### Success Criteria

1. You have deployed a server with a public IP address running in a non-Azure public cloud or on-prem environment.
2. You are able to see the server in the Azure Portal as an Azure resource.
3. You are able to use Resource Graph Explorer to run a query that shows your server and any applied tags.
