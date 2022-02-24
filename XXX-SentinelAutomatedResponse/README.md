# What The Hack - Sentinel Description

*The following is a description of the components and tasks required for the Sentinel WTH*

# Microsoft Sentinel 101 
## Introduction
This Hack will introduce you to Microsoft Sentinel by helping you implement and explore the core functionality of Microsoft's SIEM/SOAR platform.

## Learning Objectives
In this hack you will learn how to architect Sentinel, start ingesting data, use the Watchlists feature, create a custom alert and incident.  Finally you will
learn how to add some automation to manage that incident.  

1. Decide on Sentinel Architecture
2. Install the agent and start recieving logs
3. Create a watchlist
4. Create a custom alert and generate an incident
5. Implement a logic app to automatically close the alert

## Challenges
1. Challenge 1: **[Decide on an architecture & deploy agents](Student/Challenge-00.md)**
   - Understand the various architecture and decide on the appropriate design based on the requirements.
2. Challenge 2: **[Install a data connector](Student/Challenge-01.md)**
   - Install the appropriate data connector to import Windows security events and validate Log Analytics data ingestion.
3. Challenge 3: **[Create an analytics rule](Student/Challenge-02.md)**
   - Build a custom analytics rule to show data ingested through the connector.
4. Challenge 4: **[Create a Watchlist and modify retention time](Student/Challenge-03.md)**
   - Create a Watchlist and add data, verify the data is available in Log Analytics.  Change the table retention time to 7 days.
5. Challenge 5: **[Create an alert rule & incident based on you user login](Student/Challenge-04.md)**
   - Bulid a custom rule that alerts when your user ID logs into a server.
6. Challenge 6: **[Close an incident automatically using the Watchlist and a Playbook](Student/Challenge-04.md)**
   - Use a playbook to automatically close the incident only if login occurred from a known IP address?
7. Challenge 7: **[Install a threat intelligence feed](Student/Challenge-04.md)**
   - Install a threat intelligence feed
8. Challenge 8:  **[Create a runbook to verify your Watchlist doesn't contain TI addresses](Student/Challenge-08.md)** 

## Prerequisites
- An Azure subscription with Owner access
- Two virtual machines running in the subscription
- Kusto code knowledge/reference material available
- Patience

## Repository Contents (Optional)
- `../Student/Guides`
  - Student's Challenge Guide
- `../Coach/Guides`
  - Coach's Guide and related files

## Contributors
- Mark Godfrey
- Bruno Terkaly

