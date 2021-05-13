# Challenge 4: Business Continuity and Disaster Recovery with Azure NetApp Files

[< Previous Challenge](./03-SAP-Security.md) - **[Home](../README.md)** - [Next Challenge >](./05-PowerApps.md)

## Introduction

Contoso heavily relies on SAP infrastructure to perform day to day business transactions. Unavailability of IT infrastructure for SAP or SAP application itself can heavily impact business transactions and potentially delay revenue recognition. Contoso is concerning about the data consistency on backups and restorability with online backups and necessity of offline backups along with periodicity. CIO heard about Azure netapp files and its features and took a decision to use ANF across the SAP infrastructure for Hana database.  

SAP S/4 Hana system is fully protected with required IT monitoring, secured & compliance configuration and also with high availabitly for IT component failures. However, it is not protected with accidental errors, unintended data discrepencies, data loss / corruption or geographical catastrophies. Design and implement BCDR solution for SAP S/4 Hana system by implementing secondary copy of SAP system in another seperate azure region from production region with continuous asynchronous data replication.

![Backup and Disaster Recovery - HANA on ANF](Images/Challenge4Arch.PNG)

## Description

1. Backup using a permanent solution (ANF snapshots)
	- The backup team at Contoso has already finished assessing backup requirements and have provided you the below backup schedule _(See Table in Figure 1 below)_.
	- Adjust log backup volume size for storing log backups based on the size requirement (daily change of 250 GiB) from Azure NetApp Files blade in Azure Portal. In addition, also adjust relevant HANA parameters (basepath_catalogbackup, basepath_logbackup) to use this volume for log backups. You may also want to validate that the new log backup location has correct <sid>adm user permissions. Command to change: ```chown -R user:group <new_backup_location>```. 
	- Change/Validate the hana log backup timeout value (log_backup_timeout_s) which is measured in seconds, to align with the backup requirement of 15 min frequency or less - use HANA Studio. 
	- Build a backup (snapshots) solution by installing the azacsnap tool directly on the HANA DB VM (or optionally on the Linux jump server), and by automating the snapshot scheduling using the Linux built-in tool, crontab. Refer to the table to ensure meeting backup retention and frequency requirements for both data and log backups (other). You can ignore taking snapshots for the shared volume for this challenge (optional).
	- Execute an ad-hoc snapshot for the data volume.
	- Offload and sync the `.snapshots` folder under /hana/data/ and the content of the log backups directory, using `azcopy "sync"` option from HANA VM, to respective blob containers in the provided storage account. The azcopy gets installed directly onto the HANA DB VM. Ensure that you log into azcopy without supplying the authentication key or a SAS (use Managed Identity). You may also want to upsize the data volume to provide higher throughout for a quicker offload.
	- Configure retention on blobs to automatically delete any blobs in the containers that are older than 7 days.
	- Now execute a restore test, by first taking an ad-hoc azacsnap snapshot with the prefix ```BeforeResoreTest```
	- Now delete the latest three log backup files under /backup/log/SYSTEM/ and note down the file names.
	- Once these log backups files are deleted, execute the restore to the ANF snapshot taken earlier.
	- Validate the recovery of the three deleted log backup files.

3. Disaster Recovery
	- Assess the disaster recovery requirements:
		- DR region is chosen as US East.
		- RPO < 30 min, RTO < 4 hrs.	
		- Inter-region DR using storage replication capabilities
	- Set up ANF storage replication (CRR) for both data and log backup volumes to meet the RPO. This also requires creating the ANF account and the replicating volumes in the **standard** performance tier storage pool at the DR region.
	- Create a placeholder file ```touch <filename>``` under the data volume (/hana/data/SID/mnt00001/) and note down the timestamp. Optionally, you can also create a security user `DRTEST` in HANA, but note that validation of this file or the security user at the DR site is optional for this challenge
	- Take a backup (using azacsnap) of data and log backups volumes. Give a prefix `UseThisAtDR` and note down the creation time stamp.
	- Execute the DR:
		- By first waiting until the replication is Healthy, Mirrored and Idle.
		- Validate that the ad-hoc snapshot `UseThisAtDR` has been successfully replicated for both the volumes.
		- Consider the production region is now unavailable
		- Break and delete the replication. Use the `UseThisAtDR` snapshot to revert the data and log backup volumes.
		- Change the performance tier of the volumes from standard to premium.
		- Assess and discuss the remaining steps required for business continuity at the DR site.
		

---

***Figure 1***
Protect: | Size \(customer provided\) | Frequency | Retention | Offloading
-------- | -------- | -------- | -------- | --------
**HANA data** | 1 TiB (20% YoY Growth) | Twice daily | 3 days | On demand, to a blob container. Retain for 7 days |
**HANA log backups** | 250 GiB (daily change) | Every 15 min | 2 days | On demand, to a blob container. Retain for 7 days|
**Shared binaries and profiles** | 100 GiB | Twice daily | 3 days | On demand, to a blob container.|

**Note:** This environment is a scaled down version of the above production-like scenario. Also, we will not protect Shared binaries for this challenge.


---

## Success Criteria

- A successful setup of the temporary backup solution.
- An automatic orchestration of ANF snapshots on the data and log backup volumes to achieve point-in-time recovery.
- The availability of offloaded snapshots in storage account containers per the requirement. 
- Be able to restore the lost files using ANF snapshots.
- Be able to successfully set up DR replication using ANF CRR and validate changes are available at the DR site.

## Learning Resources

- [Create Data Backups and Delta Backups (SAP HANA Studio) - SAP Help Portal](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.04/en-US/c51a3983bb571014afa0c67026e44ca0.html)

- [Resize a capacity pool or a volume - Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes#:~:text=%20Resize%20a%20volume%20%201%20From%20the,to%20resize%20or%20delete%20the%20volume.%20More%20)

- [Change the Log Backup Interval - SAP Help Portal](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.04/en-US/6e9eadcd57464e74b9395004cb1aba9a.html)
[SAP Applications on Microsoft Azure - NetApp PDF](https://www.netapp.com/pdf.html?item=/media/17152-tr4746pdf.pdf)

- [Download Azacsnap](https://aka.ms/azacsnapdownload)


- [Install the Azure Application Consistent Snapshot tool for Azure NetApp Files - Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azacsnap-installation)

- [HANA on ANF Blog Series - Microsoft Tech. Community](https://aka.ms/anfhanablog)

- [Authorize access to blobs with AzCopy and Managed ID - Microsoft Docs](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-authorize-azure-active-directory)

- [SAP HANA Azure virtual machine storage configurations - Microsoft Docs](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/hana-vm-operations-storage)

- [Create and Authorize a User - SAP Help Portal](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.00/en-US/c0555f0bbb5710148faabb0a6e35c457.html)

- [Optimize costs by automating Azure Blob Storage access tiers](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-lifecycle-management-concepts?tabs=azure-portal#azure-portal-list-view)

- [Requirements and considerations for using Azure NetApp Files volume cross-region replication - Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-requirements-considerations)

