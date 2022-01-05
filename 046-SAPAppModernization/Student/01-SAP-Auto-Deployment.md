# Challenge 1: SAP Demo System Deployment

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-OpenAPIAndOdata.md)

## Introduction

We're going to use the SAP Cloud appliance library to deploy you a fully functional SAP S/4 HANA trial / demo environment to develop your new applications against. 

## Description

During the exercise, the Participants will be able to provision a landscape into Azure for SAP environment and then build a fresh SAP system by using the SAP Cloud Appliance Library. 

- Ensure your s-account is linked to your Azure Subscription in the SAP Cloud Appliance Library and the correct 
- Deploy the S4/HANA Appliance to your Azure subscription (with a PUBLIC IP Address. Note that this is not the normal configuration (See hack 042 for a more-enterprise focused configuration), but will allow us to get started quickly) with an RDP instance.
- Record the Master Password you specify as you will need it later to connect over RDP. 
- Download and Save the Getting Started PDF guide for later reference.

- Once the Services are deployed, login to the SAP system through the SAP Logon application deployed to the RDP Instance (using the following default credentials) to test the connection to the SAP Application Platform and continue other challenges. 
- RDP Instance - Account 'Administrator', master password recorded earlier.
- SAP Logon (Icon on Desktop) System S4H, Client 100, User bpinst, Password Welcome1.

- Once logged in, verify that you can list data in the SAP System by :-  
 - Opening 'Tools > ABAP Workbench > Overview > SE16 Data Browser' from the Quick Access Menu
 - Entering Table Name SFLIGHT and pressing Enter, then press F8 to display the data in the SAP Flights Demo Table.
 
## Success Criteria

- Successful Appliance Deployment of SAP S/4HANA to Azure using the available image libraries in the SAP CAL.
- Successful test logon to an SAP Application Server
- Login to the system, verify all the resources deployed and that the correct demo data is present.
