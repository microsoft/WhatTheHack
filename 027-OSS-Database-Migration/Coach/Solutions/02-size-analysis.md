[< Previous Challenge](./01-assessment.md) - **[Home](../README.md)** - [Next Challenge >](./04-offline-cutover-validation.md)

* Create a database in your on-premises database called samples
``` shell
    create database samples ;
    \c samples
```
* Create benchmark objects in the database - run this on the bash prompt on the database host
``` shell
    pgbench -i  -h localhost -U postgres -d samples 
```
* Run a synthetic workload for 5 minutes and watch the system load while it is running. 
``` shell
    pgbench -c 500 -j 40 -T 300 -h localhost -U postgres -d samples
```
* To run the synthetic benchmark for MySQL:
    Connect to the on-premises MySQL database container and use mysqlslap tool
``` shell
    mysqlslap -u root -p --concurrency=70 --iterations=30 --number-int-cols=10 --number-char-cols=20 --auto-generate-sql
```
