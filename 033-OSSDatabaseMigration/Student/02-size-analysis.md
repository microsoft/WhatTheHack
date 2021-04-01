# Challenge 2: Size analysis

[< Previous Challenge](./01-assessment.md) - **[Home](../README.md)** - [Next Challenge >](./03-offline-migration.md)

## Introduction

Determine the CPU/memory configuration, database I/O and file size, and map to an equivalent size in Azure

## Description

In this challenge you'll determine the CPU/memory configuration, database I/O and database file size required, and map it to an equivalent size in Azure. You will run a synthetic benchmark to simulate I/O for the database. In order to watch the system load, you can install tools like htop `(apt update ; apt install htop)`

To run the synthetic benchmark for PostgreSQL:

* Create a database in your on-premises database called samples

* Create benchmark objects in the database 

* Run a synthetic workload for 5 minutes and watch the system load while it is running. 

* Run the synthetic benchmark for MySQL


## Success Criteria

* You have discovered the CPU/memory configuration for your database server
* You have determined the peak workload - CPU, memory, disk I/O on the server during the synthetic workload test
* You have discovered the database file size of the application database wth
* You have selected the appropriate database service tier (e.g. General Purpose or Memory Optimized) and server size to meet the peak workload
* You can explain to your coach why you would go with a specific database deployment option (Single Server, Flexible Server or HyperScale (PostgreSQL only))

## Hint

* For both MySQL and PostgreSQL, install htop. You will need it to watch the system load while the synthetic workload is running against the databases.

```bash

  apt update ; apt install htop
  
```
* Stress test for MySQL

```bash

mysqlslap -u root -p --concurrency=140 --iterations=50 --number-int-cols=10 --number-char-cols=20 --auto-generate-sql

```

* Postgres - create benchmark objects in the database and run a synthetic workload for 5 minutes

```bash
    pgbench -i  -h localhost -U postgres -d samples
    pgbench -c 500 -j 40 -T 300 -h localhost -U postgres -d samples
```

## References
* [Standard UNIX monitoring tools](https://sysaix.com/top-20-linux-unix-performance-monitoring-tools)
* [Choose the right MySQL Server option in Azure](https://docs.microsoft.com/en-us/azure/mysql/select-right-deployment-type)
* [Pricing tiers in Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers)
* [MySQL load emulation client](https://dev.mysql.com/doc/refman/5.7/en/mysqlslap.html)
* [PostgreSQL benchmark test](https://www.postgresql.org/docs/11/pgbench.html)
