# What The Hack - Sentinel Automated Response

## Introduction
This Hack will introduce you to Microsoft Sentinel by helping you implement and explore the core functionality of Microsoft's Security Incident & Event Management (SIEM) /Security Orchestration Automated Response (SOAR) platform.

## Learning Objectives
In this hack you will learn how to architect Sentinel, start ingesting data, use the Watchlists feature, create a custom alert and incident.  Finally you will learn how to add some automation to manage that incident.  

1. Decide on the Sentinel Architecture
2. Install the agent and start recieving logs
3. Create a watchlist
4. Create a custom alert and generate an incident
5. Implement a logic app to automatically close the alert

## Challenges
- Challenge 01: **[Architecture, Agents, Data Connectors and Workbooks](Student/Challenge-01.md)**
   - Understand the various architecture and decide on the appropriate design based on the requirements. Install the appropriate data connector to import Windows security events and validate Log Analytics data ingestion.
- Challenge 02: **[Custom Queries & Watchlists](Student/Challenge-02.md)**
   -  Build a custom analytics rule to show data ingested through the connector. Create a Watchlist and add data, verify the data is available in Log Analytics.  Change the table retention time to 7 days
- Challenge 03: **[Automated Response](Student/Challenge-03.md)**
   -  Bulid a custom rule that alerts when your user ID logs into a server. Use a playbook to automatically close the incident only if login occurred from a known IP address

## Prerequisites
You will need an Azure subscription with contributor rights to complete this hackathon. If you don't have one...

[Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)

Our goal in the hackathon is limiting the cost of using Azure services. 

If you've never used Azure, you will get:
- $200 free credits for use for up to 30 days
- 12 months of popular free services  (includes storage, Linux VMs)
- Then there are services that are free up to a certain quota

Details can be found here on [free services](https://azure.microsoft.com/en-us/free/).

If you have used Azure before, we will still try to limit cost of services by suspending, shutting down services, or destroy services before end of the hackathon. You will still be able to use the free services (up to their quotas) like App Service, or Functions.


## Contributors
- Mark Godfrey
- Bruno Terkaly
- Anirudh Gandhi
- Sherri Babylon
