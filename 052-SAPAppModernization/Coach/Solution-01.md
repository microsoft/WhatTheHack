# Challenge 01 - Rapid SAP deployment - Coach's Guide 

[< Previous Challenge](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

# Notes & Guidance

The most likely things to go wrong here are

1. The user has no SAP subscription or licence and has no S-number. They simply will need to be registered with SAP within their organization to get this.
2. They have not linked their Cloud Appliance Library account to their Azure subscription.
3. They have not configured a service principal with the appropriate rights and added it to allow the SAP Cloud Appliance library to deploy into their subscription.
4. The user cannot authenticate with the described credentials as they are using a different Appliance version. All details relevant for the specific SAP S/4HANA deployment is detailed under Win Server file:///C:/ProgramData/WelcomePage/Welcome.html
5. Transaction code SE16 is not found -> use /n SE16

## Description

During the exercise, participants will be able to provision a landscape into Azure for SAP environment and then build a fresh SAP S4H system by deploying SAP HANA as a claoud appliance. This system will be licenced for one month's trial purposes.

## Prerequisite

A valid Azure subscription which can create Azure resources (Virtual Machines (In the D-series or E-series families), storage accounts and disks, virtual networks ..).

The Participant will need an authorization to create a Service Principal with the Contributor Role, or will need one provided prior to the start of the challenge.

An estimate of an additional $100/daily Azure budget during the challenge-session days.
 
## Success Criteria
- Complete build of SAP S4H and SAP HANA database on Azure Cloud.
- Successful Installation of SAP GUI and test logon to SAP Application Server
 
## Learning Resources

- [SAP GUI Installation Guide](https://help.sap.com/viewer/1ebe3120fd734f67afc57b979c3e2d46/760.05/en-US)

- [SAP HANA studio installation guide](https://help.sap.com/viewer/a2a49126a5c546a9864aae22c05c3d0e/2.0.01/en-US)
