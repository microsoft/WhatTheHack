# Challenge 2: Size analysis

[< Previous Challenge](./01-assessment.md) - **[Home](./README.md)** - [Next Challenge >](./03-offline-migration.md)

## Coach Tips

 Make sure the attendees can explain both the business and technical motivations for choosing a particular service tier. The goal here is to simulate a workload for the
 database, watch the system load and then pick the right service tier in Azure DB for Postgres/MySQL. To monitor system load using tools like htop, you need to upgrade the OS and install the tool first. The following is an example in PostgreSQL:

 * Create a database in your on-premises database called samples, create a pgbench schema and run a synthetic load:
 
```bash

    kubectl -n postgresql exec deploy/postgres -it -- bash
    
    apt update ; apt install htop
    psql -U contosoapp postgres
     
    create database samples ;
    \q
```
* Create benchmark objects in the database - run this on the bash prompt on the database host: 
```bash
    pgbench -i  -h localhost -U postgres -d samples
```
* Run a synthetic workload for 5 minutes and watch the system load from another bash prompt using unix tools while it is running:
```bash
    pgbench -c 500 -j 40 -T 300 -h localhost -U postgres -d samples
```
* To run the synthetic benchmark for MySQL:
    Connect to the on-premises MySQL database container and use mysqlslap tool:
```bash

    kubectl -n mysql exec deploy/mysql -it -- bash
    
    apt update ; apt install htop
    mysqlslap -u root -p --concurrency=140 --iterations=50 --number-int-cols=10 --number-char-cols=20 --auto-generate-sql
```
