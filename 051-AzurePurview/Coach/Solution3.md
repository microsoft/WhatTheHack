# Solution 3: Scan an on-premise SQL Server 

[< Previous Solution](./Solution2.md) - [Home](./README.md) - [Next Solution >](./Solution4.md)


## Introduction

Duration: 30 – 45 minutes. 

Pre-requisites: This challenge needs an Azure VM running SQL Server. 

Optionally use the ARM script provided to deploy the SQL Server VM. 

If any attendee does not have an understanding of SHIR, you may want to spend some time explaining the concept here. It is ok to use the same SQL Server machine as SHIR too. 

Image for VM: SQL Server 2019 on Windows Server 2019 

Free SQL Server License: SQL 2019 Developer on Windows Server 2019 - Gen 2 

Restore the following backup on the SQ LServer (WideWorldImporters): https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak 


After reviewing the results of the scan similar to the previous challenge, as a closing, you may want to discuss how the SHIR works to process the data and only send metadata to Purview and no actual data 


