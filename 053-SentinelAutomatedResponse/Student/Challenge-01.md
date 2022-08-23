# Challenge 01 - Architecture, Agents, Data Connectors and Workbooks </br>

**[Home](../README.md)** - [Next Challenge>](./Challenge-02.md)


## Introduction 

In this challenge you will decide on an architecture for your Sentinel workspace(s) and what information will be stored in that Log Analytics workspace.  Then you will add Sentinel to that workspace and confirm you can now access Sentinel.  Next, you will deploy agents to get data into the log analytics workspace.



## Description

This is a net new install, you need to design the workspace environment to meet the following requirements. Create a short doc that describes your decision and justification for these requirements: <br>
- Metrics and logs should not be in the same log analytics workspace
- You do not have any regulatory requirements
- There is only one tenant
- You have multiple regions to support and a centralized SOC
- There are multiple data owners
- You need to keep ingestion costs to a minimum but still ingest security events
- You need to be able to check visually that the data connector is healthy
- You need to collect active directory events

**Tasks - Instanciate Your Microsoft Sentinel Environment**
- Be able to launch the Sentinel service in the portal
- Deploy the AMA or MMA agent on a Windows Server
- Verify that data is being ingested into Sentinel
- Deploy the appropriate data connector
- Deploy the 'Data collector health monitoring' workbook

## Success Criteria

To complete this challenge you need to design and deploy an architecture and install an agent on the two windows machines.
- Create a Log Analytics workspace and explain your Sentinel architecture.
- Launch the Sentinel Console.
- Demonstrate that logs are being ingested into your Log Analytics Workspace.



## Learning Resources

The following articles will help you decide on an architecture, explain the alternatives and decide on the data connector required.

- **[Architecture guidance](https://docs.microsoft.com/en-us/azure/sentinel/design-your-workspace-architecture)**</br>
- **[Data connectors blog](https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/azure-sentinel-the-connectors-grand-cef-syslog-direct-agent/ba-p/803891)** </br>
- **[Data connectors Doc](https://docs.microsoft.com/en-us/azure/sentinel/connect-data-sources)** </br>
- **[Find a connector](https://docs.microsoft.com/en-us/azure/sentinel/data-connectors-reference)** </br>
- **[Visualizing Data](https://docs.microsoft.com/en-us/azure/sentinel/monitor-your-data)** </br>


## Tips 

Don't overthink the architecture, the guide here is to get you to understand the options. Ask yourself why would I need multiple Sentinel workspaces, and what is the impact of doing so?
For the workbook, don't create one, use an existing workbook.

## Advanced Challenges 

*Too comfortable?  Eager to do more?  Try these additional challenges!*

- Deploy the AMA agent and configure it to send only login and logoff events.  Be sure to capture all the user login and logoff events </br>
- Deploy the Linux agent and collect authentication information


