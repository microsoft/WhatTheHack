# Challenge 1: SAP Auto Deployment

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-Azure-Monitor.md)

## Introduction

Contoso Inc is an established manufacturer planning to modernize IT infrastructure. As part of their plan, Contoso wants to migrate existing SAP systems from on-premise to Azure more rapidly. They identified SAP on Azure github repo and liked the Microsoft provided automation content. The document introduces an automation tool to provision of all necessary Azure infrastructure, server configurations, and SAP system installation. The automation tool is based on Terraform and Ansible script.

**NOTE:**
The files for this challenge can be found in a zip file in the Files tab of the General Channel for this hack.

## Description

During the exercise, the Participants will be able to provision a landscape into Azure for SAP environment and then build a fresh SAP system by using an existing backup files into this environment as shown in the following diagram. SAP HANA DB will use Azure Netapp Filesystem for the storage volume. 
_Please note that this may take up to 4 hours to complete once automation is kicked off._

![image](https://user-images.githubusercontent.com/73615525/115279764-f99d4080-a0fb-11eb-9e56-d43ee96fe173.png)

1. Identify your Group number, which will be added to the configuration file.
2. Open Azure Portal, Powershell Window, run the following command to create Service Principle and save the Password to Notepad.
```
$sp = New-AzADServicePrincipal -DisplayName AutoSAPDeployAdminXX
$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($sp.Secret)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
Write-output $password
```
3. Open Azure Portal, record the Azure Subscription ID and save to Notepad.

`In Azure Portal, go to Azure Active Directory => App Registration => select Service Principle “AutoSAPDeployAdminXX” => record Application (client) ID and Directory (tenant) ID field to Notepad.`

4. Provision an ubuntu linux server through Azure portal (18.04 LTS, SKU: Standard DS1 v2) with user id `azureuser` and give a `password` and make a note of it. You will start all the Azure infrastructure provision from this server.

5. Login to the server as the named user `azureuser` and run the following commands (please remember to use the named user login `azureuser` instead of any other named user). _Coach will provide the package_url during the session._

```
% mkdir TST200/
% cd TST200/
% wget "[package_url]" -O ophk.tar.gz
% gzip -d ophk.tar.gz
% tar xf ophk.tar
% ./local_setup_env.sh
```
6. Edit the following parameters in the `main.inputs` file in the TST200 directory: In the azure_login section, replace all the **xxxxx** with the data taken down from step 2-4.
```
subscription_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_secret: "xxxxxxxxxxxxxxxxxxxxxxxxxx"
tenant_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"
Change in the Resource prefix section, change the "teamxx** XX to represent your team number. Eg. “team00” from step 1. Add Team number to the Resource group in the Resource Group section: Name: “saprg_ophk_teamXX” State: “new” Region: “westus2”
You can change the three-letter SAP system ID parameter, if desired. e.g. SAP_system_name: “S4P” Save the “main_inputs” file. Stay in the same directory.
```
7. Generate runnable terraform scripts.
```
% python3 gen_terraform_script.py
```
8. stay in the same directory, run terraform script to build the Azure infrastructure – this will run for 15-20 minutes.
```
% ./Run_Terraform_Build.sh
```
9. [Temporarily the manual correction process] Logon to portal: go to ANF account created and display each ANF volumes and check its export policy, make sure that the `Root Access` is set `On`. If the export policy shows `Off` then change it to `On` and save – this is needed for each NetApp file volumes.

    ![image](https://user-images.githubusercontent.com/56409709/117387387-d376ef00-aeb6-11eb-8563-bbd7adf9134f.png)

10. At the end of the step 9, locate Window Jumpbox (pipwinbox) and note the public IP address in order to RDP to the Window Jumpbox. Use the login credential which the coach will provide for the next step (see below).

       ![image](https://user-images.githubusercontent.com/56409709/117386242-901b8100-aeb4-11eb-8d7e-e2a0f2bfc4b9.png)

11. Logon to the window jumpbox. Download the following tools and SAP packages: Note, you might want to install and switch to some other browser to download these as the default browser with window defender will block the direct download.

```
Putty.exe
SAP GUI
SAP HANA Studio
SAP GUI 7.60: coach will provide the link
HANA studio 2.0: coach will provide the link
```
12. From the window jumpbox, logon to the linux jumpbox: Putty session to server “teamxx-linux-jumpbox” with the credential azureuser/correct password. Note: Replace “xx” with your team number chosen previously.
```
% cd ~azureuser/Current_Deployment
% cd ansible
% ./SAP_Ansible_Deploy.sh
Note: this script does all the configs and then install a complete SAP system which may run up to 4 hours. While this ansible script is running, you can continue with next steps on installing SAPGUI on the Window Jumpbox.
```
13. Once the deployment script completes, login to SAP system (SID=S4P, instance #00, app server: teamXX-app01) through GUI to test connection SAP Application and continue other challenges.

## Success Criteria

- Complete build of SAP S4H and SAP HANA database on Azure Cloud.
- Successful Installation of SAP GUI and test logon to SAP Application Server
- Deploy SAP S/4 hana system using the available automation script in resourses folder.
- Verify all the resources deployed and be familiarize yourself.

## Learning Resources

- [SAP GUI Installation Guide](https://help.sap.com/viewer/1ebe3120fd734f67afc57b979c3e2d46/760.05/en-US)

- [SAP HANA studio installation guide](https://help.sap.com/viewer/a2a49126a5c546a9864aae22c05c3d0e/2.0.01/en-US)
