# Challenge 6: SAP Start Stop Automation

[< Previous Challenge](./05-PowerApps.md) - **[Home](../README.md)** - [Next Challenge >](./07-PowerQuery.md)

## Introduction

Contoso Inc is looking to optimize the cost of SAP landscape and exploring ways to do that. They're leaning towards getting Reserves Instances (RI) for all production systems and would like to save cost on non-production (sandboxes, project systems, etc.) systems by not operating those during non-business hours. This solution helps them achieve that either using automation tools or schedule based


## Description

The goal of this solution is to facilitate a controlled shutdown & startup of SAP systems, which is a common mechanism to save costs for non Reserved Instances (RI) VMs in Azure.

**Note**: VMs must be deallocated for Azure charges to stop and that's facilitated by scripts

This flexible solution enables (using Azure automation, Azure Tags, Scripting, and PowerShell runbooks):

- Start & Stop of your SAP application servers, central services, database, and corrosponding VMs
- Optionally convert Premium Managed Disks to Standard during the stop procedure, and back to Premium during the start procedure, thus saving cost storage as well  

SAP systems start and stop is done gracefully (using SAP native commands), allowing SAP users and batch jobs to finish (with timeout) minimizing downtime impact. 
For detailed information refer below [Architecture](https://github.com/Microsoft-SAPonAzure-OpenHack/WhatTheHack/blob/master/999-SAPonAzure/Student/06-Start-Stop-Automation.md#architecture-of-the-startstop-solution).

## Architecture of the Start/Stop solution 

The solution is using Azure automation account PaaS solution to execute the SAP shutdown/startup jobs (as shown in the below diagram).
Runbooks are written in PowerShell. There is also a PowerShell module SAPAzurePowerShellModules that is used by all runbooks. These runbooks and module are stored in PowerShell Gallery, and are easy to import. 

![image](https://user-images.githubusercontent.com/26795040/115051125-19d1c300-9ea2-11eb-9df9-e2d5425e3c70.png)

Information about SAP landscape and instances are to be stored in VM Tags.

Secure assets in Azure Automation include credentials, certificates, connections, and encrypted variables. These assets are encrypted and stored in Azure Automation using a unique key that is generated for each Automation account. [Azure Automation stores the key in the system-managed Key Vault](https://docs.microsoft.com/en-us/azure/automation/shared-resources/credentials?tabs=azure-powershell). Before storing a secure asset, Automation loads the key from Key Vault and then uses it to encrypt the asset.

SAP system start / stop / monitoring and SAP Application server Start / stop is implemented using scripts (calling SAP sapcontrol executable) via the Azure VM agent. 

SAP HANA start / stop / monitoring is implemented using scripts (calling SAP sapcontrol executable) via the Azure VM agent. 

SQL Server start / stop / monitoring is implemented using scripts (calling SAP Host Agent executable) via the Azure VM agent. 

Azure runbooks can either be executed manually or scheduled. 

## Success Criteria

- Create Azure Automation account
- Tag all the VMs for the **SID** in place
- List the SID to ensure all the systems were tagged correctly
- Execute runbook manually to stop systems
- Schedule the runbook to start the systems
- (Optional) Restrict access to runbooks to an individual user

## Learning Resources 

- [Manage credentials in Azure Automation](https://docs.microsoft.com/en-us/azure/automation/shared-resources/credentials?tabs=azure-powershell)
 
- [Azure Quickstart - Create an Azure Automation account](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account)

- [SAP Library - Tools for Monitoring the System](https://help.sap.com/saphelp_aii710/helpdata/en/f7/cb8577bc244a25a994fc3f9c16ce66/frameset.htm)

- [Azure Automation Start/Stop VMs during off-hours overview](https://docs.microsoft.com/en-us/azure/automation/automation-solution-vm-management)

- [Pricing - Managed Disks](https://azure.microsoft.com/en-us/pricing/details/managed-disks/)

- [Pricing - Automation](https://azure.microsoft.com/en-us/pricing/details/automation/)


### **Import Az.Modules**

SAP start / stop PowerShell (PS) runbooks use new Az PS module, so import following AZ modules:

  - **Az.Account**

  - **Az.Compute**

  - **Az.Automation**

  - **Az.Resources**


### **Import SAP PowerShell Module**

Import **SAPAzurePowerShellModules** PowerShell module that will be used by SAP Runbooks.

**NOTE:**
PowerShell module `SAPAzurePowerShellModules` is stored in PowerShell Gallery and is easy to import into Azure automation account.


### **Import SAP Runbooks**

Navigate to **Runbook Gallery** and Import these runbooks:

  - Stop-SAPSystem

  - Start-SAPSystem

  - List-SAPSystemInstances

  - Stop-SAPHANA

  - Start-SAPHANA

  - List-SAPHANAInstance

  - Start-SAPApplicationServer

  - Stop-SAPApplicationServer

  - Tag-SAPSystemASCSInstanceLinux

  - Tag-SAPSystemDialogInstanceLinux

  - Tag-SAPSystemStandaloneHANA

**NOTE:**
All SAP runbooks are stored in PowerShell Gallery and are easy to import into Azure automation account.


### Tagging and executing Runbooks

**Example Distributed SAP ABAP System with HANA – ALL Linux**

Here is an example of a distributed SAP ABAP System **TS1** with HANA
DB. ALL VMs are Linux VMs. SAP HANA SID **TS2** is different than SAP
SID **TS1**.

![image](https://user-images.githubusercontent.com/26795040/115051256-3a9a1880-9ea2-11eb-90ce-c7f4c2e4e328.png)

**HANA DB VM**

DB has following properties.

<table>
<thead>
<tr class="header">
<th><strong>Properties</strong></th>
<th><strong>Value</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>VM Name</td>
<td>ts2-db</td>
</tr>
<tr class="even">
<td>Azure Resource Group Name</td>
<td>gor-linux-eastus2</td>
</tr>
<tr class="odd">
<td>SAP System SID</td>
<td>TS1</td>
</tr>
<tr class="even">
<td><p>SAP HANA SID *</p>
<p>* in central SAP system HANA SID is can be different than SAP System SID</p></td>
<td>TS2</td>
</tr>
<tr class="odd">
<td>SAP HANA Instance Nr</td>
<td>0</td>
</tr>
</tbody>
</table>

VM \[ts2-db\] has to be tagged with following Tags:

| Tag                   | Value |
| --------------------- | ----- |
| SAPSystemSID          | TS1   |
| SAPHANASID            | TS2   |
| SAPDBMSType           | HANA  |
| SAPHANAINstanceNumber | 0     |

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook: **Tag-SAPSystemStandaloneHANA**

| Parameter             | Mandatory | Value             |
| --------------------- | --------- | ----------------- |
| ResourceGroupName     | YES       | gor-linux-eastus2 |
| VMName                | YES       | ts2-db            |
| SAPSID                | YES       | TS1               |
| SAPHANASID            | YES       | TS2               |
| SAPHANAINstanceNumber | YES       | 0                 |

**ASCS VM**

ASCS has following properties.

| **Properties**            | **Value**         |
| ------------------------- | ----------------- |
| Azure Resource Group Name | gor-linux-eastus2 |
| VM Name                   | ts2-ascs          |
| SAP System SID            | TS1               |
| SAP ASCS Instance Nr      | 0                 |

VM \[ts2-ascs\] has to be tagged with following Tags:

| Tag                          | Value     |
| ---------------------------- | --------- |
| SAPSystemSID                 | TS1       |
| SAPApplicationInstanceType   | SAP\_ASCS |
| SAPApplicationInstanceNumber | 1         |

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook:
**Tag-SAPSystemASCSInstanceLinux**

| Parameter             | Mandatory | Value             |
| --------------------- | --------- | ----------------- |
| ResourceGroupName     | YES       | gor-linux-eastus2 |
| VMName                | YES       | ts2-ascs          |
| SAPSID                | YES       | TS1               |
| SAPASCSInstanceNumber | YES       | 1                 |

**SAP Application Server VM #1**

SAP application server 1 has following properties.

| **Properties**            | **Value**         |
| ------------------------- | ----------------- |
| Azure Resource Group Name | gor-linux-eastus2 |
| VM Name                   | ts2-di0           |
| SAP System SID            | TS1               |
| SAP Dialog Instance Nr    | 1                 |

VM \[ts2-di0\] has to be tagged with following Tags:

| Tag                          | Value  |
| ---------------------------- | ------ |
| SAPSystemSID                 | TS1    |
| SAPApplicationInstanceType   | SAP\_D |
| SAPApplicationInstanceNumber | 1      |

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook: Tag-SAPSystemDialogInstanceLinux

| Parameter               | Mandatory | Value             |
| ----------------------- | --------- | ----------------- |
| ResourceGroupName       | YES       | gor-linux-eastus2 |
| VMName                  | YES       | ts2-ascs          |
| SAPSID                  | YES       | TS1               |
| SAPDialogInstanceNumber | YES       | 1                 |

**SAP Application Server VM #2**

SAP application server 2 has following properties.

| **Properties**            | **Value**           |
| ------------------------- | ------------------- |
| Azure Resource Group Name | gor-linux-eastus2-2 |
| VM Name                   | ts2-di1             |
| SAP System SID            | TS1                 |
| SAP Dialog Instance Nr    | 2                   |

VM \[ts2-di0\] has to be tagged with following Tags:

| Tag                          | Value  |
| ---------------------------- | ------ |
| SAPSystemSID                 | TS1    |
| SAPApplicationInstanceType   | SAP\_D |
| SAPApplicationInstanceNumber | 2      |

**You can create these Tags manually. However, to simplify, avoid typos, and automate the tagging process use Azure runbook**: Tag-SAPSystemDialogInstanceLinux

| Parameter               | Mandatory | Value               |
| ----------------------- | --------- | ------------------- |
| ResourceGroupName       | YES       | gor-linux-eastus2-2 |
| VMName                  | YES       | ts2-di1             |
| SAPSID                  | YES       | TS1                 |
| SAPDialogInstanceNumber | YES       | 2                   |


###  Runbook Description

**Listing SAP System \<SID\> VMs: List-SAPSystemInstance**s

| Parameter | Mandatory | Default value | Comment |
| --------- | --------- | ------------- | ------- |
| SAPSID    | YES       |               |         |

**Listing SAP HANA VM: List-SAPHANAInstance**

| Parameter | Mandatory | Default value | Comment |
| --------- | --------- | ------------- | ------- |
| SAPSID    | YES       |               |         |

**Start SAP System: Start-SAPSystem**

| Parameter                 | Mandatory | Default value | Comment                                                |
| ------------------------- | --------- | ------------- | ------------------------------------------------------ |
| SAPSID                    | YES       |               |                                                        |
| WaitForStartTimeInSeconds | No        | 600           | Wait time to start SAP system                          |
| ConvertDisksToPremium     | No        | $False        | If set to $True, all disk will be converted to Premium |
| PrintExecutionCommand     | No        | $False        | If set to $True, all OS commands will be printed       |

**Runtime steps:**

  - Convert disk to Premium, if desired  
    ConvertDisksToPremium = $True

  - Start VMs in this order:
    
      - SAP ASCS or DVEBMS VM
    
      - SAP DBMS VM
    
      - SAP Dialog instances VMs

  - Show SAP DBMS Status

  - Start SAP DBMS

  - Show SAP DBMS Status

  - List SAP ABAP instances and show status.

<!-- end list -->

  - Start SAP ABAP system and wait for WaitForStartTimeInSeconds
    seconds.

  - List SAP ABAP instances and show status.

  - Show summary.

**Stop SAP System: Stop-SAPSystem**

| Parameter                 | Mandatory | Default value | Comment                                                 |
| ------------------------- | --------- | ------------- | ------------------------------------------------------- |
| SAPSID                    | YES       |               |                                                         |
| SoftShutdownTimeInSeconds | No        | 600           | Soft Shutdown time for SAP system                       |
| ConvertDisksToStandard    | No        | $False        | If set to $True, all disk will be converted to standard |
| PrintExecutionCommand     | No        | $False        | If set to $True, all OS commands will be printed        |

Runtime steps:

  - List SAP ABAP instances and show status.

  - Stop SAP ABAP System with soft shutdown SoftShutdownTimeInSeconds

  - List SAP ABAP instances and show status.

  - Get SAP DBMS status

  - Stop SAP DBMS

  - Get DBMS status

  - Stop VMs in this order:
    
      - SAP Dialog instances VMs
    
      - SAP DBMS VM
    
      - SAP ASCS or DVEBMS VM

  - Convert disk to Standard, if desired  
    ConvertDisksToStandard = $True

<!-- end list -->

  - Show summary.

**Start-SAPHANADB**

This runbook will only start VM and standalone HANA DB.

| **Parameter**         | **Mandatory** | **Default value** |
| --------------------- | ------------- | ----------------- |
| SAPHANASID            | YES           |                   |
| ConvertDisksToPremium | No            | $False            |
| PrintExecutionCommand | No            | $False            |

Runtime steps are:

  - Convert disk to Premium, if desired  
    ConvertDisksToPremium = $True

  - Start VM.

  - Show SAP HANA Status

  - Start SAP HANA

  - Show SAP HANA Status

  - Show summary.

**Stop-SAPHANADB**

This runbook will stop standalone HANA DB, and VM.

| **Parameter**          | **Mandatory** | **Default value** |
| ---------------------- | ------------- | ----------------- |
| SAPHANASID             | YES           |                   |
| ConvertDisksToStandard | No            | $False            |
| PrintExecutionCommand  | No            | $False            |

Runtime steps:

  - Show SAP HANA Instance status

  - Stop SAP HANA

  - Show SAP HANA status

  - Stop VM.

  - Convert disk to Standard, if desired  
    ConvertDisksToStandard = $True

  - Show summary.


**Stop- SAPApplicationServer**

This runbook will stop standalone SAP Application Server and VM.

| **Parameter**                | **Mandatory** | **Default value** |
| ---------------------------- | ------------- | ----------------- |
| ResourceGroupName            | YES           |                   |
| VMName                       | YES           |                   |
| SAPApplicationServerWaitTime | No            | 300               |
| ConvertDisksToStandard       | No            | $False            |
| PrintExecutionCommand        | No            | $False            |

Runtime steps:

  - Stop SAP application server.

  - Stop VM.

  - Convert disk to Standard, if desired  
    ConvertDisksToStandard = $True

  - Show summary.

**Start- SAPApplicationServer**

This runbook will start VM and standalone SAP Application Server.

| **Parameter**                | **Mandatory** | **Default value** |
| ---------------------------- | ------------- | ----------------- |
| ResourceGroupName            | YES           |                   |
| VMName                       | YES           |                   |
| SAPApplicationServerWaitTime | No            | 300               |
| ConvertDisksToPremium        | No            | $False            |
| PrintExecutionCommand        | No            | $False            |

Runtime steps:

  - Convert disk to Premium, if desired  
    ConvertDisksToPremium = $True

  - Start VM.

  - Start SAP application server.

  - Show summary.

