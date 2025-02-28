# Challenge 01 - Ingesting and Creating the Database - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Setup Steps

Steps for MAA Fabric Real-time intelligence:
1. Create Fabric capacity (F4)
1. Change Admin settings to allow 1 second page refresh
    - Admin Portal
    - Capacity settings
    - PBI Workloads
2. Open PBI in the browser
3. Create a workspace and assign it to the Fabric capacity
4. New resource, create an Eventhouse
    - This by default creates a KQL DB with the same name as the Eventhouse
5. Turn on Onelake folder
6. Create an Eventstream that brings in data from the Eventhub and outputs it to the KQL DB table
	- Create new table name
	- Create connection:
		- Event hub namespace
		- Event hub
		- Sas key name
		- Sas key
	- Event retrieval start date (under more parameters)
	- Schema should be JSON with no nested values

## Notes & Guidance

Unfortunately Fabric does not allow template automation for the items inside of it, so you will have to follow along with the students to create the example from scratch as they are doing.

The Learning Resource below have a useful tutorial to get you going if the steps laid out here are not enough.

## Learning Resources

- [Realtime Analytics in Fabric Tutorial](https://learn.microsoft.com/en-us/fabric/real-time-analytics/tutorial-introduction)
- [Creating an Eventhouse](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/create-eventhouse)
- [Creating a KQL Database](https://learn.microsoft.com/en-us/fabric/real-time-analytics/create-database)
- [Get Data from Event Hubs into KQL](https://learn.microsoft.com/en-us/fabric/real-time-analytics/get-data-event-hub)
- [Creating an Eventstream](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/event-streams/create-manage-an-eventstream?pivots=standard-capabilities)
- [Get Data from Eventstream into KQL](https://learn.microsoft.com/en-us/fabric/real-time-intelligence/get-data-eventstream)
