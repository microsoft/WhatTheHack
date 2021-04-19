# Challenge 3: Introduction To Azure Sentinel for SAP and Azure Security Center

[< Previous Challenge](./02-acr.md) - **[Home](../README.md)** - [Next Challenge >](./04-k8sdeployment.md)

## Introduction

Now it is time to introduce the container orchestrator we all came for: Kubernetes!

## Description

In this challenge we will be provisioning our first Kubernetes cluster using the Azure Kubernetes Service (AKS). This will give us an opportunity to learn how to use the `kubectl` kubernetes command line tool, as well as using the Azure CLI to issue commands to AKS.

- Install the Kubernetes command line tool (`kubectl`).
	- **Hint:** This can be done easily with the Azure CLI.
- Create a new, multi-node AKS cluster.
	- Use the default Kubernetes version used by AKS.
	- The cluster will use basic networking and kubenet.  
	- The cluster will use a managed identity
	- The cluster will use Availability Zones for improved worker node reliability.
- Use kubectl to prove that the cluster is a multi-node cluster and is working.
- Use kubectl to examine which availability zone each node is in.  
- **Optional:** Bring up the Kubernetes dashboard in your browser
	- **Hint:** Again, the Azure CLI makes this very easy.
	- **NOTE:** This will not work if you are using an Ubuntu Server jump box to connect to your cluster.
	- **NOTE:** Since the cluster is using RBAC by default, you will need to look up how to enable the special permissions needed to access the dashboard.

## Success Criteria

1. The kubectl CLI is installed.
1. Show that a new, multi-node AKS kubernetes cluster exists.
1. Show that its nodes are running in multiple availability zones.
1. Show that it is using basic networking (kubenet)


Microsoft Azure Sentinel SAP / NetWeaver Continuous Threat Monitoring Limited Private Preview
Step by Step Installation guide 
Using Azure VM as the connector and Azure Key Vault for credentials storage 
Copyright © Microsoft Corporation. This preview software is Microsoft Confidential, and is subject to your Non-Disclosure Agreement with Microsoft. 
You may use this preview software internally and only in accordance with the Azure preview terms, located at private peview-supplemental-terms
Microsoft reserves all other rights

This document details the steps needed to install the Azure Sentinel SAP threat monitoring solution using Azure VM as an agent
1.	Before you begin
•	Ask your Microsoft representative to provide a download username and key for the SAP connector software & to the documentation private repo – this step is valid during private preview. 
To enroll: https://aka.ms/sapsecsurvey 
•	Ensure that you have permissions to create Azure resources
•	Ensure that you have an Azure Sentinel enabled workspace, it’s ID and workspace key. 
to view the ID and key: Azure Sentinel -> settings -> workspace settings -> Agents Management 
•	Ensure that you have SAP team’s support for meeting the SAP system side prerequisites. E.g. SAP_BASIS support packages, Installation of SAP Notes and change requests (CRs), Creation of SAP RFC user(s), Management of SAP audit logs 
•	Ensure networking between the Azure Sentinel Connector 

2.	Compatibility, architecture & Limitations
The following lists high level perquisites and limitations 
•	The solution supports SAP NetWeaver ABAP systems with SAP_BASIS 740 and higher (* check System – Status.. – Click magnifier in SAP System Data. Check here for SAP product versions) 
•	The solution supports SAP systems hosted in Azure, on-premises and 3rd party clouds
•	For optimal functionality please use SAP_BASIS versions 750 SP13 and higher 
 
•	Make sure older systems have the following SAP Notes applied (* SAP transaction code : SNOTE)  :
SAP Note 2641084 – standardized read access for the Security Audit log data
SAP Note 2173545 – CD: CHANGEDOCUMENT_READ_ALL
SAP Note 2502336 – RSSCD100 – read only from archive, not from database
(*) SAP S user account required to access SAP Note 
•	For full documentation of versions supported, data sources and dependencies please refer to the full documentation. 

Architecture
The solution is deployed on a VM, as a docker container
Each SAP system requires and each SAP client requires its own container instan
•	ce

o	Network access from the VM to SAP – ports below and to Azure Sentinel/Key Vault if needed
Designation 	Source	Destination 	TCP Port
SAP application access
(XX – system/host number)	Docker IP	SAP host IP	32xx
			5xx13
			33xx

 
o	The VM and Sentinel workspace can be in different Azure subscriptions and even different Azure AD tenants 

•	Limitations, please refer to full documentation for more details:

o	Each SAP connector instance (docker container) supports one SAP client 
o	The AuditLog file is across SAP clients (system wide) hence in a multi-client SAP system should only be enabled for one instance to avoid data duplication.

3.	Installation overview & shopping list 
The following outlines the installation steps required:
a.	Installing the SAP Continuous Threat Monitoring connector SAP prerequires 
This step will require that SAP Basis professional will import SAP notes as required, SAP change requests to support data retrieval from SAP and create an RFC (NetWeaver access only) user for the Azure Sentinel SAP connector 
b.	Installing an Ubuntu VM (e.g. Ubuntu Server 18.04 LTS) to host the agent
c.	Create or dedicate an Azure Key Vault for storing credentials. 
d.	Running the provided example script to install the SAP connector on the VM 
e.	Ensuring that the Azure Sentinel SAP connector is working properly 
f.	Installing the security content pack on Azure Sentinel 

