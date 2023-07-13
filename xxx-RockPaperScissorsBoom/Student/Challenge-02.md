# Challenge 02 - Move to Azure SQL Database

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

So far we have deployed a SQL Server on Linux containers which was really convenient for dev/test scenarios, especially locally. But now with this challenge we would like to leverage Azure SQL Database as a Platform-as-a-Service (PaaS) which offers out-of-the-box features for Production: security patch, SQL Server upgrades, Auto-tuning, Geo-replication, Scaling up or down the size of the server, etc. that we don't want to do by ourself.

![Move to Azure SQL Database](../images/MoveToAzureSql.png)

## Description

- Provision your Azure SQL Database via Infrastructure-as-Code from within Azure Cloud Shell. The approach here is to leverage the Azure CLI (not the Azure portal) by executing a series of bash commands. _Friends don't let friends use UI to provision Azure services, right? ;)_
- Update your app (re-build and re-deploy the Docker image) with the new connection string (as environment variable), test the app as an end-user, and play a game once deployed there.

## Success Criteria

To complete this challenge successfully, you should be able to:

- In Azure Cloud Shell, make sure `az sql server list` and `az sql db list` are showing your Azure services properly.
- In Azure Cloud Shell, do a `docker rm` of your SQL Server on Linux container.
- In your web browser, navigate to the app and play a game, make sure it's working without any error.
- In GitHub, make sure you documented the different commands you have used to update or provision your infrastructure. It could be in a `.md` file or in `.sh` file. You will complete this script as you are moving forward with the further challenges.
  - Be sure you don't commit any secrets/passwords into a public GitHub repo.
- In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Learning Resources

- [Choose between SQL Server (IaaS) or Azure SQL Database (PaaS)](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-paas-vs-sql-server-iaas)
- [Why switch to SQL Server 20- on Linux?](https://info.microsoft.com/top-six-reasons-companies-make-the-move-to-sql-server-2017-register.html)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure)

## Tips

- Add a SQL IP firewall rule to restrict access to just your local IP & Azure
