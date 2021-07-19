# Challenge 3: Azure Monitor for Virtual Machines

[< Previous Challenge](./02-Monitoring-Basics-And-Dashboards.md) - **[Home](../README.md)** - [Next Challenge>](04-Azure-Monitor-For-Applications.md)

## Introduction

In this challenge you will...

## Description

In this challenge you will be preparing three images that will...

1. X
2. X
3. X
4. UPDATE MANAGEMENT NEEDS TO REVIEWED & SEPARATED FROM COACHES GUIDE - JUST COPIED OVER
Now let's keep our VMs up-to-date
First we will make sure they are all reporting to our demo Log Analytics Workspace.
- To do that go to our Resource group, open the Log Analytics Workspace
- Go to Virtual Machines and put your 5 unique characters, and see if all reporting to this one
  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/otherws.png)
  
- If not, click the VM, disconnected it and re-connected to this LA WS.
- Now create a new Automation Account ([here is how](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account))
- Link the Automation Account to your Log Analytics Workspace, go to the newly created Azure Automation Account, go to update management and link the LA WS as shown below
  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/azautoaccount.png)  
- Enable the Azure Update Management on your VMs, on the same page (you may need to refresh it) go to "Add Azure VMs"
- Make sure you are on the correct region
- Check your VMs and click enable (see below)
  
![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/enableazautoaccount.png)  
>**Tip:** If you want to enable all VMs connected to the LA WS automatically (current or current and future, to to Azure Automation Account, then click on "Update Management" on the left, click on "Manage machines" 
>![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/managevms.png)> Pick the option suitable for your environment
  
>**Note:** You may need to wait sometime for the VMs to show up
  
- The next step is to schedule an update deployment. Open the automation account. In the left menu, select **Update Management**.

- Under the **Machines** tab. Under the **Update Deployments** tab, you can see the status of past scheduled deployments. Under the **Deployment schedules** tab, you can see a list of upcoming and completed deployments.
  
- Select **Schedule update deployment**. The **New update deployment** window will open, and you can specify the needed information.

Here is more information about the different options ([click here](https://docs.microsoft.com/en-us/azure/automation/update-management/deploy-updates))

Once you specify all settings, select **Create**.

![enter image description here](https://github.com/msghaleb/AzureMonitorHackathon/raw/master/images/updateschdule.png)
Fill it up, click create - you are all set ;-)

To see the status of an update deployment, select the **Update deployments** tab under **Update management**. **In progress** indicates that deployment is currently running. When the deployment is completed, the status will show either “Succeeded” if each update was deployed successfully or “Partially failed” if there were errors for one or more of the updates.

To see all the details of the update deployment, click on the update deployment from available list.

- Can you use Azure Update Management to install just one specific patch?

**How to install just a single specific update**
If you checked the link in the challenge you should be all set, however the link it for Linux.
For Windows (very similar) also create a schedule as described above and deselect all update classifications.
In the include type your KB ID you would like to install (you can get it from the missing updates tab)

## Success Criteria

1. X
1. X
1. X

## Resources
- [How to use Azure Update Management to install a specific patch version](https://www.linkedin.com/pulse/how-use-azure-update-management-install-specific-patch-mohamed-ghaleb/)
- [Azure Update Management overview](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)
- [Create a new Automation Account](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account)
