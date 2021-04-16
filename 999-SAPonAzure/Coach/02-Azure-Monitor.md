# Challenge 2: Azure Monitor for SAP - Coach's Guide

[< Previous Challenge](./01-SAP-Auto-Deployment.md) - **[Home](README.md)** - [Next Challenge >](./03-SAP-Security.md)

## Notes & Guidance

## Step 1 - **Create Log Analytics workspace**
In the Azure portal, click All services. In the list of resources, type Log Analytics. As you begin typing, the list filters based on your input. Select Log Analytics workspaces.
![Create Workspace](Images/02-Azure-Monitor-Workspace-Create_1.png)
Click Add, and then provide values for the following options:
- Select a Subscription to link to by selecting from the drop-down list if the default selected is not appropriate.
- For Resource Group, choose to use an existing resource group already setup or create a new one.
- Provide a name for the new Log Analytics workspace, such as DefaultLAWorkspace. This name must be unique per resource group.
- Select an available Region. For more information, see which regions Log Analytics is available in and search for Azure Monitor from the Search for a product field.

Click Review + create to review the settings and then Create to create the workspace. This will select a default pricing tier of Pay-as-you-go which will not incur any changes until you start collecting a sufficient amount of data. For more information about other pricing tiers, see Log Analytics Pricing Details.

![Review&Create Worspace](Images/02-Azure-Monitor-Workspace-Create_2.png)

## Step 2 - **Deploy Azure Monitor for SAP.**

- Select Azure Monitor for SAP Solutions from Azure Marketplace.
![Azure Monitor for SAP](Images/02-Azure-Monitor-Create_Monitor-1.png)
- In the Basics tab, provide the required values. If applicable, you can use an existing Log Analytics workspace.
![Azure Monitor for SAP](Images/02-Azure-Monitor-Create_Monitor-2.png)
- When selecting a virtual network, ensure that the systems you want to monitor are reachable from within that VNET.


## Step 3 - **Build Power Application**

- Create power application with tablet layout. Sample screen can look like as shown below:

- Create collection object to store loaded material list from SAP while this application is loading. Click on form, select onvisible propery and connect it to power automate (flow) named "Get_SAP_Materiallist". To do this, click on menu item Action select power automate. Now select the flow Get_SAP_Materiallist. 


