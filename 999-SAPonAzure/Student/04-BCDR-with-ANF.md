# Challenge 4: System protection with backup

[< Previous Challenge](./03-SAP-Security.md) - **[Home](../README.md)** - [Next Challenge >](./05-PowerApps.md)

## Introduction

Mango Inc heavily relies on SAP infrastructure to perform day to day business transactions. Unavailability of IT infrastructure for SAP or SAP application itself can heavily impact business transactions and potentially delay revenue recognition. Mango Inc is concerning about the data consistency on backups and restorability with online backups and necessity of offline backups along with periodicity. CIO heard about Azure netapp files and its features and took a decision to use ANF across the SAP infrastructure for Hana database.  

## Description

SAP S/4 Hana system is fully protected with required IT monitoring, secured & compliance configuration and also with high availabitly for IT component failures. However, it is not protected with accidental errors, unintended data discrepencies, data loss / corruption or geographical catastrophies. Design and implement BCDR solution for SAP S/4 Hana system by implementing secondary copy of SAP system in another seperate azure region from production region with continuous asynchronous data replication.

## Guidelines

1. Backup using a temporary solution (HANA native):
	- For point-in-time recovery, you need to enable log backups.
	- **Take** your first native HANA full file level backup.
	- This backup is a stop-gap solution until the permanent solution is stood up. Also, this will continue to serve as a fallback option.
2. Backup using a permanent solution (ANF snapshots):
	- Assess the backup requirements:
		- Use ANF where possible
		- Cannot afford to lose more than 15 min worth of recent changes
		- Local availability of log backups for up to the last 24 hours
		- Point-in-Time recovery for up to the last 72 hours
		- Additional protection of backup files by offloading to an intra region storage account
	- **Update** the below backup schedule (frequency, retention, offloading, sizing)  ***(See Table in Figure 1 below)***
	- **Adjust** log backup volume size for storing log backups based on the size requirement (refer to the table), and **adjust** relevant HANA parameters to use this volume for log backups. In addition, change the hana log backup timeout value in seconds, "log_backup_timeout_s", to align with the backup requirement - use HANA Studio.
	- **Build** a backup (snapshots) orchestration by installing the tool on the Linux jump server, and by **automating** the snapshot scheduling using the Linux built-in tool - crontab
	- **Orchestrate** offloading of the required snapshots using azcopy in to respective containers in the provided storage account. The azcopy gets installed directly onto the HANA DB VM. Ensure that you log into azcopy without supplying the authentication key or a SAS (use Managed Identity)
	- **Create** a security user "BACKUPTEST".
	- **Take** a backup (using azacsnap). Give a prefix "UseThisBackupTest" and note down the creation time stamp.
	- **Delete** the security user BACKUPTEST "accidently" - Oops!
	- **Restore** the system so that the BACKUPTEST user is restored using the snapshot "UseThisBackupTest". This involves reverting the data volume to an earlier snapshot.

3. Disaster Recovery
	- **Assess** the disaster recovery requirements:
		- RPO < 30 min, RTO < 4 hrs.	
		- Inter-region DR using storage replication capabilities
	- **Set up** ANF storage replication (CRR) to meet the RPO
	- **Create** a security user "DRTEST" on the Production instance in the primary region. (This is to validate the replication.)
	- **Take** a backup (using azacsnap). Give a prefix "UseThisAtDR" and note down the creation time stamp
	- **Execute** the DR by:
		- Wait until the replication is Healthy, Mirrored and Idle
		- Shut down the Production HANA instance (**Stop** VM) at the primary region
		- **Stop** or leave the Production HANA instance down at the DR region down
		- **Break** the replication and **swap** the necessary volume for the Production HANA instance at the DR region. Use snap revert to "UseThisAtDR" snapshot.
		- **Start** HANA recovery (point in time) at the DR region for the Production HANA instance
		- **Validate** the existence of "DRTEST" user.

---

***Figure 1***
Protect: | Size \(customer provided\) | Frequency | Retention | Offloading
-------- | -------- | -------- | -------- | --------
**HANA data** | 1 TiB (20% YoY Growth) | ? | ? | To a separate blob container, retain for 7 days. 
**HANA log backups** | 250 GiB (daily change) | ? | ? | To a separate blob container, retain for 7 days.
**Shared binaries and profiles** | 100 GiB | ? | ? | To a separate blob container, retain for 7 days.

*(Please note that this OpenHack environment is a scaled down version of the above production-like scenario. Also, we will not protect Shared binaries for this challenge.)*


---

## Success Criteria

1. A successful setup of the temporary backup solution.
2. An automatic orchestration of ANF snapshots on the data and log backup volumes to achieve point-in-time recovery.
3. The availability of offloaded snapshots in storage account containers per the requirement. Be able to restore the BACKUPTEST user successfully.
4. Be able to successfully restore the dual-purpose environment with the recent production data (with DRTEST user)


## Resources

1. [Create Data Backups and Delta Backups (SAP HANA Studio) - SAP Help Portal](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.04/en-US/c51a3983bb571014afa0c67026e44ca0.html)
2. [SAP Applications on Microsoft Azure](https://www.netapp.com/pdf.html?item=/media/17152-tr4746pdf.pdf)
3. [Install the Azure Application Consistent Snapshot tool for Azure NetApp Files | Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azacsnap-installation)
4. [MSFT ANF Blogs](https://techcommunity.microsoft.com/t5/forums/searchpage/tab/message?filter=authorId&q=%22maximize%22%20%26%20%22ANF%20investment%22&noSynonym=false&author_id=283165&collapse_discussion=true)
5. [SAP HANA Azure virtual machine storage configurations](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/hana-vm-operations-storage)
6. [Create and Authorize a User - SAP Help Portal](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.00/en-US/c0555f0bbb5710148faabb0a6e35c457.html)
7. [Requirements and considerations for using Azure NetApp Files volume cross-region replication | Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-requirements-considerations)

