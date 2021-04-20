# Challenge 1: Update 01-SAP-Auto-Deployment.md

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-Azure-Monitor.md)

## Introduction

This document introduces an automation tool for SAP Basis persons on provision of (1) all necessary Azure infrastructure (compute/storage/network) (2) server configurations and SAP system installation. The tool is based on Terraform and Ansible script.

## Description

During the exercise, participants will be able to provision a landscape into Azure for SAP environment and then build a fresh SAP S4H system by using an existing backup files into this environment as shown in the following diagram. SAP HANA DB will use Azure Netapp Filesystem for storage volume. 

![image](https://user-images.githubusercontent.com/73615525/115279764-f99d4080-a0fb-11eb-9e56-d43ee96fe173.png)

## Success Criteria

1.	Complete build of SAP S4H and SAP HANA database on Azure Cloud.
2.	Successful Installation of SAP GUI and test logon to SAP Application Server

## Guidelines

![image](https://user-images.githubusercontent.com/81709232/115320694-376b8a80-a137-11eb-93f8-ba9d2f6fd64d.png)

Step 1: Identify your Group number XX (which will be used later for configurations)

Step 2: Open Azure Portal, Powershell Window. Run the following command to create Service Principle and save the Password to Notepad

 $sp = New-AzADServicePrincipal -DisplayName AutoSAPDeployAdminXX  
 $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($sp.Secret)
 $password = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)  
 Write-output $password

![image](https://user-images.githubusercontent.com/81709232/115281792-3e29db80-a0fe-11eb-801f-bc3d4c2ee57a.png)

Step 3: Open Azure Portal, record the Azure Subscription ID and save to Notepad

Step 4: In Azure Portal, go to Azure Active Directory => App Registration => select Service Principle “AutoSAPDeployAdminXX” => record Application (client) ID and Directory (tenant) ID field to Notepad

![image](https://user-images.githubusercontent.com/81709232/115281830-4c77f780-a0fe-11eb-8bc8-ba9a6eac5072.png)

![image](https://user-images.githubusercontent.com/81709232/115281970-77fae200-a0fe-11eb-8b65-8e884527e6cf.png)

Step 5: Provision an ubuntu linux server through Azure portal (18.04 LTS, SKU: Standard DS1 v2) with named user “azureuser” and password “ use your own password and remember it ”. You will start all the Azure infrastructure provision from this server.

Step 6: Login to the server as the named user “azureuser” and run the following commands:

% mkdir TST200/

% cd TST200/

% wget “https[package_url]”  -O ophk.tar.gz

  coach will provide the package_url during the session.

% gzip -d  ophk.tar.gz

% tar xf  ophk.tar

% ./local_setup_env.sh



Step 7: Edit the following parameters in the “main.inputs” file in the TST200 directory: In the azure_login section, replace all the “xxxxx” with the data taken down from step 2-4. 

 subscription_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
 
 client_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
 
 client_secret:  "xxxxxxxxxxxxxxxxxxxxxxxxxx" 
 
 tenant_id:  "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"
 
  
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

![image](https://user-images.githubusercontent.com/81709232/115282055-93fe8380-a0fe-11eb-95eb-1cd6d6e7d572.png)

![image](https://user-images.githubusercontent.com/81709232/115282096-a1b40900-a0fe-11eb-9c47-88c647cb9310.png)

![image](https://user-images.githubusercontent.com/81709232/115282125-aaa4da80-a0fe-11eb-8f4e-f47907c65188.png)

Step 10: At the end of the execution, locate Window Jumpbox  (pipwinbox) and note the public IP address in order to RDP to the Window Jumpbox. Use the following login credential:  azureuser/password that you provided

Step 11: [Manual correction process] Logon to portal: go to ANF account created and display each ANF volumes and check the export policy for every volume, make sure that the “Root Access” is set “On”. If it shows “Off” then change it to “On” and save – this is needed for each NetApp file volumes.

![image](https://user-images.githubusercontent.com/81709232/115282173-bd1f1400-a0fe-11eb-8cb3-8d76f2def7f9.png)

![image](https://user-images.githubusercontent.com/81709232/115282202-c9a36c80-a0fe-11eb-991e-c8aad9222e9a.png)

Step 12: Logon to the window jumpbox. Download the following tools and SAP packages: Note, you might want to install and switch to some other browser to download these as the default browser with window defender will block the direct download. 

Putty.exe: coach will provide the link
SAP GUI 7.60: coach will provide the link
HANA studio 2.0: coach will provide the link

Step 13: From the window jumpbox, logon to the linux jumpbox:
Putty session to server “teamxx-linux-jumpbox” with the credential  azureuser/correct password. Note: Replace “xx” with your team number chosen previously. 

% cd ~azureuser/Current_Deployment

% cd ansible

% ./SAP_Ansible_Deploy.sh


Note: this script does all the configs and then install a complete SAP system which may run up to 7 hours. 
While this ansible script is running, you can continue with next steps on installing SAPGUI on the Window Jumpbox.  

Step 14: Once the deployment script completes, login to SAP GUI to test connection SAP Application and continue other challenges.

## Reference

SAP GUI installation guide: https://github.com/Microsoft-SAPonAzure-OpenHack/Learning-the-OpenHack-Way/blob/main/01-SAP-Auto-Deployment/Azure%20Openhack%20SAP%20GUI%20installation%20Steps.pdf
