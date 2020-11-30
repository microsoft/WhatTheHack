# What The Hack - Azure Arc enabled Servers Hack - Instructor Guide

This guide provides teaching notes and example solutions for each exercise in the Azure Arc enabled Servers Hack Challenge Lab.

## Introduction

![](../../img/image1.png)

[Azure Arc enabled Servers](https://docs.microsoft.com/en-us/azure/azure-arc/servers/overview) allows customers to use Azure management tools on any server running in any public cloud or on-premises environment. In this hack, you will be working on a set of progressive challenges to showcase the core features of Azure Arc.

In the first few challenges, you will set up your lab environment and deploy servers somewhere other than Azure. Then, you will use Azure Arc to project these servers into Azure, and begin to enable Azure management and security tools on these servers. On successive challenges, you will apply [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) and enable other Azure services like [Azure Security Center](https://docs.microsoft.com/en-us/azure/security-center/) on your projected workloads.

## Learning Objectives

This hack will help you learn:

1. Azure Arc enabled Servers basic technical usage
2. How Azure Arc enabled Servers works with other Azure services
3. How Azure Arc enabled Servers enables Azure to act as a management plane for any workload in any public or hybrid cloud

## Challenges

- [Challenge 1](./Student/challenge01.md) - Onboarding servers with Azure Arc
- [Challenge 2](./Student/challenge02.md) - Policy for Azure Arc connected servers
- [Challenge 3](./Student/challenge03.md) - Arc Value Add: Integrate Security Center
- [Challenge 4](./Student/challenge04.md) - Arc Value Add: Enable Sentinel
- [Challenge 5](./Student/challenge05.md) - Arc Value Add: Azure Lighthouse

## Prerequisites

- Azure Subscription
- [Visual Studio Code](https://code.visualstudio.com)
- [Git SCM](https://git-scm.com/download)


## Challenge 1 - Onboarding servers with Azure Arc

### Pre-requisites

- Ensure you have an Azure subscription suitable for use during this hack.
- Sign in to the Azure subscription from the Azure portal, start a PowerShell session in the Cloud Shell pane, and run the following to register the required resource providers:

   ```pwsh
   az provider register --namespace 'Microsoft.HybridCompute'
   az provider register --namespace 'Microsoft.GuestConfiguration'
   ```

### Challenge 1

In this challenge, you will need to deploy a server to your Azure subscription. This server is deployed in Azure for the purpose of the lab, the actions you take to enable it as an Azure Arc enabled server are exactly the same if they were on-premises or in a different cloud provider.

Once deployed, you will install the Azure Arc agent on the server and confirm that the server is visible from the Azure portal as a resource by using [Resource Graph Explorer](https://docs.microsoft.com/en-us/azure/governance/resource-graph/first-query-portal).

1. Deploy a server running a [supported OS](https://docs.microsoft.com/en-us/azure/azure-arc/servers/agent-overview#supported-operating-systems) to your Azure subscription. Be sure that the server you deploy has a public IP address. 

- In the browser window where you signed to your Azure subscription, in the PowerShell session in the Cloud Shell pane, run the following to create a resource group that will be hosting the lab VM, from which you will be running the challenges (replace the `[Azure_region]` placeholder with the name of an Azure region you intend to use to host Azure resources):

   ```pwsh
   $location = '[Azure_region]'
   $rgName = 'arc-chvms-rg'
   New-AzResourceGroup -Name $rgName -Location $location
   ```
- In the browser window, open anoter tab, navigate to the [301-nested-vms-in-virtual-network Azure QuickStart template](https://github.com/Azure/azure-quickstart-templates/tree/master/301-nested-vms-in-virtual-network), and select **Deploy to Azure**. This will automatically redirect the browser to the **Hyper-V Host Virtual Machine with nested VMs** blade in the Azure portal.
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
1. You are able to see the server in the Azure Portal as an Azure resource.
1. You are able to use Resource Graph Explorer to run a query that shows your server and any applied tags.


## Challenge 2 – Policy for Azure Arc connected servers

### Introduction

In the last challenge you deployed a server and then enabled it as an Azure resource by using Azure Arc. Now that you have a server projected into Azure, we can start to use Azure to manage and govern this server. One of the primary ways we can do this is by using Azure Policy(https://docs.microsoft.com/en-us/azure/governance/policy/overview). By using Policy, we can automatically perform management tasks on Azure resources such as creating [tags](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources) or connecting to [Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/tutorial-resource-logs).

### Challenge

1. Assign a policy that adds a resource tag to all resources in the resource group where your Azure Arc connected servers are located.

- In the Azure portal, create a policy assignment targeting the **arc-enabled-servers-rg** resource group based on the built-in policy definition **Add or replace a tag on resources**. 

   >**Note**: Do not use **Append a tag and its value to resources**, since you need a policy definition with **modify** effect in order to apply it to existing resources. Make sure to create a remediation task and enable **Managed Identity**. Set **Tag name** to **arcchallenge2a** and **Tag value** to **Completed**.

   >**Note**: Do not wait for the policy processing to take place but proceed to the next step. 

2. Create a suitable Log Analytics workspace to use with your Azure Arc resources. Make sure it is in the same region as your Azure Arc resources to avoid egress charges.

- In the Azure portal, create a Log Analytics workspace in a new resource group named **arc-challenge-infra**.

3. Assign a policy that automatically deploys the Log Analytics agent to Azure Arc connected servers if they do not have the agent.

- In the Azure portal, create a policy assignment targeting the **arc-enabled-servers-rg** resource group and the newly created Log Analytics workspace. Use the built-in policy definition **[Preview]: Deploy Log Analytics agent to Windows Azure Arc machines**. Make sure to create a remediation task and enable **Managed Identity** in the location matching the location of Arc enabled Server resource. Do not use the built-in definition **Deploy Log Analytics agent for Windows VMs**.

   >**Note**: Do not wait for the policy processing to take place but proceed to the next step. 

4. Configure the Log Analytics agent to collect performance metrics of the connected machine.

- In the Azure portal, on the blade of the newly provisioned Log Analytics workspace, navigate to the **Advanced Settings** blade, select **Data** and configure collection of **Windows Performance Counters**. 
- Navigate to the **Policy | Remediation** blade and track the progress of the remediation task associated with the policy assignment that controls the installation of the Log Analytics agent. Wait until that task reports the **Complete** remediation status.
- Navigate back to the Log Analytics workspace, display its **Logs** blade, select **Virtual machines** as the resource type, and select one of the sample performance-related queries (e.g. **Chart CPU usage trends**).

### Success Criteria

1. Azure Arc connected servers should have a tag applied by the policy you created in Challenge #1. 
1. Azure Arc connected servers should have the Log Analytics agent deployed and working.
1. You can use the Log Analytics workspace to query performance metrics about your Azure Arc connected machine.


## Challenge 3 - Arc Value Add: Integrate Security Center

### Introduction

In this challenge, we will integrate your Azure Arc connected machines with [Azure Security Center (ASC)](https://docs.microsoft.com/en-us/azure/security-center/). After completing the previous challenges, you should now have an Azure subscription with one or more Azure Arc managed servers. You should also have an available Log Analytics workspace and have deployed the Log Analytics agent to your server(s). 

### Challenge

1. Enable Azure Security Center on your Azure Arc connected machines.

- In the Azure portal, navigate to the Security Center blade, select **Security solutions**, and then in the **Add data sources** section select **Non-Azure servers**.
- On the **Add new non-Azure servers** blade, select the **+ Add Servers** button referencing the Log Analytics workspace you created in the previous task.
- Navigate to the **Security Center | Pricing & settings** blade and select the Log Analytics workspace.
- On the **Security Center | Getting Started** blade and enable Azure Defender on the Log Analytics workspace.
- Navigate to the **Settings | Azure Defender plans** blade and ensure that Azure Defender is enabled on 1 server.
- Switch to the **Settings | Data collection** blade and select the **Common** option for collection of **Windows security events**.
- Navigate to the **arcch-vm1** blade, select **Security**, an verify that **Azure Defender for Servers** is **On**.

### Success Criteria

1. Open Azure Security Center and view the [Secure Score](https://docs.microsoft.com/en-us/azure/security-center/secure-score-security-controls) for your Azure arc connected machine.

   >**Note**: Alternatively, review the **Security Center \| Inventory** blade and verify that it includes the **Servers - Azure Arc** entry representing the **arcch-vm1** Hyper-V VM.


## Challenge 4 – Arc Value Add: Integrate Sentinel

### Introduction

In this challenge, we will integrate your Azure Arc connected machines with [Azure Sentinel](https://docs.microsoft.com/en-us/azure/sentinel/overview). After completing the previous challenges, you should now have an Azure subscription with one or more Azure Arc managed servers. You should also have an available Log Analytics workspace and have deployed the Log Analytics agent to your server(s).

### Challenge

1. Enable Azure Sentinel on your Azure Arc connected machines by configuring the Log Analytics agent to forward events to Azure Sentinel such as Common Event Format (CEF) or Syslog.

- In the Azure portal, connect Azure Sentinel to the Log Analytics workspace you created in the previous challenge.

### Success Criteria

1. From Azure Sentinel, view collected events from your Azure Arc connected machine.

- In the Azure portal, navigate to the **Azure Sentinel \| Data Connectors** blade, select **Security Events** entry, and then select **Go to analytics**. 


## Challenge 5 – Arc Value Add: Enable Lighthouse

### Introduction

[Azure Lighthouse](https://docs.microsoft.com/en-us/azure/lighthouse/overview) enables cross- and multi-tenant management, allowing for higher automation, scalability, and enhanced governance across resources and tenants.

With Azure Lighthouse, service providers can deliver managed services using comprehensive and robust management tooling built into the Azure platform. Customers maintain control over who can access their tenant, what resources they can access, and what actions can be taken. This offering can also benefit enterprise IT organizations managing resources across multiple tenants.

### Challenge

Pair with another member of your team and [Oonboard their Azure subscription](https://docs.microsoft.com/en-us/azure/lighthouse/how-to/onboard-customer) into your Azure Lighthouse subscription. 
They should enable delegated access of your Azure Arc enabled server to you.

- In the *provider subscription*, use the Azure portal to identify the Azure AD tenant Id.
- In the *provider subscription*, use the Azure portal to create a new Azure AD group named **LHAdmins** and identify the value of its objectID attribute. Add your account to the group.
- In the *customer subscription*, identify the Id of the **Contributor** built-in RBAC role by running the following from a PowerShell session of in the Cloud Shell pane of the Azure portal.

   ```pwsh
   (Get-AzRoleDefinition -name 'Contributor').Id   
   ```

- In the *customer subscription*, verify that the user account used to onboard the service provider is explicitly assigned the **Owner** role in the subscription. If not, make sure to assign it.
- In the browser window displaying the *customer subscription* in the Azure portal, open another tab, navigate to the [Azure Lighthouse samples](https://github.com/Azure/Azure-Lighthouse-samples), and select the **Deploy to Azure** button next to the **Azure Lighthouse - Subscription Deployment** entry. On the **Custom deployment** blade, perform a deployment with the following settings (leave others with their default values):

    | Setting | Value | 
    | --- | --- |
    | Subscription | the name of the *customer subscription*  |
    | Region | the name of the Azure region where you deployed all of the resources |
    | Msp Offer Name | **ArcChallenge5Offer** |
    | Msp Offer Description | **Arc Challenge5 offer** |
    | Managed by Tenant Id | the Id of the Azure Ad tenant associated with the *provider subscription* |
    | Authorizations | [{"principalId":"<objectId of the LHAdmins group>,"roleDefinitionId":"<Id of the Contributor role>","principalIdDisplayName":"LHAdmins"}]

### Success Criteria

In Azure Lighthouse -> Manage Resources you should see the delegated resources from your team members subscription.

   >**Note**: Alternatively, navigate to the **Service providers** blade of the *customer subscription*, select **Service provider offers** entry, and verify that it includes the offer you created in this challenge.

   >**Note**: When using the *provider subscription* for valiadation, make sure that you are using an account that is a member of the **LHAdmins** group.