4.	Installation step A: installation of SAP prerequires 
This section contains the steps required to prepare an SAP system, the steps are included as an outline and SAP basis knowledge is required in order to complete this section
a.	Ensure the required SAP notes (listed in section 2) are deployed. 
b.	Import required SAP change request (CR) as below to the designated NetWeaver system. (* SAP transaction code : STMS_IMPORT)  
Install CR 119 (S4HK900119) for SAP_BASIS version 740 
Install CR 121 (S4HK900121) for SAP_BASIS versions 750 and higher 
This step may require ignoring component versions
 
 
    
Successful installation may end up with warning status code 4 due to the use of Z-Namespaces
Check SAP transaction code SE37 to find newly imported function modules e.g. Z_SENTINEL* 
 
c.	Create the ZSENTINEL_CONNECTOR role by importing CR 86 (S4HK900078) (* SAP transaction code : STMS_IMPORT)  

  

d.	Create a non-dialog RFC/NetWeaver user for the connector on the SAP system and grant the ZSENTINEL_CONNECTOR role to it, ensure the settings are fully propagated. 
This documents describes an installation process using username / password for the ABAP user
 
Briefly check authorizations given to the custom role 
 
e.	Download the SAP NetWeaver RFC SDK 7.50 for Linux on x86_64 64BIT from SAP software download
SAP NetWeaver SDK nwrfc750P_7-70002752.zip 
(* SAP S user required to access SAP Software Download)  

