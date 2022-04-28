# Solution 6: Data lineage - Coach Guide

[< Previous Solution](./Solution5.md) - [Home](./README.md) - [Next Solution >](./Solution7.md)


## Introduction

Duration: 45 minutes. 

Pre-requisites: Another windows virtual machine which will serve as SHIR for Purview will be needed as a pre-requisite to this challenge. This can be used to reinforce the fact that SHIR’s are not sharable now. Don’t forget to spin up these VMs in the same virtual network. You may also use the ARM script provided to deploy the VM. This challenge also needs an Azure VM running SQL Server with the WideWorldImporters database restored (see previous challenge).  

Optionally, to avoid running the above scenario, you may choose couple of related tables from AdventureWorksLT database from the Azure SQL DB used in challenge 2.

As detailed in the challenge (refer to the snip), the attendees will need to demonstrate the end-to-end lineage. The first copy in ADF can be setup using a copy activity, the second step will involve a dataflow as some join/unions are required. If the lineages are not shown as in the snip provided, it could be that the data sources for the dataflows are not correctly pointing to the actual files.
