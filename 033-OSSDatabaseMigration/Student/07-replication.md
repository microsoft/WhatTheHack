# Challenge 7: Replication

[< Previous Challenge](./06-private-endpoint.md) - **[Home](../README.md)** 


## Introduction
In this challenge you will learn how to create read replicas for Azure DB for PostgreSQL/MySQL Single Server. 

## Description
Read replicas can improve the performance scale of read-intensive workloads. They can also be deployed into a different region than the primary and be promoted to a read/write server in the event of a disaster. Azure DB for PostgreSQL/MySQL Flexible Server does not currently support read replicas. 

## Success Criteria

* You have added a read replica for Azure DB for PostgreSQL/MySQL Single Server
* You are able to run a sample read query connecting to the replica 
* You get an error trying to write to the read replica. 
* You are able to stop the replication and convert the read replica to read-write and test it

## References
* [Create and manage read replicas in Azure Database for PostgreSQL - Single Server from the Azure portal](https://docs.microsoft.com/en-us/azure/postgresql/howto-read-replicas-portal)
* [Read replicas in Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/en-us/azure/postgresql/concepts-read-replicas)
* [How to create and manage read replicas in Azure Database for MySQL using the Azure portal](https://docs.microsoft.com/en-us/azure/mysql/howto-read-replicas-portal)
* [Read replicas in Azure Database for MySQL](https://docs.microsoft.com/en-us/azure/mysql/concepts-read-replicas)

