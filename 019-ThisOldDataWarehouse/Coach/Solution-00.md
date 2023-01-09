# Challenge 00 - Setup - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

### Deploy Source Databases

WWI runs their existing database platforms on-premise with SQL Server 2019. There are two databases samples for WWI. The first one is for their Line of Business application (OLTP) and the second is for their data warehouse (OLAP). You will need to setup both environments as our starting point in the migration.

For this challenge, you will deploy the WWI databases and an initial set of Azure resources needed to complete the hack's challenges using a provided deployment script and ARM Template. We STRONGLY recommend you complete this challenge using the Azure Cloud Shell.

You will find the provided deployment script (hacksetup.sh), ARM Template (deployHack.json), and parameters file (deployHackParameters.json) in the /Challenge0/ folder of the Resources.zip file provided to your by your coach.

###  Azure Resources

The 'hacksetup.sh' file will setup an;
- Azure Container Instance as described above
- Azure Data Factory with SSIS Integration runtime
- Azure SQL Database.  
 
The SSIS catalog will be deployed to the Azure SQL Database (SSISDB) as it provisions the SSIS Inetgration runtime.  After the script runs successfully you should see the SSISDB database in the Azure SQL DB catalog.  It is important to execute the SSIS runtime prior to starting to confirm successful setup.  The deployment scripts complete in approxmiately 5 minutes and starting the service takes less than 5 minutes.  We advise coaches to have students run this at the beginning of the hack during the kickoff presentation or prior to starting the hack.  This will ensure sufficient time to complete the WTH and get everyone started successfully.

### Break/Fix

A common reason for the SSIS Runtime startup failure is restarting the scripts without proper cleanup.  If the script already provisioned the SSISDB Catalog this might cause the configuration in the SSIS Runtime environment to be incorrect.  You are able to edit the configuration in Azure Data Factory for the SSIS DB catalog to fix any startup issues.

## On-premise Data Warehouse Architecture at startup of WhatTheHack.

![Here are the service deployed to kickoff the WTH](../Coach/images/current.png)
