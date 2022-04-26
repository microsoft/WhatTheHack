# Challenge 6: SAP Start Stop Automation - Coach's Guide

[< Previous Challenge](./05-PowerApps.md) - **[Home](README.md)** - [Next Challenge >](./07-PowerQuery.md)

# Notes & Guidance

Here are the details of the solution and instructions on how to execute it in your landscape

**Be sure to read the [Frequently Asked Questions](#Frequently-Asked-Questions) at the end of this document**
    
# Overview of the solution 

The goal of this solution is to facilitate a controlled shutdown & startup of SAP systems, which is a common mechanism to save costs for non Reserved Instances (RI) VMs in Azure.

Note: VMs must be deallocated for Azure charges to stop and that's facilitated by scripts

This is ready, flexible, end-to-end solution (including Azure automation runtime environment, scripts, and runbooks, tagging process etc.) that enables:

Start & Stop of your SAP application servers, central services, database, and corrosponding VMs
Optionally convert Premium Managed Disks to Standard during the stop procedure, and back to Premium during the start procedure, thus saving cost storage as well
SAP systems start and stop is done gracefully (using SAP native commands), allowing SAP users and batch jobs to finish (with timeout) minimizing downtime impact.

**This solution is based on [Start Stop Automation](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities/tree/main/Start-Stop-Automation/Automation-Backend) developed by SAP on Azure CAT Team (Cloud Advisory Team) and SAP on Azure FastTrack Team.**

# Solution Capabilities

In details, with this solution you can do the following:

- **Start / Stop of complete SAP NetWeaver Central System** on **Linux** or **Windows**, and **VM**.
  
    Typical scenario here is non prod SAP systems

- **Start / Stop of complete SAP NetWeaver Distributed System** on **Linux** or **Windows** and VMs.

    Typical scenario here is non prod SAP systems.

    Here you have:
    -	One DBMS VM (HA is currently not implemented)
    -   One ASCS/SCS or DVEBMGS VM (HA is currently not implemented)
    -	One or more SAP application servers
    -	This solutution assumed that SAPMNT file share is located on SAP ASCS or DVEBMGS VM.


-	In a distributed SAP landscape, you can deploy your SAP instances across multiple VMs, and those VMs can be placed in different Azure resources groups.

  -	In a distributed SAP landscape, SAP application instances (application server and SAP ASCS/SCS insatnce) can be on Windows and DBMS on Linux (this is so caller **heterogenous landscape**), for DBMS that support such scenario for example SAP HANA, Oracle, IBM DB2, SAP Sybase and SAP MaxDB.

- On DBMS side, starting, stopping, getting status of DBMS itself is implemented for: 
  - **SAP HANA DB**
  -	**Microsoft SQL Server DB**

- Currently, starting, stopping, getting status of DBMS is **NOT** implemented for **Oracle**, **IBM DB2**, **Sybase** and **MaxDB DBMSs**. 

   Still, you can use the solution with these DBMSs.
   During the startup procedure, solution is relying on automatic DB start during the VM start (on Windows), and SAP system start will also automatically trigger DBMS start. Although we did not test this, expectation is that this approach will work.

- **Start / Stop Standalone HANA system and VM**

- **Start / Stop SAP Application Server(s) and VM(s)**

   This functionality can be used for SAP application servers scale out -scale in process.   

   One meaningful scenario is for productive SAP systems, can be that you as an SAP system admin identify SAP system peaks (for example Black Friday or end year closure), where you know in advance how much of SAPS / application server you would need and at that time, and for how long. Then you can either schedule start / stop or execute by a user of certain numbers of already prepared SAP application servers, that will cover the load peak. 

-	**Converting the disks from Premium to Standard managed disks** during the stop process, and other way around during the start process to **reduce the costs**.

-	Starting / Stopping is possible to executed manually by a user, or it can be scheduled.

![image](https://user-images.githubusercontent.com/26795040/115053651-fa886500-9ea4-11eb-93b5-93bec67053cb.png)



# Graceful Shutdown of SAP System, Application Servers, and DBMS 

## SAP System and SAP Application Servers

The stopping of the SAP system or SAP application server will be done using an [SAP soft shutdown or graceful shutdown procedure](https://help.sap.com/saphelp_aii710/helpdata/en/f7/cb8577bc244a25a994fc3f9c16ce66/frameset.htm), within specified timeout. SAP soft shutdown, and is gracefully handling SAP process, users etc. in a specified downtime time, during the stop of whole SAP system or one SAP application server. 

![image](https://user-images.githubusercontent.com/26795040/115053673-007e4600-9ea5-11eb-8cc7-ca55e87207e6.png)

 Users will get a popup to log off, SAP application server(s) will be removed from different logon groups (users, batch RFC etc.), procedure will wait for SAP batch job to be finished (until a specified timeout is reached). This is functionality implemented in the SAP kernel.

![image](https://user-images.githubusercontent.com/26795040/115053690-06742700-9ea5-11eb-9aad-6b4e43f556dd.png)

> [!NOTE]
> You can specify in the user interface the SAP soft shutdown time. Default value is 300 sec.  
![image](https://user-images.githubusercontent.com/26795040/115053725-0d9b3500-9ea5-11eb-9fcf-4883fc2e753f.png)


## DBMS Shutdown

For SAP HANA and SQL Server, it is also implemented DB soft shutdown, which will gracefully stop these DBMS, so DB will have time to flush consistently all content from memory to storage and stop all DB process. 

## How to execute

A user can trigger start / stop using Azure Automation account portal UI


# Architecture

The solution is using Azure automation account PaaS solution as an automation platform to execute the SAP shutdown/startup jobs.
Runbooks are written in PowerShell. There is also a PowerShell module SAPAzurePowerShellModules that is used by all runbooks. These runbooks and module are stored in PowerShell Gallery, and are easy to import. 

![image](https://user-images.githubusercontent.com/26795040/115053911-3d4a3d00-9ea5-11eb-9576-db36d86022f9.png)

Information about SAP landscape and instances are store in VM Tags.

<sid>adm password needed on Windows OS is stored securely in **Credentials** area of Azure automation account. 

Secure assets in Azure Automation include credentials, certificates, connections, and encrypted variables. These assets are encrypted and stored in Azure Automation using a unique key that is generated for each Automation account. [Azure Automation stores the key in the system-managed Key Vault](https://docs.microsoft.com/en-us/azure/automation/shared-resources/credentials?tabs=azure-powershell). Before storing a secure asset, Automation loads the key from Key Vault and then uses it to encrypt the asset.

SAP system start / stop / monitoring and SAP Application server Start / stop is implemented using scripts (calling SAP sapcontrol executable) via the Azure VM agent. 

SAP HANA start / stop / monitoring is implemented using scripts (calling SAP sapcontrol executable) via the Azure VM agent. 

SQL Server start / stop / monitoring is implemented using scripts (calling SAP Host Agent executable) via the Azure VM agent. 

Every Azure runbook can be executed either manually or it can be scheduled. 


# Cost Optimization Potential 

## Cost Savings on Compute for non-Productive SAP Systems

The non-prod SAP systems, like dev test, demo, training etc., typically do not run 24/7. Let assume you would run them 8 hours per day during the Monday to Friday. This means you run and pay for each VM 8 hours x 5 days = 40 hours. The rest of the time of 128 hours in a week you do not  pay, which makes approximal **76 % of savings on compute**! 

## Cost Savings on Compute for Productive SAP Systems 

Productive SAP system run typical 24 / 7 and you never completely shut them down.  Still, there is a huge potential in saving on SAP application layer. SAP application layers takes a biggest amount of SAPS portion in total SAP system SAPS. 


> [!NOTE]
> **SAP Application Performance Standard** (**SAPS**) is a hardware-independent unit of measurement that describes the performance of a system configuration in the SAP environment. It is derived from the Sales and Distribution (SD) benchmark, where 100 SAPS is defined as 2,000 fully business processed order line items per hour. **SAPS is an SAP measure of compute process power**. 

In an on-premises environment, SAP system is oversized so that it can stand the required peaks. But the reality is, those peaks are rear (maybe few days in 3 month). Most of the time such systems are underutilized. We’ve seen prod SAp systems that have 5 – 10 % of total CPU utilization most of the time. 

In cloud we have possibility to run only what we need, and pay for what we used – hence, **SAP application servers’ layer is a perfect candidate to bring down the costs of SAP productive systems**! 

Here, this solution offers ready jobs to start / stop an SAP application server and VMs. And it is doing in a soft shut down graceful manner, giving SAP users and process enough time to finish it. 

## Cost Savings on Storage 

If you would use Premium and Standard storage, there is possibility to convert such managed storage to premium and back to standard. 

Let’s say you need to use Premium storage (especially for DBMS layer) to get a good SAP performance during the runtime. But once the SAP system (and VMs) is stopped, if you choose to convert the disks from Premium to Standard disks, you will pay much less on the storage during stop time. 

During the start procedure, you can decide to convert the disks back to premium, have good performance of SAP systems during the runtime, and pay a higher storage Premium price only during the runtime. 
In example where SAP system would run 8 hours x 5 days = 40 hours, and SAP system is stopped for 128 hours in a week, during this stopped time of 128 / week, you will pay not the price of Premium storage but reduced priced of Standard. 
For example, price of 1 TB P30 disk approximately 2 times higher than 1 TB S30 Standard HDD disk. For above mentioned scenario, savings on 1 TB managed disk would be approximately **54 %**! 
For the exact pricing for managed disks, check [here](https://azure.microsoft.com/en-us/pricing/details/managed-disks/). 

## Cost of Azure Automation Account PaaS Service

Cost if using Azure automaton service is extremely low.   Billing for jobs is based on the number of job run time minutes used in the month and for watchers is based on the number of hours used in a month. Charges for process automation are incurred whenever a job or watcher runs. You will be billed only for minutes/hours that exceed the free included units (**500 min for free**). If you exceed monthly free limit of 500 min, you will pay **per minute €0.002/minute**.

Let’s say one SAP system start or stop takes on average 15 minutes. And let’s assume you scheduled your SAP system to start every morning from Monday to Friday and stop in the evening as well. That will be 10 executions per week, and 40 per month for one SAP system. 
This means that in 500 free minutes you can execute 33 start or stop procedures for free. 

Everything extra you need to pay. For one start or stop (of 15 min), you would pay 15 min * €0.002 = €0.03. And for **40 start / stop** of ONE SAP system you would pay **€ 1.2 per month**! 

For updated and exact information on cost, you can check [here](https://azure.microsoft.com/en-us/pricing/details/automation/).

## Solution Cost of Azure Automation Account Management 

Often, when you use some solution which offer you some functionality, you need to manage it as well, learn it etc. All this generate additional costs, which can be quite high.  

As Azure automation account is an PaaS service, you have here **ZERO management costs**! 

Plus, it is easy to set it up and use it. 



# Implementation

## Create Azure Automation Account

[How to create an Azure Automation account](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account).


![image](https://user-images.githubusercontent.com/26795040/115053994-56eb8480-9ea5-11eb-9d1d-c344e4d7546e.png)


## Import Az.Modules

SAP start / stop PowerShell (PS) runbooks use new Az PS module, which must be [imported](https://docs.microsoft.com/en-us/azure/automation/az-modules#import-the-az-modules) .

Import Az modules:

  - **Az.Account**

  - **Az.Compute**

  - **Az.Automation**

  - **Az.Resources**

## Az.Account

Go to ***Module*** -\> ***Browse Gallery***

Search for **Az.Account** module.

![image](https://user-images.githubusercontent.com/26795040/115054115-7aaeca80-9ea5-11eb-97bb-26be3bdff2a1.png)

Select **Az.Account** module and click **Import:**

![image](https://user-images.githubusercontent.com/26795040/115054130-7edae800-9ea5-11eb-9a20-a99bb23845c1.png)

Import is in progress..

![image](https://user-images.githubusercontent.com/26795040/115054144-826e6f00-9ea5-11eb-8b3d-b2fbeae17167.png)

Import is finished:

![image](https://user-images.githubusercontent.com/26795040/115054161-87cbb980-9ea5-11eb-8f16-612d5531bcac.png)

## Import Az.Compute

Simlar to Az.Account

## Import Az.Automation

Simlar to Az.Account


## Az.Resources

Simlar to Az.Account

ALL new modules are imported.

![image](https://user-images.githubusercontent.com/26795040/115054276-ad58c300-9ea5-11eb-9c80-fd82b0f5d38c.png)

## Import SAP PowerShell Module

Import **SAPAzurePowerShellModules** PowerShell module that will be used by SAP Runbooks.

> [!NOTE]
> PowerShell module **SAPAzurePowerShellModules** is stored in PowerShell Gallery and is easy to import into Azure automation account.

Go to ***Module*** -\> ***Browse Gallery***

Search for ***SAPAzurePowerShellModules*** module.

![image](https://user-images.githubusercontent.com/26795040/115054308-b6e22b00-9ea5-11eb-949a-e3be9455e79e.png)

Select ***SAPAzurePowerShellModules*** module and click **Import** and **OK:**

![image](https://user-images.githubusercontent.com/26795040/115054328-bcd80c00-9ea5-11eb-8724-12ed1488c32d.png)

![image](https://user-images.githubusercontent.com/26795040/115054399-ca8d9180-9ea5-11eb-9a7a-941d6b7f187b.png)

Import is in progress…

![image](https://user-images.githubusercontent.com/26795040/115054431-cfeadc00-9ea5-11eb-89d0-86b2529e7d23.png)

Import is finished.

![image](https://user-images.githubusercontent.com/26795040/115054452-d5e0bd00-9ea5-11eb-9eb7-6fd769fc96cc.png)

# Import SAP Runbook

Navigate to **Runbook** and click **Import a runbook**.

Import these runbooks:

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

  - Tag-SAPSystemDVEBMGSInstanceLinux

  - Tag-SAPSystemSCSInstanceLinux

  - Tag-SAPSystemJavaApplicationServerInstanceLinux

  - Tag-SAPSystemStandaloneHANA

> [!NOTE] 
> All SAP runbooks are stored in PowerShell Gallery and are easy to import into Azure automation account. There are Runbooks for different scenarios, you may not need all of those for your use-case

Go to **Runbooks** **Gallery**

For **Source** choose: **PowerShell Gallery**

![image](https://user-images.githubusercontent.com/26795040/115054602-07598880-9ea6-11eb-8db6-0ff1dd9ec5b8.png)

In the search field type: **Start-SAPSystem** and press Enter.

![image](https://user-images.githubusercontent.com/26795040/115054619-0aed0f80-9ea6-11eb-9d69-f40255c578ea.png)

Click on **Start-SAPSystem** Runbook and click on **Import**.

![image](https://user-images.githubusercontent.com/26795040/115054623-0e809680-9ea6-11eb-86e6-2f402057aab5.png)

Click **OK**.

![image](https://user-images.githubusercontent.com/26795040/115054638-12acb400-9ea6-11eb-9be7-e5ff8d33aecb.png)

Import succeeded:

![image](https://user-images.githubusercontent.com/26795040/115054659-193b2b80-9ea6-11eb-9aab-24b22e850a8f.png)

Go to **Runbooks** and click on **Start-SAPSystem** runbook.

![image](https://user-images.githubusercontent.com/26795040/115054679-20fad000-9ea6-11eb-852b-6847b7241a8d.png)

Click on **Edit**.

![image](https://user-images.githubusercontent.com/26795040/115054694-2526ed80-9ea6-11eb-834b-ae4f60efd404.png)

Click **Publish** **and confirm** .

![image](https://user-images.githubusercontent.com/26795040/115054713-2a843800-9ea6-11eb-85c0-c73d4a11b1bb.png)

And confirm it.

![image](https://user-images.githubusercontent.com/26795040/115054742-3243dc80-9ea6-11eb-8e2f-f7afda82bda7.png)

Now **Start-SAPSystem** runbook is now published and ready to be used.

Import in the same way for all other runbooks.

All runbooks are imported.

![image](https://user-images.githubusercontent.com/26795040/115054761-366ffa00-9ea6-11eb-8e11-53d9722d5974.png)

# Tagging Approach

In your SAP  landscape you have:

* ONE (HA for SAP central services is currently not implemented)
  * SAP ABAP ASCS instance
  * Or SAP ABAP DVEBMGS instances
  * or SAP Java SCS instances

*	ONE DBMS instance (HA for DBMS is currently not implemented)

* One or more SAP application servers 

, which are distributed on one or more Azure VMs.

General approach to tag VMs is following:

* Always tag VM with:
  * SAP ABAP ASCS instance
  * Or SAP ABAP DVEBMGS instances
  * or SAP Java SCS instances

* Always tag VM with DBMS instance

* Tag SAP application sever VM (ABAP or Java) 

* If you have two or more SAP instances (like ASCS and SAP application server) on one VM
  * You tag only ONE SAP instance 
  * Priority has SAP ASCS / SCS / DVEBMS instance

* On SAP central system with 1 VM , you tag:
  * SAP ASCS/SCS/DVEBMS instance
  * DBMS instance



# Configuration for thic challenge

## Distributed SAP ABAP System with HANA – ALL Linux

Here is an example of a distributed SAP ABAP System **TS1** with HANA
DB. ALL VMs are Linux VMs. SAP HANA SID **TS2** is different than SAP
SID **TS1**.

![image](https://user-images.githubusercontent.com/26795040/115054859-5b646d00-9ea6-11eb-8a2d-071a1f91f89b.png)

### HANA DB VM

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

### ASCS VM

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

### SAP Application Server 1 VM

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

### SAP Application Server 2 VM

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

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook: Tag-SAPSystemDialogInstanceLinux

| Parameter               | Mandatory | Value               |
| ----------------------- | --------- | ------------------- |
| ResourceGroupName       | YES       | gor-linux-eastus2-2 |
| VMName                  | YES       | ts2-di1             |
| SAPSID                  | YES       | TS1                 |
| SAPDialogInstanceNumber | YES       | 2                   |


# Runbook Description

Listing SAP System \<SID\> VMs  
To check and list VMs associated to an SAP SID run Runbook:
**List-SAPSystemInstances**

| Parameter | Mandatory | Default value | Comment |
| --------- | --------- | ------------- | ------- |
| SAPSID    | YES       |               |         |

Listing SAP HANA VM  
To check and list VMs associated to an SAP SID run Runbook: **List-**
**SAPHANAInstance**

| Parameter | Mandatory | Default value | Comment |
| --------- | --------- | ------------- | ------- |
| SAPSID    | YES       |               |         |

Start SAP System

To start SAP System run Runbook: **Start-SAPSystem**

| Parameter                 | Mandatory | Default value | Comment                                                |
| ------------------------- | --------- | ------------- | ------------------------------------------------------ |
| SAPSID                    | YES       |               |                                                        |
| WaitForStartTimeInSeconds | No        | 600           | Wait time to start SAP system                          |
| ConvertDisksToPremium     | No        | $False        | If set to $True, all disk will be converted to Premium |
| PrintExecutionCommand     | No        | $False        | If set to $True, all OS commands will be printed       |

Runtime steps are:

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

Stop SAP System

To stop SAP System run Runbook: **Stop-SAPSystem**

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

Start-SAPHANADB

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

Stop-SAPHANADB

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

## 

Stop- SAPApplicationServer

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

Start- SAPApplicationServer

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

# How to start a runbook

Go to **Runbooks**

![image](https://user-images.githubusercontent.com/26795040/115055041-95ce0a00-9ea6-11eb-9286-68e918c4233c.png)

Click on one runbook, for example **Start-SAPSystem**

![image](https://user-images.githubusercontent.com/26795040/115055068-9c5c8180-9ea6-11eb-8b02-395f7cd69e84.png)

And click **Start** , fill the required parameters (**\***), and click
**OK**

![image](https://user-images.githubusercontent.com/26795040/115055088-a2eaf900-9ea6-11eb-9aa8-4ba4c723825d.png)

**INFO**: Parameters with **\*** are **mandatory\!**

Runbook is running.

![image](https://user-images.githubusercontent.com/26795040/115055098-a7afad00-9ea6-11eb-9576-c87940393146.png)

Check the logs in ***All logs*** or ***Output.***

![image](https://user-images.githubusercontent.com/26795040/115055139-b4cc9c00-9ea6-11eb-847e-7c72e086e11b.png)

![image](https://user-images.githubusercontent.com/26795040/115055156-b8f8b980-9ea6-11eb-9823-62cce47624af.png)

# Schedule Start/Stop DEV Systems

Creating schedules make sense for repeating tasks, for example.

  - Start SAP DEV / TEST systems Mon- Fri at 9 am

  - Stop SAP DEV / TEST systems Mon- Fri at 6 pm

### Create / Add Schedule  

Go to ***Schedules*** tab and click ***Add schedule***

![image](https://user-images.githubusercontent.com/26795040/115055166-bd24d700-9ea6-11eb-80da-d97a52a36d87.png)

Configure parameters and click ***Create***  
In example below, it is configured Start Schedule at 9 am , from Monday
till Friday:

![image](https://user-images.githubusercontent.com/26795040/115055176-c31ab800-9ea6-11eb-8a62-4f3267526a21.png)
![image](https://user-images.githubusercontent.com/26795040/115055184-c6ae3f00-9ea6-11eb-98c6-95a0585d7f86.png)

### Link Schedule to a runbook and specify input parameters.

Go to ***Runbooks*** and click on one runbook, choose Schedules tab,
click ***Add a schedule***.

![image](https://user-images.githubusercontent.com/26795040/115055196-cb72f300-9ea6-11eb-9b8a-cae638bdbb21.png)

![](Pictures/media/image67.png)

Click “**Link a schedule to your runbook**”, and choose previously
created schedule “**Start TS1 SAP System**”.

![](Pictures/media/image68.png)

Click on “**Configure parameters and run settings**”

![](Pictures/media/image69.png)

And fill the parameters and click **OK**.

![](Pictures/media/image70.png)

Here is the list of all schedules:

![image](https://user-images.githubusercontent.com/26795040/115055534-299fd600-9ea7-11eb-9cd0-1e66f7ea689a.png)

Repeat the same steps to create Stop schedule, e.g. using
**Stop-SAPSystem** runbook, with schedule for example to stop SAP system
TS1 at 6 pm.

# Schedule Scale Out and Scale In of SAP Application Servers

SAP runbooks:

  - Start-SAPApplicationServer

  - Stop-SAPApplicationServer

can be used to implement SAP application server scale out / scale in
scenario.

Assumption are:

  - SAP administer knows about their expected peaks, when the peak
    starts and when it ends , and they knows out of experience how much
    SAPS e.g. how many SAP application servers will be needed for this
    action.

  - SAP application servers are already installed.

  - Different SAP logon groups are already preconfigured.

A scenario example could be:

  - There is a black Friday peak, which last for 4 days – before peak
    starts, you would schedule start of certain number of SAP
    application servers. You would also schedule by the end of the peak
    to stop these SAP application servers and VMs.

  - Is know that during the working hours you need more SAPS that during
    the night

Stopping can be done with **Soft shutdown** approach, so application
severe will go gradually through the stop process, and users will have
time to log off, SAP batch jobs will have time to finish, until the
specified time out is reached.

# Access consideration for Azure Automation Runbooks and Jobs

Utilizing the SAP start/stop automation you can also limit the rights on
Azure resources such as VMs while at same time do a finer grained
segregation of access to individual Automation runbooks and jobs.

The deployed Azure Automation account inherits role assignments from the
resource group and/or subscription/management group. Utilizing the
principle of least privileges, you might or might not already have
rights to start/stop Automation runbooks and view runbook jobs outputs.

The following is a list of prebuild roles for Automation accounts, as
applicable in the context of this document. Full list of roles for
Automation can be seen here in documentation.

| **Role**                    | **Description**                                                                                                                                                                                                                                                                                                                                                               |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Owner                       | The Owner role allows access to all resources and actions within an Automation account including providing access to other users, groups, and applications to manage the Automation account.                                                                                                                                                                                  |
| Contributor                 | The Contributor role allows you to manage everything except modifying other user’s access permissions to an Automation account.                                                                                                                                                                                                                                               |
| Reader                      | The Reader role allows you to view all the resources in an Automation account but cannot make any changes.                                                                                                                                                                                                                                                                    |
| User Access Administrator   | The User Access Administrator role allows you to manage user access to Azure Automation accounts.                                                                                                                                                                                                                                                                             |
| Automation Operator         | The Automation Operator role allows you to view runbook name and properties and to create and manage jobs for all runbooks in an Automation account. This role is helpful if you want to protect your Automation account resources like credentials assets and runbooks from being viewed or modified but still allow members of your organization to execute these runbooks. |
| Automation Job Operator     | The Automation Job Operator role allows you to create and manage jobs for all runbooks in an Automation account.                                                                                                                                                                                                                                                              |
| Automation Runbook Operator | The Automation Runbook Operator role allows you to view a runbook’s name and properties.                                                                                                                                                                                                                                                                                      |

In other words, to grant access to a group to manage/create and operate
Automation runbooks and jobs, on the entire SAP start/stop automation
account, use the Automation Operator role.

Open the Automation Account in Azure Portal and navigate to Access
control (IAM).  
On tab Role assignments you can see currently assigned groups to this
resource.

![image](https://user-images.githubusercontent.com/26795040/115055568-37edf200-9ea7-11eb-9add-f23976a27d86.png)

Adding Automation (Job/Runbook) Operator

![image](https://user-images.githubusercontent.com/26795040/115055576-3c1a0f80-9ea7-11eb-88ac-cbd088ab7c7e.png)

Add Names or Emails and in the popped open role assignment tab

![image](https://user-images.githubusercontent.com/26795040/115055588-3fad9680-9ea7-11eb-8e9d-2647abb3d123.png)

## Limiting access to individual runbooks/jobs

The above section provides access to the entire Azure Automation
account.  
If however, you want to provide access to individual runbooks or jobs,
this can NOT be accomplished using Azure Portal currently.

As a solution however you can utilize below PowerShell to grant access
to individual sub-resources inside the Automation Account. This is
shorted from the public documentation here.

$rgName = "\<Resource Group Name\>" \# Resource Group name for the
Automation Account  
$automationAccountName ="\<Automation account name\>" \# Name of the
Automation Account  
$rbName = "\<Name of Runbook\>" \# Name of the runbook  
$userId = Get-AzADUser -ObjectId "\<your email\>" \# Azure Active
Directory (AAD) user's ObjectId from the directory

\# Get the Automation account resource ID  
$aa = Get-AzResource -ResourceGroupName $rgName -ResourceType
"Microsoft.Automation/automationAccounts" -ResourceName
$automationAccountName

\# Get the Runbook resource ID  
$rb = Get-AzResource -ResourceGroupName $rgName -ResourceType
"Microsoft.Automation/automationAccounts/runbooks" -ResourceName
"$rbName"

\# The Automation Job Operator role only needs to be run once per user  
New-AzRoleAssignment -ObjectId $userId -RoleDefinitionName "Automation
Job Operator" -Scope $aa.ResourceId

\# Adds the user to the Automation Runbook Operator role to the Runbook
scope  
New-AzRoleAssignment -ObjectId $userId.Id -RoleDefinitionName
"Automation Runbook Operator" -Scope $rb.ResourceId

A user with just individual runbooks granted runbook operator role, will
see only these runbook(s) in the resource group and can start jobs as
otherwise documented earlier.  
Granting access to ONLY the runbooks and jobs shows under ‘all
resources’ in Azure Portal, it will NOT show up in Azure Automation
Accounts because access it granted ONLY to the runbooks and jobs within
themselves.

Below an example of exactly this – only runbooks granted access to a
user and the actual Azure Automation Account

![image](https://user-images.githubusercontent.com/26795040/115055612-476d3b00-9ea7-11eb-9b9b-8589c15decf9.png)


# Frequently Asked Questions

- I tagged the VMs using Runbook but it doesn't show up in Tags, rather just in overview section (see below screenshot)

Tagging screenshot – showing up in Overview but not in Tags; it takes a little bit time to show up in Tags section. It's not a tagging issue rather time to replicate problem. Start and Stop runbooks will still work
 
![tagging-reflection in Tag section](https://user-images.githubusercontent.com/26795040/113929774-0ba2e900-97b6-11eb-8d20-a793d2e02b13.png)

- Is there a way to include email notification and log analytics workspace that the [VM start/stop solution](https://docs.microsoft.com/en-us/azure/automation/automation-solution-vm-management) from Microsoft has?

Currently not in place; the solution can be enhanced to do that 

- Linux systems don’t ask for <SID>adm passwords – how are we maintaining security and access

Start / stop / list instances of SAP is done by running sapcontrol exe via Azure agent. Azure agent on Linux is running under root, and on Linux it can do <sid>adm user switch without password. All method using is Azure agent is secured.
  
- Is there a way to create sequential start/stop for applications such as BW - > SRM -> ECC etc.  

Make the dependencies on other SAP SIDs: such as when you start SAP SID1, make sure to start SAP SID2 before is not implemented yet, but it could be extended. Another way to achieve this currently with time based scheduling

- When DB and application startup is scheduled, does application wait for DB start? Does it check the DB status using R3trans or something?

First is stared DBMS layer , and it waits that DB is stared. Then start SAP. DB start on hana is using sapcontrol exe, and on SQL Server SAP Host Agent.

- Does it stop/start application servers in parallel once DB and ASCS are up/down?

when staring SAP system, it triggers start of whole system. Order is build in inside of SAP start – first DBMS, then ASCS, than ALL app servers in parallel.

- For Linux systems, do we need to install powershell extension or something? How does Linux interpret powershell commands

There is no need to install anything. PowerShell is invoking native linux command via module  using

Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName $VMName  -CommandId RunShellScript  -ScriptPath command.txt

in command.txt is Linux bash command , which is built on the fly.


