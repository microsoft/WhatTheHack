# Challenge 2: Offline migration of database

[< Previous Challenge](./01-discovery.md) - **[Home](../README.md)** - [Next Challenge >](./03-offline-cutover-validation.md)

## Introduction

You will copy the Pizzeria database(s) to Azure. You are not required to reconfigure the application to Azure DB for PostgreSQL/MySQL in this challenge as you will do that in the next one. 

## Description

In the offline migration approach, your application can tolerate some downtime to move to Azure. You can assume that the application is down and no changes are being made to the database. 

## Success Criteria

* Demonstrate to your coach that the "on-premises" Pizzeria application data has migrated successfully to Azure

## Hints

* You can do the import/export from within the containers for PostgreSQL, Oracle and/or MySQL that you created in the prereqs. Alternatively, if the database copy tools are installed on your machine, you can connect to the database from your computer as well. 
* You can install the editor of your choice in the database container(s) (e.g.`apt update` and `apt install vim`) in case you need to make changes to the MySQL dump file
* For MySQL, Oracle and PostgreSQL, you can use Azure Data Factory to copy the data as an alternative approach. 
* You are free to choose other 3rd party tools like MySQLWorkbench, dbeaver, etc. for this challenge
* For Oracle, a container with the tool ora2pg has been deployed into your AKS cluster. You can either use the CLI version of ora2pg or use the web UI. You will need the IP address for the Oracle database container which you can obtain with `kubectl get svc -n oracle`. The port will be 1521 and the SID is XE.

To get to the CLI, you will need to do this: 
```bash
    podName=$(kubectl get pods -n ora2pg --no-headers -o custom-columns=":metadata.name")
    kubectl exec -n ora2pg -it $podName -- /bin/bash
    cd /usr/local/bin
    ora2pg
```

For the web UI, you will need to do this:
```bash
    ora2pgIP=$(kubectl -n ora2pg get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
    ora2pgPort=$(kubectl -n ora2pg get svc -o jsonpath="{.items[0].spec.ports[0].port}")     
    echo "ora2pg is at http://$ora2pgIP:$ora2pgPort/"
 ```

* If you choose to use the ora2pg CLI, you will need to modify the ora2pg.conf file located in /config with your settings for ORACLE_DSN, ORACLE_USER and ORACLE_PWD. The only installed editor in the container is vi. 

* For Oracle, you may want to wait to add constraints (or temporarily disable them) until after you have added the data into the tables

## References
* [Migrate your PostgreSQL database using export and import](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-using-export-and-import)
* [Migrate your MySQL database to Azure Database for MySQL using dump and restore](https://docs.microsoft.com/en-us/azure/mysql/concepts-migrate-dump-restore)
* [Copy using Azure Data Factory for PostgreSQL](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-database-for-postgresql)
* [Copy using Azure Data Factory for MySQL](https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-database-for-mysql)
* [Copy activity in Azure Data Factory and Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/data-factory/copy-activity-overview)
* [Move Oracle and MySQL databases to PostgreSQL](https://ora2pg.darold.net/)
* [Visualate Ora2Pg](https://github.com/visulate/visulate-ora2pg)
* [Data migration Team Whitepapers](https://github.com/microsoft/DataMigrationTeam/tree/master/Whitepapers)
* [Ora2pg documentation](https://ora2pg.darold.net/)


 
