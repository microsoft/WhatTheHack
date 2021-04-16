# Challenge 2: Azure Monitor for SAP - Coach's Guide

[< Previous Challenge](./01-SAP-Auto-Deployment.md) - **[Home](README.md)** - [Next Challenge >](./03-SAP-Security.md)

## Notes & Guidance

## Step 1 - **Create Log Analytics workspace**

- Make sure that fully activated SAP S/4 Hana system is installed. User name and password are working in SAP business client.
- Select a VM to install On-premise data gateway that can access SAP S/4 Hana system on dispatcher and gateway ports. Typical port ranges are 33**,32**,36**.
- Make sure correct on-premise data gateway and SAP .Net connectors are installed. Both should be of same platform type. (Either X64 / X86, mixing will not work. In doubt install SAP .Net connector for both X86 and X64 and restart on-premise data gateway).
- Register the on-premise datagateway with correct user and make sure that user can see connector in power platform at https://make.powerapps.com under gateways. If this is not visible, power application cannot communicate with SAP system. 
![Licenses](Images/Challenge2_Netweaver.png)

## Step 2 - **Develop power automate (flows)**

- Make sure user enabled Microsoft power Apps Plan2 Trail and Microsoft Power Automate Free. E5 developer is also preferred. 
![Licenses](Images/Challenge2_VM_Insights.png)

**Getting Material list from SAP**

- Create power automate (flow) with name Get_SAP_MaterialList (note: Name can be anything). Insert steps PowerApps, Call SAP Function and response as shown below: Note that SAP ERP connection can be created from Flow as well by selecting the registered on-premise gateway. Student/Participant might have created the connection in advance. In that case, he has to use the existing connection. 


**Getting Material information from SAP**

- Create power automate (flow) with name Get_SAP_Material (note: Name can be anything). Note that this step requires input from power application which is not yet ready. Create the flow and come back later to complete. Insert 3 steps in PowerApps as similar to earlier but with different SAP BAPI. Flow may look like below:


## Step 3 - **Build Power Application**

- Create power application with tablet layout. Sample screen can look like as shown below:

- Create collection object to store loaded material list from SAP while this application is loading. Click on form, select onvisible propery and connect it to power automate (flow) named "Get_SAP_Materiallist". To do this, click on menu item Action select power automate. Now select the flow Get_SAP_Materiallist. 


