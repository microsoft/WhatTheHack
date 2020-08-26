# Challenge 1 - Setup

## Prerequisites

1. Your laptop: Windows (VM or Parallels is fine, sorry MacOS or Linux users, Power BI Desktop only runs on Windows).
1. Your Azure Subscription


## Introduction 

### Set up your development environment.

The first challenge is to setup an environment that will help you build the end to end solution.  The primary exercise here is ensuring the necessary database, storage, and Power BI capacity exist for subsequent labs.  This datbase can be restored either manually via the Azure Portal or via the Azure CLI.  Download the [source files used for this hack](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/chmitch/WhatTheHack/tree/master/018-BI2AI/Coach/Downloads).

Download these files and load them to a storage container in your Azure subscription to get started.

## Success Criteria
1. An Azure SQL Server with the the AdventurWorksDW database.
1. A Power BI Application workspace with Power BI Embedded capacity assigned.

## Hints

1. If you're having trouble accessing your database, try checking the firewall configuration.
1. If you're using the portal to restore the database the bacpac must be in a storage account in the same azure subscription.
1. If you're using the portal to restore the database you don't need to create the database first only the server.
1. If you're using the cli to restore the database you must create an empty databse before you do the restore.

## Success criteria

1.  A restored version of the Adventure Works Data Warehouse
1.  A Power BI application workspace with assigned premium capacity(Note:  This is the most expensive resource we use in this event.  It's a good idea to pause the capacity when you're not using it.)

## Learning resources

|                                            |                                                                                                                                                       |
| ------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------: |
| **Description**                            |                                                                       **Links**                                                                       |
| az sql db create  | <https://docs.microsoft.com/en-us/cli/azure/sql/db?view=azure-cli-latest#az-sql-db-create> |
| az sql db import   | <https://docs.microsoft.com/en-us/cli/azure/sql/db?view=azure-cli-latest#az-sql-db-import> |
| az sql server create  | <https://docs.microsoft.com/en-us/cli/azure/sql/server?view=azure-cli-latest#az-sql-server-create> |
| az sql server firewall-rule create  | <https://docs.microsoft.com/en-us/cli/azure/sql/server/firewall-rule?view=azure-cli-latest#az-sql-server-firewall-rule-create> |
| Create the new workspace in Power BI | <https://docs.microsoft.com/en-us/power-bi/service-create-the-new-workspaces> |
| Create Power BI Embedded Capacity in the Azrue Portal | <https://docs.microsoft.com/en-us/power-bi/developer/azure-pbie-create-capacity> |
| Configure and manage capacities | <https://docs.microsoft.com/en-us/power-bi/service-admin-premium-manage> |

[Next challenge (Working with Data in Power BI) >](./02-Dataflows.md)