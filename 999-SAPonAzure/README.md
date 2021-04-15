# Welcome to SAP on Azure OpenHack

Participants work together in teams to complete challenges and are actively engaged, requiring deep collaboration, as they learn together!


## Challenge #1: SAP Deployment

[Automated deployment of SAP environment](https://github.com/Microsoft-SAPonAzure-OpenHack/Learning-the-OpenHack-Way/tree/main/01-SAP-Auto-Deployment)


## Challenge #2: Azure Monitor

## Challenge #3: SAP Security
## Challenge #4: BCDR with ANF


[BCDR with ANF documentation](https://github.com/Microsoft-SAPonAzure-OpenHack/Learning-the-OpenHack-Way/tree/main/04-BCDR%20with%20ANF)

## Challenge #5: PowerApps

Mango Inc warehouse employees should able to identify available materials along with base unit of measurement in real time for available materials in their base plant from their existing mobile device. Design a power application that can be accessible from tablet to search materials in employees own sales organization and plant.

[PowerApps documentation](https://github.com/Microsoft-SAPonAzure-OpenHack/Learning-the-OpenHack-Way/blob/main/05-PowerApps)


## Challenge #6: Application aware maintenance (Start/Stop/Scale)

The goal of this solution is to facilitate a controlled shutdown & startup of SAP systems, which is a common mechanism to save costs for non Reserved Instances (RI) VMs in Azure.

Note: VMs must be deallocated for Azure charges to stop and that's facilitated by scripts

This is ready, flexible, end-to-end solution (including Azure automation runtime environment, scripts, and runbooks, tagging process etc.) that enables:

- Start & Stop of your SAP application servers, central services, database, and corrosponding VMs
- Optionally convert Premium Managed Disks to Standard during the stop procedure, and back to Premium during the start procedure, thus saving cost storage as well  

SAP systems start and stop is done gracefully (using SAP native commands), allowing SAP users and batch jobs to finish (with timeout) minimizing downtime impact.  

Go to the following link to get started with participant guide: [Start-Stop Automation documentation](https://github.com/Microsoft-SAPonAzure-OpenHack/SAPOH/blob/main/06-Start-Stop-Automation)

## Challenge #7: Power BI report query

Generate self-service sales report from SAP system. 
- Option 1: Extract sales data from SAP system to ADLS and generate analytics report using power BI /Synapse. 
- Option 2:  Generate self-service sales report using direct query to SAP HANA system.

[Power BI report query documentation](https://github.com/Microsoft-SAPonAzure-OpenHack/Learning-the-OpenHack-Way/tree/main/07-%20Power%20BI%20report%20query)
