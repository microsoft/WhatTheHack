# Challenge 1: Update 01-SAP-Auto-Deployment.md

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-acr.md)

## Introduction

This document introduces an automation tool for SAP Basis person on provision of (1) all necessary Azure infrastructure (compute/storage/network) (2) server configurations and SAP system installation. The tool is based on Terraform and Ansible script.

## Description

During the exercise, participants will be able to provision a landscape into Azure for SAP environment and then build a fresh SAP S4H system by using an existing backup files into this environment as shown in the following diagram. SAP HANA DB will use Azure Netapp Filesystem for storage volume. 

![image](https://user-images.githubusercontent.com/73615525/115279764-f99d4080-a0fb-11eb-9e56-d43ee96fe173.png)

## Success Criteria

1.	Complete build of SAP S4H and SAP HANA database on Azure Cloud.
2.	Successful Installation of SAP GUI and test logon to SAP Application Server

## Steps

Step 1: Identify your Group number XX (which will be used later for configurations)

Step 2: Open Azure Portal, Powershell Window. Run the following command to create Service Principle and save the Password to Notepad

$sp = New-AzADServicePrincipal -DisplayName AutoSAPDeployAdmin 

$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($sp.Secret) 

$password = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr) 

Write-output $password

Step 3: Open Azure Portal, record the Azure Subscription ID and save to Notepad

Step 4: In Azure Portal, go to Azure Active Directory App Registration select Service Principle “AutoSAPDeployAdminXX”  record Application (client) ID and Directory (tenant) ID field to Notepad

Step 5: Provision an ubuntu linux server through Azure portal (18.04 LTS, SKU: Standard DS1 v2) with named user “azureuser” and password “Welcome!2345”. You will start all the Azure infrastructure provision from this server.

Step 6: Login to the server as the named user “azureuser” and run the following commands:

% mkdir TST200/

% cd TST200/	 

% wget “ [Coach will provide the package_url ]

% gzip -d  ophk.tar .gz

% tar xf  ophk.tar	 

% ./local_setup_env.sh  

Step 7: Edit the following parameters in the “main.inputs” file in the TST200 directory: In the azure_login section, replace all the “xxxxx” with the data taken down from step 2-4. 
 subscription_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
 client_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"	 
 client_secret:  "xxxxxxxxxxxxxxxxxxxxxxxxxx"       tenant_id:  "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"  

Change in the Resource prefix section, change the “teamxx” XX to represent your team number. Eg. “team00” from step 1.

Add Team number to the Resource group in the Resource Group section:

Name: “saprg_ophk_teamXX”
State: “new”
Region: “westus2”
You can change the three-letter SAP system ID parameter, if desired. 
e.g. SAP_system_name: “S4P”

Save the “main_inputs” file. Stay in the same directory.
Step 8: Generate runnable terraform scripts 
% python3 gen_terraform_script.py 
Step 9: stay in the same directory, run terraform script to build the Azure infrastructure – this will run for 15-20 minutes.
% ./Run_Terraform_Build.sh 
Step 10: At the end of the execution, locate Window Jumpbox  (pipwinbox) and note the publix IP address in order to RDP to the Window Jumpbox. login credential:  azureuser/Welcome!2345 
Step 11: Logon to portal: go to ANF account created and display each ANF volumes and check the export policy for every volume has “Root Access” to be “On”. If it shows “Off” then change it to “On” and save – for each NetApp file volumes.
Step 12: Logon to the window jumpbox. Download the following tools and SAP packages: Note, you might want to install and switch to some other browser to download these as the default browser with window defender will block the direct download. 
Putty.exe: coach will provide the link 
 
SAP GUI 7.60: coach will provide the link 
 
HANA studio 2.0: coach will provide the link 

Step 13: From the window jumpbox, logon to the linux jumpbox:
Putty session to “teamxx-linux-jumpbox” with the credential  azureuser/Welcome!2345. Note: Replace “xx” with your team number chosen in step 3. 
% cd ~azureuser/Current_Deployment 
% cd ansible 
% ./SAP_Ansible_Deploy.sh 
Note: this script will config and install a complete SAP system which may run up to 7 hours. For a S4Hana instance fresh install it could take much longer. 
While the ansible script is running, you can continue with step 5 on install SAPGUI and SAP HANA studio on Window Jumpbox.  
Step 14: Using SAP HANA Studio, connect to SAP HANA DB to verify Database is up and running.
Step 15: Login to SAP GUI to test connection SAP Application.

## Reference

SAP GUI installation guide: https://github.com/Microsoft-SAPonAzure-OpenHack/Learning-the-OpenHack-Way/blob/main/01-SAP-Auto-Deployment/Azure%20Openhack%20SAP%20GUI%20installation%20Steps.pdf
