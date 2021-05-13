# Challenge 1: Coach's Guide - SAP Auto Deployment

[< Previous Challenge](./00-prereqs.md) - **[Home](README.md)** - [Next Challenge >](./02-Azure-Monitor.md)

# Notes & Guidance

This challenge introduces an automation tool for SAP Basis persons on provision of (1) all necessary Azure infrastructure (compute/storage/network) (2) server configurations and SAP system installation. 

_The tool is based on Terraform and Ansible script. Contact your Microsoft team for the deployment files. Please note that this may take up to 4 hours to complete once automation is kicked off._

As a coach you wil be given files that are not checked into this repo that need to be given to students. When you obtain these files, zip them up into one file and upload them to the Files tab of the General Channel for this hack.

## Description

During the exercise, participants will be able to provision a landscape into Azure for SAP environment and then build a fresh SAP S4H system by using an existing backup files into this environment as shown in the following diagram. SAP HANA DB will use Azure Netapp Filesystem for storage volume. 

## Prerequisite

A valid Azure subscription which can create azure resources (computed D-series, E-series, storage, Network..) for Azure regions: uswest2 and useast2

The Participant will need an authorization to create or have a Service Principle with the Contributor Role, provided.

Azure subscription whitelisted with Azure Netapp Filesystem (ANF)

An estimate of an additional $100/daily Azure budget during the challenge-session days.
 
## Success Criteria
- Complete build of SAP S4H and SAP HANA database on Azure Cloud.
- Successful Installation of SAP GUI and test logon to SAP Application Server

## Tips
 
For step 5. Make sure that the students create an ubuntu box with a named user "azureuser"

For step 6. Make sure that the students run the commands under named user 'azureuser'
	the package url link is: ____
Also make sure that "./local_setup_env.sh" is executed

For step 7. Make sure that the students only modify the top section indicated and not below.

For step 9. The provision of E32 server and ANF provision could take long and timeout and error out. In case it happened, students need to cleanup all the resources and resource group "saprg_ophk_teamXX" and restart this step.

For step 10. Make sure that the students execute this manual step and set the export policy of root access for ALL ANF vol to ne "ON"

For step 12. Students might have issue download packages like putty/etc through default browser. Recommend them to consider installing a different browser.

For step 13. Sometimes there could be package installation from Azure side causing failure of ansible execution, in case that happens, the students will need to clean up resources and resource group "saprg_ophk_teamXX" and restart from step 9.

## Learning Resources

- [SAP GUI Installation Guide](https://help.sap.com/viewer/1ebe3120fd734f67afc57b979c3e2d46/760.05/en-US)

- [SAP HANA studio installation guide](https://help.sap.com/viewer/a2a49126a5c546a9864aae22c05c3d0e/2.0.01/en-US)
