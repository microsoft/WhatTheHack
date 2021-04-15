# Challenge 6: Coach's Guide

[< Previous Challenge](./05-scaling.md) - **[Home](README.md)** - [Next Challenge >](./07-updaterollback.md)

# Notes & Guidance

# Table of Contents

- [Overview of the solution](#Overview-of-the-solution)
- [Solution Capabilities](#Solution-Capabilities)
- [Soft / Graceful Shutdown of SAP System, Application Servers, and DBMS](#Graceful-Shutdown-of-SAP-System-Application-Servers-and-DBMS)
- [Architecture](#Architecture)
- [Cost Optimization Potential](#Cost-Optimization-Potential)
- [Implementation](#Implementation)
- [Import SAP Runbook](#Import-SAP-Runbook)
- [Tagging Approach](#Tagging-Approach)
- [Sample configurations](#Sample-configurations)
- [Runbook Description](#Runbook-Description)
- [How to start a runbook](#How-to-start-a-runbook)
- [Schedule Scale Out and Scale In of SAP Application Servers](#Schedule-Scale-Out-and-Scale-In-of-SAP-Application-Servers)
- [Access consideration for Azure Automation Runbooks and Jobs](#Access-consideration-for-Azure-Automation-Runbooks-and-Jobs)
- [Frequently Asked Questions](#Frequently-Asked-Questions)


    
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
    - One ASCS/SCS or DVEBMGS VM (HA is currently not implemented)
    -	One or more SAP application servers
    -	It is assumed that SAPMNT file share is located on SAP ASCS or DVEBMGS VM.


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

  ![](Pictures/media/image76.png)



# Graceful Shutdown of SAP System, Application Servers, and DBMS 

## SAP System and SAP Application Servers

The stopping of the SAP system or SAP application server will be done using an [SAP soft shutdown or graceful shutdown procedure](https://help.sap.com/saphelp_aii710/helpdata/en/f7/cb8577bc244a25a994fc3f9c16ce66/frameset.htm), within specified timeout. SAP soft shutdown, and is gracefully handling SAP process, users etc. in a specified downtime time, during the stop of whole SAP system or one SAP application server. 

 ![](Pictures/media/image2.png)  

 Users will get a popup to log off, SAP application server(s) will be removed from different logon groups (users, batch RFC etc.), procedure will wait for SAP batch job to be finished (until a specified timeout is reached). This is functionality implemented in the SAP kernel.

![](Pictures/media/image3.png)  

> [!NOTE]
> You can specify in the user interface the SAP soft shutdown time. Default value is 300 sec.  
>![](Pictures/media/image4.png)


## DBMS Shutdown

For SAP HANA and SQL Server, it is also implemented DB soft shutdown, which will gracefully stop these DBMS, so DB will have time to flush consistently all content from memory to storage and stop all DB process. 

## User Interface Possibilities

A user can trigger start / stop in two ways:

- using Azure Automation account portal UI

- or even better is to use a fancy SAP Azure Power App, which can be consumed in a browser,  smart phones or Teams:
  >![](Pictures/media/image77.png)


# Architecture

The solution is using Azure automation account PaaS solution as an automation platform to execute the SAP shutdown/startup jobs.
Runbooks are written in PowerShell. There is also a PowerShell module SAPAzurePowerShellModules that is used by all runbooks. These runbooks and module are stored in PowerShell Gallery, and are easy to import. 

![](Pictures/media/image5.png)

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

First, [create an Azure Automation account](https://docs.microsoft.com/en-us/azure/automation/automation-quickstart-create-account).

**Create Resources** -\> search for **Automation**

![](Pictures/media/image6.png)

![](Pictures/media/image7.png)

Click **Create**.

![](Pictures/media/image8.png)

Specify parameters:

![](Pictures/media/image9.png)

Azure Automation Account is created.

![](Pictures/media/image10.png)

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

![](Pictures/media/image11.png)

Select **Az.Account** module and click **Import:**

![](Pictures/media/image12.png)

Import is in progress..

![](Pictures/media/image13.png)

Import is finished:

![](Pictures/media/image14.png)

## Import Az.Compute

Go to ***Module*** -\> ***Browse Gallery***

Search for **Az.Compute**

![](Pictures/media/image15.png)

Select **Az.Compute** module and click **Import:**

Import in progress…

![](Pictures/media/image16.png)

Import is finished.

![](Pictures/media/image17.png)

## Import Az.Automation

Go to ***Module*** -\> ***Browse Gallery***

Search for **Az.Automation** module.

![](Pictures/media/image18.png)

Select **Az.Automation** module and click **Import:  
**

![](Pictures/media/image19.png)

Import is in progress…

![](Pictures/media/image20.png)

Import is finished.

![](Pictures/media/image21.png)


## Az.Resources

Go to ***Module*** -\> ***Browse Gallery***

Search for **Az.Resources** module.

![](Pictures/media/image22.png)

Select **Az.Resources** module and click **Import:**

![](Pictures/media/image23.png)

Import is in progress…

![](Pictures/media/image24.png)

Import is finished.

![](Pictures/media/image25.png)

ALL new modules are imported.

![A screenshot of a cell phone Description automatically
generated](Pictures/media/image26.png)

## Import SAP PowerShell Module

Import **SAPAzurePowerShellModules** PowerShell module that will be used by SAP Runbooks.

> [!NOTE]
> PowerShell module **SAPAzurePowerShellModules** is stored in PowerShell Gallery and is easy to import into Azure automation account.

Go to ***Module*** -\> ***Browse Gallery***

Search for ***SAPAzurePowerShellModules*** module.

![](Pictures/media/image27.png)

Select ***SAPAzurePowerShellModules*** module and click **Import** and **OK:**

![](Pictures/media/image28.png)

![](Pictures/media/image29.png)

Import is in progress…

![](Pictures/media/image30.png)

Import is finished.

![](Pictures/media/image31.png)

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

  - Tag-SAPCentralSystemHANA

  - Tag-SAPCentralSystemSQLServer

  - Tag-SAPSystemASCSInstanceLinux

  - Tag-SAPSystemASCSInstanceWindows

  - Tag-SAPSystemDialogInstanceLinux

  - Tag-SAPSystemDialogInstanceWindows

  - Tag-SAPSystemDVEBMGSInstanceLinux

  - Tag-SAPSystemDVEBMGSInstanceWindows

  - Tag-SAPSystemSCSInstanceLinux

  - Tag-SAPSystemSCSInstanceWindows

  - Tag-SAPSystemJavaApplicationServerInstanceLinux

  - Tag-SAPSystemJavaApplicationServerInstanceWindows

  - Tag-SAPSystemStandaloneHANA

  - Tag-SAPStandaloneSQLServer

  -
> [!NOTE] 
> All SAP runbooks are stored in PowerShell Gallery and are easy to import into Azure automation account.

Go to **Runbooks** **Gallery**

For **Source** choose: **PowerShell Gallery**

![Graphical user interface, text, application Description automatically
generated](Pictures/media/image35.png)

In the search field type: **Start-SAPSystem** and press Enter.

![Graphical user interface, text, application Description automatically
generated](Pictures/media/image36.png)

Click on **Start-SAPSystem** Runbook and click on **Import**.

![Graphical user interface, text, application, email Description
automatically generated](Pictures/media/image37.png)

Click **OK**.

![](Pictures/media/image38.png)

Import succeeded:

![Graphical user interface, text, application, email Description
automatically generated](Pictures/media/image39.png)

Go to **Runbooks** and click on **Start-SAPSystem** runbook.

![Graphical user interface, text, application, email Description
automatically generated](Pictures/media/image40.png)

Click on **Edit**.

![Graphical user interface, application Description automatically
generated](Pictures/media/image41.png)

Click **Publish** **and confirm** .

![Graphical user interface, text, application, email Description
automatically generated](Pictures/media/image42.png)

And confirm it.

![](Pictures/media/image43.png)

Now **Start-SAPSystem** runbook is now published and ready to be used.

Import in the same way for all other runbooks.

All runbooks are imported.

![](Pictures/media/image50.png)

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



# Sample configurations

## Central SAP ABAP System

### Central SAP-ABAP System With HANA

Here is an example of Central SAP ABAP System with HANA DB.

![](Pictures/media/image51.png)

<table>
<thead>
<tr class="header">
<th><strong>Properties</strong></th>
<th><strong>Value</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Azure Resource Group Name</td>
<td>gor-linux-eastus2</td>
</tr>
<tr class="even">
<td>VM Name</td>
<td>ce1-db</td>
</tr>
<tr class="odd">
<td>SAP System SID</td>
<td>SP1</td>
</tr>
<tr class="even">
<td><p>SAP HANA SID *</p>
<p>* in central SAP system HANA SID is always different than SAP System SID</p></td>
<td>CE1</td>
</tr>
<tr class="odd">
<td>SAP ASCS Instance Nr.<br />
[variation is to have an old DVEBMGS]</td>
<td>1</td>
</tr>
<tr class="even">
<td>SAP HANA Instance Nr</td>
<td>0</td>
</tr>
</tbody>
</table>

VM \[ce1-db\] has to be tagged with following Tags:

| Tag                          | Value     |
| ---------------------------- | --------- |
| SAPSystemSID                 | SP1       |
| SAPHANASID                   | CE1       |
| SAPDBMSType                  | HANA      |
| SAPHANAInstanceNumber        | 0         |
| SAPApplicationInstanceType   | SAP\_ASCS |
| SAPApplicationInstanceNumber | 1         |

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook: **Tag-SAPCentralSystemHANA**

| Parameter                    | Mandatory | Comment                                                        |
| ---------------------------- | --------- | -------------------------------------------------------------- |
| ResourceGroupName            | YES       |                                                                |
| VMName                       | YES       |                                                                |
| SAPSID                       | YES       | SAP System SID                                                 |
| SAPApplicationInstanceNumber | YES       | Any SAP instance number – ASCS / SCS or SAP application server |
| SAPHANASID                   | YES       | SAP HANA SID – on central system it is DIFFERENT than SAPSID   |
| SAPHANAINstanceNumber        | YES       | SAP Instance umber                                             |

**INFO:** If you have two or more SAP application instance on one host
you will **tag only** **ONE** of them.  
Priority has SAP ASCS instance or DVEBMGS instance. 

### Central SAP ABAP System With SQL Server

Here is an example of Central SAP ABAP System with SQL Server.

![](Pictures/media/image52.png)

<table>
<thead>
<tr class="header">
<th><strong>Properties</strong></th>
<th><strong>Value</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Azure Resource Group Name</td>
<td>gor-linux-eastus2</td>
</tr>
<tr class="even">
<td>VM Name</td>
<td>ct1-vm</td>
</tr>
<tr class="odd">
<td>SAP System SID</td>
<td>CT1</td>
</tr>
<tr class="even">
<td>SAP ASCS Instance Nr.<br />
[variation is to have an old DVEBMGS]</td>
<td>1</td>
</tr>
</tbody>
</table>

VM \[ct1-vm\] has to be tagged with following Tags:

| Tag                          | Value            |
| ---------------------------- | ---------------- |
| SAPSystemSID                 | CT1              |
| SAPApplicationInstanceType   | SAP\_ASCS        |
| SAPApplicationInstanceNumber | 1                |
| PathToSAPControl             | PathToSAPControl |
| SAPDBMSType                  | SQLServer        |
| DBInstanceName               |                  |

**  
  
  
INFO:** SQL Server could be installed either as:

  - **Default** **instance** – in this case DBInstanceName value is an
    empty string.  
    SQL Server would be addressed as **hostname**.

  - **Named instances** - in this case DBInstanceName has some value.  
    SQL Server would be addressed as **hostname\\\<DBInstanceName\>**.

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook:
**Tag-SAPCentralSystemSQLServer**

| Parameter                          | Mandatory | Comment                                                            |
| ---------------------------------- | --------- | ------------------------------------------------------------------ |
| ResourceGroupName                  | YES       |                                                                    |
| VMName                             | YES       |                                                                    |
| SAPSID                             | YES       | SAP System SID                                                     |
| SAPASCSInstanceNumber              | YES       | Any SAP instance number – ASCS / SCS or SAP application server     |
| PathToSAPControl                   | YES       |                                                                    |
| SAPsidadmUserPassword              | YES       |                                                                    |
| DBInstanceName                     | No        | Default value is an empty string (for default SQL Server Instance) |
| AutomationAccountResourceGroupName | YES       |                                                                    |
| AutomationAccountName              | YES       |                                                                    |

**INFO:** If you have two or more SAP application instance on one host
you will **tag only ONE** of them.  
Priority has SAP ASCS instance or DVEBMGS instance.

### Central SAP ABAP System With Oracle, IBM DB2, Sybase, Max DB

In the case of DBMS like: Oracle, IBM DB2 , Sybase or MaxDB, tag the VM:

  - On windows with runbook **Tag-SAPSystemASCSInstanceWindows**

  - On Linux **Tag-SAPSystemASCSInstanceLinux**

  - Add the tag for :
    
      - **Oracle**  
        SAPDBMSType = Oracle
    
      - **IBM DB2**  
        SAPDBMSType = IBMDB2
    
      - **MaxDB**  
        SAPDBMSType = MaxDB
    
      - **Sybase**  
        SAPDBMSType = Sybase

## Distributed SAP ABAP System with HANA – ALL Linux

Here is an example of a distributed SAP ABAP System **TS1** with HANA
DB. ALL VMs are Linux VMs. SAP HANA SID **TS2** is different than SAP
SID **TS1**.

![](Pictures/media/image53.png)

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

## Distributed SAP ABAP System with HANA – Application Layer Windows

Here is an example of a distributed SAP ABAP System **PR2** with HANA
DB.  
Application layer (SAP ASCS and Dialog instances) VMs are Windows VMs.  
SAP HANA SID **PR2** is same as SAP SID **PR1**.

![](Pictures/media/image54.png)

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
<td>pr2-db</td>
</tr>
<tr class="even">
<td>Azure Resource Group Name</td>
<td>gor-linux-eastus2</td>
</tr>
<tr class="odd">
<td>SAP System SID</td>
<td>PR2</td>
</tr>
<tr class="even">
<td><p>SAP HANA SID *</p>
<p>* in central SAP system HANA SID is can be different than SAP System SID</p></td>
<td>PR2</td>
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
| SAPSystemSID          | PR2   |
| SAPHANASID            | PR2   |
| SAPDBMSType           | HANA  |
| SAPHANAINstanceNumber | 0     |

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook: **Tag-SAPSystemStandaloneHANA**

| Parameter             | Mandatory | Value             |
| --------------------- | --------- | ----------------- |
| ResourceGroupName     | YES       | gor-linux-eastus2 |
| VMName                | YES       | pr2-db            |
| SAPSID                | YES       | PR2               |
| SAPHANASID            | YES       | PR2               |
| SAPHANAINstanceNumber | YES       | 0                 |

### ASCS VM \[Windows\]

ASCS has following properties.

| **Properties**            | **Value**           |
| ------------------------- | ------------------- |
| Azure Resource Group Name | gor-linux-eastus2-2 |
| VM Name                   | pr2-ascs            |
| SAP System SID            | PR2                 |
| SAP ASCS Instance Nr      | 0                   |

VM \[ts2-ascs\] has to be tagged with following Tags:

| Tag                          | Value                                          |
| ---------------------------- | ---------------------------------------------- |
| SAPSystemSID                 | PR2                                            |
| SAPApplicationInstanceType   | SAP\_ASCS                                      |
| SAPApplicationInstanceNumber | 0                                              |
| PathToSAPControl             | C:\\usr\\sap\\PR2\\ASCS00\\exe\\sapcontrol.exe |

Create in \<sid\>adm password in **Credential** area of Azure automation
account.

Click **Add credentials**, ***Name*** = prdadm, ***User name*** = pr2adm
, ***Password*** = \<password\>

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook:
**Tag-SAPSystemASCSInstanceWindows  
**Tags runbook will store \<sid\>adm password in secure area as well.

| Parameter                          | Mandatory | Value                                          |
| ---------------------------------- | --------- | ---------------------------------------------- |
| ResourceGroupName                  | YES       | gor-linux-eastus2-2                            |
| VMName                             | YES       | pr2-ascs                                       |
| SAPSID                             | YES       | PR2                                            |
| SAPASCSInstanceNumber              | YES       | 0                                              |
| PathToSAPControl                   | YES       | C:\\usr\\sap\\PR2\\ASCS00\\exe\\sapcontrol.exe |
| SAPsidadmUserPassword              | YES       | Mypr2admpassword                               |
| AutomationAccountResourceGroupName | YES       | gor-startstop-rg                               |
| AutomationAccountName              | YES       | gor-sap-start-stop                             |

### SAP Application Server VM \[Windows\]

SAP application server has following properties.

| **Properties**            | **Value**           |
| ------------------------- | ------------------- |
| Azure Resource Group Name | gor-linux-eastus2-2 |
| VM Name                   | pr2-di0             |
| SAP System SID            | PR1                 |
| SAP Dialog Instance Nr    | 0                   |

VM \[pr2-di0\] has to be tagged with following Tags:

| Tag                          | Value                                       |
| ---------------------------- | ------------------------------------------- |
| SAPSystemSID                 | PR2                                         |
| SAPApplicationInstanceType   | SAP\_D                                      |
| SAPApplicationInstanceNumber | 0                                           |
| PathToSAPControl             | C:\\usr\\sap\\PR2\\D00\\exe\\sapcontrol.exe |

Create in \<sid\>adm password in **Credential** area of Azure automation
account.

Click **Add credentials**, ***Name*** = prdadm, ***User name*** = pr2adm
, ***Password*** = \<password\>

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook:
**Tag-SAPSystemDialogInstanceWindows  
**Tags runbook will store \<sid\>adm password in secure area as well.

| Parameter                          | Mandatory | Value                                       |
| ---------------------------------- | --------- | ------------------------------------------- |
| ResourceGroupName                  | YES       | gor-linux-eastus2-2                         |
| VMName                             | YES       | pr2-di0                                     |
| SAPSID                             | YES       | PR2                                         |
| SAPDialogInstanceNumber            | YES       | 0                                           |
| PathToSAPControl                   | YES       | C:\\usr\\sap\\PR2\\D00\\exe\\sapcontrol.exe |
| SAPsidadmUserPassword              | YES       | \<MyPR2ADMPassword\>                        |
| AutomationAccountResourceGroupName | YES       | gor-startstop-rg                            |
| AutomationAccountName              | YES       | gor-sap-start-stop                          |

## DVEBMGS Instance on Linux

If you would have an old so-called central instance e.g. DVEBMGS
instance on Linux, then VM has to be tagged with following Tags:

| **Tag**                      | **Value**    |
| ---------------------------- | ------------ |
| SAPSystemSID                 | TS1          |
| SAPApplicationInstanceType   | SAP\_DVEBMGS |
| SAPApplicationInstanceNumber | 0            |

You can create these Tags manually.

To simplify and automate Tagging process run this Azure runbook:
**Tag-** **SAPSystemDVEBMGSInstanceLinux**.

**  
**

## DVEBMGS Instance on Windows

If you would have an old so-called central instance e.g. DVEBMGS
instance on Windows, then VM must be tagged with following Tags:

| Tag                          | Value                                              |
| ---------------------------- | -------------------------------------------------- |
| SAPSystemSID                 | PR2                                                |
| SAPApplicationInstanceType   | SAP\_DVEBMGS                                       |
| SAPApplicationInstanceNumber | 0                                                  |
| PathToSAPControl             | C:\\usr\\sap\\PR2\\ DVEBMGS00\\exe\\sapcontrol.exe |

Create in \<sid\>adm password in **Credential** area of Azure automation
account.

Click **Add credentials**, ***Name*** = pr2adm, ***User name*** = pr2adm
, ***Password*** = \<password\>

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook: **Tag-**
**SAPSystemDVEBMGSInstanceWindows**.

| Parameter                          | Mandatory | Value                                             |
| ---------------------------------- | --------- | ------------------------------------------------- |
| ResourceGroupName                  | YES       | gor-linux-eastus2-2                               |
| VMName                             | YES       | pr2-ascs                                          |
| SAPSID                             | YES       | PR2                                               |
| SAPDVEBMGSInstanceNumber           | YES       | 0                                                 |
| PathToSAPControl                   | YES       | C:\\usr\\sap\\PR2\\DVEBMGS00\\exe\\sapcontrol.exe |
| SAPsidadmUserPassword              | YES       | \<MyPR2ADMPassword\>                              |
| AutomationAccountResourceGroupName | YES       | gor-startstop-rg                                  |
| AutomationAccountName              | YES       | gor-sap-start-stop                                |

## Two or more SAP Instances on ONE VM

If you have two or more SAP application instances (ASCS, DVEBMS, Dialog)
on ONE VM:

  - Tag only ONE SAP instance

  - Tag always ASCS or DVEBMGS instance if existing

![](Pictures/media/image55.png)

## Standalone SAP HANA 

You have just standalone SAP HANA DB on one VM, without an SAP system.

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
<td>pr2-db</td>
</tr>
<tr class="even">
<td>Azure Resource Group Name</td>
<td>gor-linux-eastus2</td>
</tr>
<tr class="odd">
<td><p>SAP HANA SID *</p>
<p>* in central SAP system HANA SID is can be different than SAP System SID</p></td>
<td>PR2</td>
</tr>
<tr class="even">
<td>SAP HANA Instance Nr</td>
<td>0</td>
</tr>
</tbody>
</table>

VM \[ts2-db\] must be tagged with following Tags:

| Tag                   | Value |
| --------------------- | ----- |
| SAPHANASID            | PR2   |
| SAPDBMSType           | HANA  |
| SAPHANAINstanceNumber | 0     |

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook: **Tag-SAPStandaloneHANA**

| Parameter             | Mandatory | Value             |
| --------------------- | --------- | ----------------- |
| ResourceGroupName     | YES       | gor-linux-eastus2 |
| VMName                | YES       | pr2-db            |
| SAPSID                | YES       | PR2               |
| SAPHANASID            | YES       | PR2               |
| SAPHANAINstanceNumber | YES       | 0                 |

## Distributed SAP ABAP System with SQL Server

![](Pictures/media/image56.png) 

### SQL Server DB VM 

### 

### DB has following properties.

| **Properties**            | **Value**         |
| ------------------------- | ----------------- |
| VM Name                   | st1-db            |
| Azure Resource Group Name | gor-linux-eastus2 |
| SAP System SID            | ST1               |
| SQL Server Instance       | ST1               |

VM \[st1-db\] has to be tagged with following Tags:

| Tag                                   | Value     |
| ------------------------------------- | --------- |
| SAPSystemSID                          | ST1       |
| SAPDBMSType                           | SQLServer |
| DBInstanceName (it is named instance) | ST1       |

You can create these Tags manually. However, to simplify and automate
Tagging process run this Azure runbook: **Tag-SAPStandaloneSQLServer**

| Parameter         | Mandatory | Value             |
| ----------------- | --------- | ----------------- |
| ResourceGroupName | YES       | gor-linux-eastus2 |
| VMName            | YES       | st1-db            |
| SAPSID            | YES       | ST1               |
| DBInstanceName    | YES       | ST1               |

### ASCS VM \[Windows\]  

Check above chapter how to tag ASCS VM on Windows .

### Application Server VM \[Windows\]

Check above chapter how to tag application server VM on Windows.

## Distributed SAP ABAP System with Other DBMS

For distributed systems with Oracle , IBM DB2, Sybase, MAxDB:

  - On DBMS VM create these tags
    
      - **Oracle**  
        SAPDBMSType = Oracle
    
      - **IBM DB2**  
        SAPDBMSType = IBMDB2
    
      - **MaxDB**  
        SAPDBMSType = MaxDB
    
      - **Sybase**  
        SAPDBMSType = Sybase

Tag ASCS instance VM using runbooks:

  - Tag-SAPSystemASCSInstanceLinux - on Linux

  - Tag-SAPSystemASCSInstanceWindows – on Windows

Tah SAP Application server VMs using runbooks:

  - Tag-SAPSystemDialogInstanceLinux - on Linux

<!-- end list -->

  - Tag-SAPSystemDialogInstanceWindows – on Windows

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

![](Pictures/media/image57.png)

Click on one runbook, for example **Start-SAPSystem**

![](Pictures/media/image58.png)

And click **Start** , fill the required parameters (**\***), and click
**OK**

![](Pictures/media/image59.png)

**INFO**: Parameters with **\*** are **mandatory\!**

Runbook is running.

![](Pictures/media/image60.png)

Check the logs in ***All logs*** or ***Output.***

![](Pictures/media/image61.png)

![](Pictures/media/image62.png)

# Schedule Start/Stop DEV Systems

Creating schedules make sense for repeating tasks, for example.

  - Start SAP DEV / TEST systems Mon- Fri at 9 am

  - Stop SAP DEV / TEST systems Mon- Fri at 6 pm

### Create / Add Schedule  

Go to ***Schedules*** tab and click ***Add schedule***

![](Pictures/media/image63.png)

Configure parameters and click ***Create***  
In example below, it is configured Start Schedule at 9 am , from Monday
till Friday:

![](Pictures/media/image64.png)

![](Pictures/media/image65.png)

### Link Schedule to a runbook and specify input parameters.

Go to ***Runbooks*** and click on one runbook, choose Schedules tab,
click ***Add a schedule***.

![](Pictures/media/image66.png)

![](Pictures/media/image67.png)

Click “**Link a schedule to your runbook**”, and choose previously
created schedule “**Start TS1 SAP System**”.

![](Pictures/media/image68.png)

Click on “**Configure parameters and run settings**”

![](Pictures/media/image69.png)

And fill the parameters and click **OK**.

![](Pictures/media/image70.png)

Here is the list of all schedules:

![](Pictures/media/image71.png)

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

![](Pictures/media/image72.png)

Adding Automation (Job/Runbook) Operator

![](Pictures/media/image73.png)

Add Names or Emails and in the popped open role assignment tab

![](Pictures/media/image74.png)

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

![](Pictures/media/image75.png)


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


