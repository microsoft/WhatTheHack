# Challenge 4: # Challenge 4: Backup and Disaster Recovery with Azure NetApp Files - Coach's Guide

[< Previous Challenge](./03-k8sintro.md) - **[Home](README.md)** - [Next Challenge >](./05-scaling.md)

## Notes & Guidance

|**Section**|**Sub-Section**|**Comments**|
|-----------|---------------|------------|
|Temp.| All|For the temporary backup solution, you will need to take a full file level backup for both the SYSTEM and the tenant Databases.|
|Backup|Update the Backup Schedule Table|Data: Daily, Twice-Daily retain for 3 days. Log Backups: 10 min retain for 3 days (or as fast as every 5 min). Shared: Same as Data|
|Backup|Adjust Log Backups volume size and HANA volume path change|Change it to 250 GiB from the initial 100 GiB size. This will match with daily log backups requirement. Use HANA Studio to change the log backup basepath parameters - change for both SYSTEM and Tenant DBs. |
|Backup|Log Backup Timeout| Same method for changing as the log backup volume location parameters|
|Backup|Build snapshot solution (azacsnap)|Using azacsnap. Install azacsnap from the repo provided. Install the tool on the management VM/Jump Server Linux, update config JSON, and add to cron tab. You only need one config JSON for this. Put data volumes in the data section, and log backup in "other" section of the config JSON. Refer to the ANF Blogs (no need to use aztools referenced in the blog
Azacsnap for data would run twice a day (pick your time, say 00 and 12th hour). Log backup every 12th min (to cover log backups every 10 min)
|Backup|Offload to blob container|Create a Managed ID for HANA VM and assign Blob Owner, Reader and Contributor permissions for the Blob Storage Account. Install azcopy on the HANA VM. Run once to show how the on-demand azcopy would move both data and log backups over to respective containers. For data volumes, you will mo. Refer to the blog|
|DR|1 2 3|Refer to the links![#f03c15](color here)|

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
10. [Requirements and considerations for using Azure NetApp Files volume cross-region replication - Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-netapp-files/cross-region-replication-requirements-considerations)


