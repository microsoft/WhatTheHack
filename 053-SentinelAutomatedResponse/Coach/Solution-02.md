# Challenge-02 - Custom Queries & Watchlists - Coach's Guide

[< Previous Challenge](./Solution-01.md) - **[Home](./README.md)** - [Next Challenge>](./Solution-03.md)

# Custom Queries & Watchlists
## Introduction
In this section of the Coach's guide, you fill find guidance, code, and examples that will help you guide the teams over the course of the WTH. 
In the spirit of continuous improvement, update this repository with any suggestions, altertnatives, or additional challenges.

This section of the hack includes a optional [Sentinel Review Deck](./Intro2Sentinel-C2.pptx?raw=true) that features a short presentation to introduce key topics associated with this challenge. 

Instructions on how to update the repository with updates can be found here. https://aka.ms/wthcontribute

## Part 1 - Alerts 

Analytics/Scheduled query rule: 

SecurityEvent </br>
| where EventID == 4624 </br>
| where LogonType == 10 or LogonType == 7 </br>

Mitre attack:  Inital Access  & Privileged Escallation

Severity - Medium or high (either is fine)

Rule logic: ![image](https://user-images.githubusercontent.com/22599225/147886476-922c546c-ec01-4b24-8fb0-c74a07083e89.png)

Query Scheduling:</br> ![image](https://user-images.githubusercontent.com/22599225/147886497-b8537733-89ef-4194-ab31-5959ffc9a888.png)

Incident Settings: </br> ![image](https://user-images.githubusercontent.com/22599225/147886542-c3c87e82-a01c-4a3b-8d5a-64b573d52067.png)

Automated Response: (next Challenge)


At this point the user should now be able to log into the Windows server and then within 3 minutes (usually more like 45 seconds) see the 4624 event.
If the student has not included the '| where LogonType == 10 or LogonType == 7' in their query, this is a good point to add it.

## Part 2 - Watchlists  </br>
     
Step 1: Creating a Watchlist </br>

Return to the portal Sentinel page</br>
Open the Watchlists blade</br>
Click on +Add new</br>
Give your watchlist a name ‘Critical Servers’, Description ‘See Name’, and an alias (CritServ)</br>
Call the Watchlist something  (ie Valid_Admin_IPAddresses)  as a .CSV File
Create a text file with two entries

AdminName, IPAddress  (Heading)
FTAdmin, 24.68.78.190
FTAdmin, 52.149.14.125



Import the file</br>
Id the search field as the ServerName</br>
Click ‘Next: Review and Create’, then Create</br>
Select ‘Logs’</br>
Open ‘Azure Sentinel’</br>
Double click on ‘Watchlist’ , then click Run  - you should see your table.</br>
</br>

Step 2: Set the retention period </br>
*Method 1 - Deploy the ARM template
https://github.com/slavizh/ARMTemplates/blob/master/log-analytics/retention-per-table.json

**NOTE:** The repository linked above is not part of the What The Hack repository. This repo was available at the time of this publication but if it's not there, please report it as a bug via the WTH Contribution Guide process: https://aka.ms/wthcontribute

Method 2 - Download the ARM client from chocolaty </br>
armclient GET /subscriptions/bd4d88c1-fc0f-482f-b57b-2f3ed541945e/resourceGroups/WTH-Sentinel/providers/Microsoft.OperationalInsights/workspaces/WTH-Sentinel-LAW/Tables/Watchlist?api-version=2017-04-26-preview </br>
Use the 'Put' format, this example checks the Security Events table </br>
PUT /subscriptions/00000000-0000-0000-0000-00000000000/resourceGroups/MyResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/MyWorkspaceName/Tables/SecurityEvent?api-version=2017-04-26-preview {"properties":  {"retentionInDays": 180 } }</br>

To check the table retention time has been correctly specified, use the following 'Get' command - this example checks the Security Events table </br>
GET /subscriptions/00000000-0000-0000-0000-00000000000/resourceGroups/MyResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/MyWorkspaceName/Tables/SecurityEvent?api-version=2017-04-26-preview



**Troubleshooting**</br>
Setting table retention time: 
https://azure.microsoft.com/en-us/updates/retention-by-type/
https://docs.microsoft.com/en-us/azure/azure-monitor/logs/manage-cost-storage#retention-by-data-type

