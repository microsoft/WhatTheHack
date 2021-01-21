# Challenge 2: Size analysis

[< Previous Challenge](./01-assessment.md) - **[Home](../README.md)** - [Next Challenge >](./03-offline-migration.md)

## Introduction

Determine the CPU/memory configuration, database I/O and file size and map to an equivalent size in Azure

## Description

In this challenge you'll determine the CPU/memory configuration, database I/O and database file size required and map it to an equivalent size in Azure. You will run a synthetic benchmark to simulate I/O for the database. 

To run the synthetic benchmark for Postgres:

* Create a database in your on-prem database called samples

* Create benchmark objects in the database - run this on the bash prompt on the database host

* pgbench -i  -h localhost -U postgres -d samples 

* Run a synthetic workload for 5 minutes and watch the system load while it is running. 

* pgbench -c 500 -j 40 -T 300 -h localhost -U postgres -d samples


## Success Criteria

1. You have discoeverd the CPU/memory configuration for your database server
1. You have determined the peak workload - cpu, memory, disk IO on the server during the synthetic workload test
1. You have discovered the database file size of the application database wth
1. You have selected appropriate database service tier (e.g. Basic, General Purpose or Memory Optimized) and server size to meet the peak workload
1. You can explain to your proctor why you would go with a specific database deployment option (Single Server, Flexible Server or HyperScale (Postgres only))

## References
* Standard Unix monitoring tools: https://sysaix.com/top-20-linux-unix-performance-monitoring-tools
* Choose the right MySQL Server option in Azure: https://docs.microsoft.com/en-us/azure/mysql/select-right-deployment-type
* Pricing tiers in Azure Database for PostgreSQL - Single Server: https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers 