5.	Installation step B: deploy an Ubuntu Server 18.04 LTS VM and assign it with a system assigned managed identity 
notably you should apply your security best practices to protect the VM.
Azure shell:
az vm create  --resource-group [resource group name]   --name [VM Nam– --image UbuntuLTS  --admin-username AzureUs– --data-disk-sizes-gb 10 – --size Standard_DS2_– --generate-ssh-keys  --assign-identity

6.	Installation Step C: assign Key Vault permission to the VM’s managed identity 
Create an Azure Key Vault / use an existing one.
Assign access policy (Get, List and Set) to the VM’s managed identity 
Azure Key Vault – Access Policies - + Add Access Policy – Secret permissions :  Get, List and Set – Select Principal : VM’s name – Add – Save 
Assign an Azure Key Vault access policy (Portal) | Microsoft Docs 
Note: the installation process will create the secrets in the Key Vault, you should remove the set & list permissions afterwards (** make sure to change the role to Key Vault Secrets User after log connector installation) 

Command line A – get the principal ID for the VM
az vm show -g [resource group] -n [Virtual Machin– --query identity.principal– --out tsv

Command line B: assign access permission from the VM to the Key Vault 
az keyvault set-policy  --name $kv  --resource-group [resource group]  --object-id [Principal ID]  --secret-permissions get set

7.	Download and place the SAP NetWeaver RFC SDK for Linux 64 bit in VM logon directory (example file name: , download location (requires SAP portal access): 
SAP NetWeaver SDK nwrfc750P_7-70002752.zip

8.	Step D: install the Azure Sentinel Connector on the VM
•	To complete this step you will need the following information:
 SAP Connector download username and token are required for download 
 SAP SID – the system ID in the SAP NetWeaver system e.g NPL
 SAP Client number e.g. 001
 SAP System number – the number of the SAP system e.g 00
 SAP Username & Password – the SAP username and password created in Step A;  the user must have the ZSENTINEL ROLE assigned to it. The values will be stored in the Key Vault 
 Azure Sentinel Workspace ID – Azure Sentinel – Settings – Workspace settings > (tab) – Agents management
 Azure Sentinel Workspace Key – same as workspace ID 
 the SAP Linux 64 bit NetWeaver RFC SDK zip file placed on the VM:  nwrfc750P_7-70002752.zip  

•	Execute the example installation script on the VM, the script will guide you through the process
Note: this step will install docker, unzip using root privileges (sudo), add the current user to the docker group and execute a docker container for the agent. This means that the running user must have SUDO privileges:
wget -O sapcon-sentinel-kickstart.sh https://raw.githubusercontent.com/YoavDaniely/Azure-Sentinel/master/DataConnectors/SAP/sapcon-sentinel-kickstart.sh && bash ./sapcon-sentinel-kickstart.sh

9.	Step E: Ensure the agent is working properly. & troubleshoot
•	Run the command: docker ps -a and see that the connector docker container is running (in the example SID=NPL)
Expected output:

CONTAINER ID        IMAGE                                         COMMAND                  CREATED             STATUS              PORTS               NAMES
644c46cd82a9        sentinel4sapprivateprview.azurecr.io/sapcon   "/bin/sh -c ./initse…"   5 seconds ago        Up 5 seconds                             sapcon-NPL

If the connector is not running, check if the connector was created by running:
docker ps -a
if you do see the expected output but the docker connector is down, please continue to the next section and review the logs to learn why it has stopped running.
•	View the system log
docker logs -f sapcon-NPL
After bootstrap the output below is expected (polling logs), in case errors displayed please act accordingly
..
Starting Abap Audit Logs Extraction 12/03/2021 16:04:57
Starting API Failover 12/03/2021 16:04:57
Starting Abap Audit Logs Extraction 12/03/2021 16:05:57
Starting API Failover 12/03/2021 16:05:57
Starting Abap Change Docs Log Extraction 12/03/2021 16:06:27
Starting Abap Spool Log Extraction 12/03/2021 16:06:27
Starting Abap Spool Output Log Extraction 12/03/2021 16:06:27
Starting Abap Workflow Log Extraction 12/03/2021 16:06:27
Starting Abap CR Log Extraction 12/03/2021 16:06:27
Starting Abap Audit Logs Extraction 12/03/2021 16:06:57
Starting API Failover 12/03/2021 16:06:57
Starting Abap Audit Logs Extraction 12/03/2021 16:07:57
Starting API Failover 12/03/2021 16:07:57

•	Start a new connector (Docker container)
Run docker start sapcon-NPL and check docker ps -a

•	Ensure the SAP data tables are created in Azure Sentinel (can take up to 15 minutes):
 
•	Troubleshooting – complete logs access
To view all the logs exec into the docker:
docker exec -it sapcon-[SID] bash
Logs directory: 
root@644c46cd82a9:/sapcon-app# ls sapcon/logs/ -l
total 508
-rwxr-xr-x 1 root root      0 Mar 12 09:22 ' __init__.py'
-rw-r--r-- 1 root root    282 Mar 12 16:01  ABAPAppLog.log
-rw-r--r-- 1 root root   1056 Mar 12 16:01  ABAPAuditLog.log
-rw-r--r-- 1 root root    465 Mar 12 16:01  ABAPCRLog.log
-rw-r--r-- 1 root root    515 Mar 12 16:01  ABAPChangeDocsLog.log
-rw-r--r-- 1 root root    282 Mar 12 16:01  ABAPJobLog.log
-rw-r--r-- 1 root root    480 Mar 12 16:01  ABAPSpoolLog.log
-rw-r--r-- 1 root root    525 Mar 12 16:01  ABAPSpoolOutputLog.log
-rw-r--r-- 1 root root      0 Mar 12 15:51  ABAPTableDataLog.log
-rw-r--r-- 1 root root    495 Mar 12 16:01  ABAPWorkflowLog.log
-rw-r--r-- 1 root root 465311 Mar 14 06:54  API.log  view this log to see submits of data into Azure Sentinel
-rw-r--r-- 1 root root      0 Mar 12 15:51  LogsDeltaManager.log
-rw-r--r-- 1 root root      0 Mar 12 15:51  PersistenceManager.log
-rw-r--r-- 1 root root   4830 Mar 12 16:01  RFC.log
-rw-r--r-- 1 root root   5595 Mar 12 16:03  SystemAdmin.log 

•	Review / update config:
Under your user home directory view ~/sapcon/[SID]/systemconfig.ini
After updating, please restart the connector (docker restart sapcon-SID]
•	Useful commands:
Stop connector: docker stop sapcon-[SID]
Start Connector: docker start sapcon-[SID]
View system logs: docker logs -f sapcon-[SID]
Enter the docker container (ssh like): docker exec -it sapcon-[SID] bash

•	Common issues:

o	Network connectivity issues to SAP or Azure Sentinel 
o	Wrong ABAP (SAP user) credentials, fix that by applying the right credentials to ABAPUSER and ABAPPASS in the Azure KeyVault
o	Missing permissions, role not assigned to SAP user, fix that by asking SAP basis to assign the role ZSENTINEL_CONNECTOR to the user and ensure it is fully active 
o	Missing SAP CR – import the SAP CR (STEP A) to the SAP system 
o	Wrong Azure Sentinel Workspace ID or Key: fix that by applying the right credentials in Azure KeyVault
o	Corrupt or missing SAP SDK zip file : fix by reinstalling and ensuring you use the correct Linux 64bit version
o	Missing data in workbook / alerts – ensure auditlog policy (RSAU_CONFIG_LOG transaction) are properly enabled on the SAP side, no errors in the log file 

10.	Step F: Installing the content
Open Azure shell PowerShell.
a. Install the Azure Sentinel module:
PS>Install-Module -Name Az.SecurityInsights	

b. Importing Detections
upload the following files to your shell:
Detections (repo login required)
importscript (repo login required) 

Run ./import.ps1

c. Import workbook
Take the workbook from: https://raw.githubusercontent.com/Azure/AzureSentinel4SAP/main/Workbooks/SAP%20Security%20Monitoring%20Workbook.txt
Create a new workbook and paste the content 
d. Import Watchlist
Manually create all the watchlists under the same name as in: https://github.com/Azure/AzureSentinel4SAP/tree/main/Watchlists
Update the watchlist content to match your systems

