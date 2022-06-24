# Challenge 01 - Rapid SAP deployment

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

We're going to use the SAP Cloud appliance library to deploy you a fully functional SAP S/4 HANA trial/demo environment to develop your new applications against. 

## Description

During the exercise, the Participants will be able to provision a landscape into Azure for SAP environment and then build a fresh SAP system by using the SAP Cloud Appliance Library. 

- Check if your S-User is allowed to open [SAP Cloud Appliance Library](https://cal.sap.com/) (CAL), browse the solutions catalog and hit deploy. Otherwise reach out to your SAP Basis Admin to sort out S-User authorizations prior to the hack. Find more details on the [SAP docs](https://calstatic.hana.ondemand.com/res/docEN/46948f72469c42c88e1735fcb7aea529.html).
- Ensure your S-User is linked to your Azure Subscription in the SAP Cloud Appliance Library. Find details on the setup on the [SAP docs](https://calstatic.hana.ondemand.com/res/docEN/042bb15ad2324c3c9b7974dbde389640.html). 
- Deploy the S4/HANA Appliance to your Azure subscription (with a PUBLIC IP Address. Note that this is not the normal configuration (See hack 042 for a more-enterprise focused configuration), but will allow us to get started quickly) with an RDP instance.
- Record the Master Password you specify as you will need it later to connect over RDP. 
- Download and Save the Getting Started PDF guide for later reference.

- Once the Services are deployed, login to the SAP system through the SAP Logon application deployed to the RDP Instance (using the following default credentials) to test the connection to the SAP Application Platform and continue other challenges.
- RDP Instance - Account 'Administrator', master password recorded earlier.
- SAP Logon (Icon on Desktop) System S4H, Client 100, User bpinst, Password Welcome1.

- Once logged in, verify that you can list data in the SAP System by:
   - Opening 'Tools > ABAP Workbench > Overview > SE16 Data Browser' from the Quick Access Menu
   - Entering Table Name SFLIGHT and pressing Enter, then press F8 to display the data in the SAP Flights Demo Table.
 
## Success Criteria

- Successful Appliance Deployment of SAP S/4HANA to Azure using the available image libraries in the SAP CAL.
- Successful test logon to an SAP Application Server
- Login to the system, verify all the resources are deployed and that the correct demo data is present.
