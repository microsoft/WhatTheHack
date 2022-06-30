# Challenge 3: Scan an on-premise SQL Server - Coach Guide 

[< Previous Solution](./Solution2.md) - [Home](./README.md) - [Next Solution >](./Solution4.md)


## Introduction

Duration: 30 – 45 minutes. 

Pre-requisites: This challenge needs an Azure VM running SQL Server. 

Optionally use the PS script provided to deploy the SQL Server VM. 

If any attendee does not have an understanding of SHIR, you may want to spend some time explaining the concept. It is ok to use the same SQL Server machine as SHIR too. 

If VMs are going to be manually deployed then look for the following images in the Azure portal:
Image for VM: SQL Server 2019 on Windows Server 2019 
Free SQL Server License: SQL 2019 Developer on Windows Server 2019 - Gen 2 

Restore the following backup on the SQL Server [WideWorldImporters](https://stpurviewfasthack.blob.core.windows.net/purviewfasthack/SQLServerbackup/WideWorldImporters-Full.bak)

Like the previous challenge, after reviewing the results of the scan, you may want to discuss how the SHIR works to process the data and only send metadata to Purview and no actual data


