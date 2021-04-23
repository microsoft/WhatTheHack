# Challenge 4: # Challenge 4: Business Continuity and Disaster Recovery with Azure NetApp Files - Coach's Guide

[< Previous Challenge](./03-k8sintro.md) - **[Home](README.md)** - [Next Challenge >](./05-scaling.md)

## Notes & Guidance

|**Section**|**Sub-Section**|**Comments** ```***Leverage the Reference Links for more information.***```|
|-----------|---------------|------------|
|Temp.| All|For the temporary backup solution, you will need to take a full file level backup for both the SYSTEM and the tenant Databases. ![HANA Native Backup](Images/Challenge4-t1.png)|
|Backup|Update the Backup Schedule Table|Data: Daily, Twice-Daily retain for 3 days. Log Backups: 15 min retain for 2 days (log backups already contain the last 24 hrs of log backups so 2 days instead of 3. Shared: Same as Data|
|Backup|Adjust Log Backups volume size and HANA volume path change|Change it to 250 GiB from the initial 100 GiB size. This will match with daily log backups requirement. Use HANA Studio to change the log backup basepath parameters - change for both SYSTEM and Tenant DBs. ![Parameters](Images/Challenge4-b1.png) ![Volume Size](Images/Challenge4-b2.png)|
|Backup|Log Backup Timeout| Same method for changing as the log backup volume location parameters. ![LogBackupTimeout](Images/Challenge4-b6.png)|
|Backup|Build snapshot solution (azacsnap)|Using azacsnap. Install azacsnap from the repo provided. Install the tool on the management VM/Jump Server Linux, update config JSON, and add to cron tab. You only need one config JSON for this. Put data volumes in the data section, and log backup in "other" section of the config JSON. Refer to the ANF Blogs (no need to use aztools referenced in the blog. Azacsnap for data would run twice a day (pick your time, say 6am and 6pm). Log backup every 15 min (to cover log backups every 15 min but schedule it a minute past the log backups i.e. 16th, 31st, 46th and 01st min of the hour). [azacsnapshot](Images/Challenge4-b7.png) [azacsnapshot](Images/Challenge4-b8.png)|
|Backup|Execute adhoc snapshot|Since the crontab schedule may not immediately trigger snapshots, we want to take an ad-hoc data volume snapshot so that we can proceed with the next steps of offloading to blob container. Use the azansnap command you wrapped in the crontab and execute it thought the command line|
|Backup|Offload to blob container|Create a Managed ID for HANA VM and assign Blob Owner, Reader and Contributor permissions for the Blob Storage Account. Install azcopy on the HANA VM. Run once to show how the on-demand azcopy would move both data and log backups over to respective containers. For data volumes, you will sync the contents of the .snapshot directory under /hana/data/<SID>/mnt00001/.snapshot, and for the log backups, you will sync the actual log backups files for SYSTEM and tenants by simply syncing the entire /backup/log directory. Refer to the blog for more information. [azcopy](Images/Challenge4-b3.png)|
|Backup|Retention for blobs|Add a lifecyle management policy rule to delete the blobs filtered for the two containers to be deleted if modified older than 7 days. ![Blob Retention](Images/Challenge4-b4.png)|  
|Backup|Restore test|Create the security user using HANA Studio. When reverting volume, use the revert to snapshot option and not the new volumes option - this way, you won't need to swap out the old volumes with the new ones. Start HANA recovery using a specific backup option, and then choose without the backup catalog. Destination Type as Snapshot. Once SYSTEM DB is recovered, start tenant recovery. Finally, validate the the accidentally deleted user is now recovered. ![Restore](Images/Challenge4-b5.png)|  
|DR|Assess Requirements|No action, just laying out requirements. The DR region is East, so that's where the ANF replication will be outbound for. Since, RPO is <30 min, we will use 10 min CRR interval.|
|DR|Set up CRR|Refer to the blog and CRR MS Docs reference link. Set up replication for data and log backups (we will not be needing to use shared volume for this OpenHack). Set the frequency for replication to be 10 min. ![CRR Replication](Images/Challenge4-crr2.png)|
|DR|Create a placeholder file|We will not be validating the availability of this file or the security user as part of the validation. This is just in case the participant decides to do the optional steps of provisioning a VM, installing the HANA DB, and then doing the recovery at the DR site|
|DR|Take an ad-hoc backup| Use azacsnap|
|DR|Execute DR|Without deleting the replication, you will not be able to revert to a snapshot on the existing replicating volumes. When changing performance tiers, create a new storage pool of premium tier first and then move the volume from standard to this new premium storage pool. This will conclude the DR validation from the challenge's perspective|



## Resources

1. [Create Data Backups and Delta Backups (SAP HANA Studio) - SAP Help Portal](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.04/en-US/c51a3983bb571014afa0c67026e44ca0.html)
2. [Resize a capacity pool or a volume - Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes#:~:text=%20Resize%20a%20volume%20%201%20From%20the,to%20resize%20or%20delete%20the%20volume.%20More%20)
3. [Change the Log Backup Interval - SAP Help Portal](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.04/en-US/6e9eadcd57464e74b9395004cb1aba9a.html)
4. [SAP Applications on Microsoft Azure - NetApp PDF](https://www.netapp.com/pdf.html?item=/media/17152-tr4746pdf.pdf)
5. [Install the Azure Application Consistent Snapshot tool for Azure NetApp Files - Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/azacsnap-installation)
6. [HANA on ANF Blog Series - Microsoft Tech. Community](https://aka.ms/anfhanablog)
7. [Authorize access to blobs with AzCopy and Managed ID - Microsoft Docs](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-authorize-azure-active-directory)
8. [SAP HANA Azure virtual machine storage configurations - Microsoft Docs](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/hana-vm-operations-storage)
9. [Create and Authorize a User - SAP Help Portal](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.00/en-US/c0555f0bbb5710148faabb0a6e35c457.html)
10. [Optimize costs by automating Azure Blob Storage access tiers](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-lifecycle-management-concepts?tabs=azure-portal#azure-portal-list-view)
11. [Requirements and considerations for using Azure NetApp Files volume cross-region replication - Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-requirements-considerations)


