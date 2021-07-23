# Challenge 2: Size analysis

[< Previous Challenge](./01-assessment.md) - **[Home](../README.md)** - [Next Challenge >](./03-offline-migration.md)

## Introduction

Determine the CPU/memory configuration, database I/O and file size, and map to an equivalent size in Azure

## Description

In this challenge you'll determine the CPU/memory configuration, database I/O and database file size required, and map it to an equivalent size in Azure. Since our pizza website is not being used for real transactions, you will run a synthetic benchmark to simulate I/O for the database. The commands to run the synthetic workload are given below. While the workload is running, you will watch the utilization of the CPU, memory and based on what you observe, determine the size of the Azure database to be created.

To run the synthetic benchmark for PostgreSQL:
* Create a database in your on-premises database called samples
* Run a synthetic workload for 5 minutes and watch the system load while it is running. 

To run the synthetic benchmark for MySQL:
* Run a synthetic workload for 5 minutes and watch the system load while it is running.

## Success Criteria

* You have discovered the CPU/memory configuration for your database server
* You have determined the peak workload - CPU, memory, disk I/O on the server during the synthetic workload test
* You have discovered the database file size of the application database wth
* You have selected the appropriate database service tier (e.g. General Purpose or Memory Optimized) and server size to meet the peak workload
* You can explain to your coach the different database deployment option (Single Server/Flexible Server and HyperScale (PostgreSQL only)). In this hackathon you will use single server only

## Hint

* For both MySQL and PostgreSQL, install htop on the database container. You will need it to watch the system load while the synthetic workload is running against the databases.

```bash

  apt update ; apt install htop
  
```
* Stress test for MySQL

```bash

mysqlslap -u root -p --concurrency=140 --iterations=50 --number-int-cols=10 --number-char-cols=20 --auto-generate-sql

```

* Stress test for PostgreSQL - create benchmark objects in the database and run a synthetic workload for 5 minutes

```bash
    pgbench -i samples
    pgbench -c 500 -j 40 -T 300 samples
```

## References
* [Standard UNIX monitoring tools](https://sysaix.com/top-20-linux-unix-performance-monitoring-tools)
* [Choose the right MySQL Server option in Azure](https://docs.microsoft.com/en-us/azure/mysql/select-right-deployment-type)
* [Pricing tiers in Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers)
* [MySQL load emulation client](https://dev.mysql.com/doc/refman/5.7/en/mysqlslap.html)
* [PostgreSQL benchmark test](https://www.postgresql.org/docs/11/pgbench.html)
