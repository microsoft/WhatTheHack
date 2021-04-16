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

- Make sure user enabled Microsoft power Apps Plan2 Trail and Microsoft Power Automate Free. E5 developer is also preferred. 


**Getting Material list from SAP**

- Create power automate (flow) with name Get_SAP_MaterialList (note: Name can be anything). Insert steps PowerApps, Call SAP Function and response as shown below: Note that SAP ERP connection can be created from Flow as well by selecting the registered on-premise gateway. Student/Participant might have created the connection in advance. In that case, he has to use the existing connection. 


**Getting Material information from SAP**

- Create power automate (flow) with name Get_SAP_Material (note: Name can be anything). Note that this step requires input from power application which is not yet ready. Create the flow and come back later to complete. Insert 3 steps in PowerApps as similar to earlier but with different SAP BAPI. Flow may look like below:


## Step 3 - **Build Power Application**

- Create power application with tablet layout. Sample screen can look like as shown below:

- Create collection object to store loaded material list from SAP while this application is loading. Click on form, select onvisible propery and connect it to power automate (flow) named "Get_SAP_Materiallist". To do this, click on menu item Action select power automate. Now select the flow Get_SAP_Materiallist. 


