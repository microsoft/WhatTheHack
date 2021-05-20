# Challenge 1: Migration - Coach's Guide

[< Previous Challenge](./Solution00.md) - **[Home](README.md)** - [Next Challenge>](./Solution02.md)

## Notes & Guidance

This challenge focuses on two main components of any cloud transition: assessment and migration. Assessment involves evaluating the source system for compatibility as well as performance considerations. Compatibility can be largely done via tools: it is effectively 90% tooling and 10% skill/experience. Performance considerations are more difficult, closer to 25% tooling and 75% skill. While tools can capture performance counters and overall statistics, balancing that information while meeting customer requirements is challenging: are SQL elastic pools an option and/or do they offer any benefit? Is a Premium/Business Critical required? What licensing model works best?

Some resources, such as Azure SQL Managed Instance, can take some time deploy -- generally around 3.5 hours. Depending on the skill level of the group and discussions taking place, nudge them to create resources earlier than later to minimize wait time during provisioning.

### AdventureWorks Migration

Migrating the AdventureWorks database is largely intended to be an easy migration to introduce core concepts without too much complexity. Indeed, those with experience in SQL Server migrations to Azure should be able to accomplish this quickly. Teams have the choice of using AdventureWorksLT2017 (the 'light' version) or the full AdventureWorks2017 database. As noted in the challenge, the LT version should be the easiest/smallest, which is encouraged if a team has no experience.

Below are the requirements with coaches notes under each requirement:

1. Must take advantage of PaaS services for easier administration
    * This limits the choice to either Azure SQL Database or Azure SQL Managed Instance.  Azure SQL Database is preferred.
1. Database must be able to scale rapidly and easily for seasonal demand.
    * Azure SQL Database offers the most flexibility here; in general the DTU Standard model will be fine3.
1. Requires database backups to be maintained for 1 year, with weekly granularity.
    * Accomplishing this requires the [configuration of long-term retention policies](https://docs.microsoft.com/en-us/azure/azure-sql/database/long-term-backup-retention-configure) for the database.
1. Database can be migrated offline during one of the nightly maintenance windows.
    * The Database Migration service offers a free and premium tier; the free tier supports offline migrations only and is suitable for this task. This should be easier to accomplish, and also allows the team to resolve any connectivity issues with the "on-premises" databases, wherever they happen to be.
1. If there are any migration blockers/remediation steps, document them with any suggested fixes.
    * The LT database should migrate without issue. The full version should have an issue with uspSearchCandidateResumes, as it contains a FREETEXT predicate as part the full text search, which the underlying table, HumanResources.JobCandidate, won't likely have depending on the tools used to migrate. Data Migration Assistant will indicate an error and while it will stub out uspSearchCandidateResumes, the procedure will be empty. The table HumanResources.JobCandidate will migrate except for the full text index. Part of the challenge will be having the team recreate the index or engineer another solution.

### Wide World Importers Migration

With the AdventureWorks migration done, any frustrating connectivity issues and initial barriers should be eliminated. This part of the challenge should involve quite a bit more work, particularly if the team pursues the advanced challenges. Comments beneath each requirement:

1. Both WWI OLTP and data warehouse databases are to be migrated; they do not need to be on the same server.
    * The team may decide to migrate these to Azure SQL Database, but Azure SQL Managed Instance is an arguably better choice. The purpose of calling out they do not need to be on the same server is to encourage a split architecture to leverage Synapse.
1. Wide World Importers would prefer to take advantage of PaaS services if possible.
    * Azure SQL Database, Azure SQL Managed Instance, and Azure Synapse are the best choices.
1. Database migration for the OLTP database must be done online with minimum downtime.
    1. For the purposes of this challenge, use the WWI Order Insert Solution (Windows Application) to simulate load on the on-premises database during migration/assessment.
    * An online migration requires the premium tier of the Azure Database Migration Service. If running the order insert tool is difficult to do for performance, bandwidth, or other reasons, do the following:
        * With the database idle, perform the initial migration.
        * Once complete, run the tool for a brief period of time OR insert a new record manually.
        * Ensure the changes propagate.
1. Database migration for the data warehouse can be done offline.
1. SSIS package as part of the WWI DW ETL is a *bonus challenge* and not required
    * If the team chooses to migrate the SSIS job, they do not need to refactor it (unless they choose to) -- simply hosting in the cloud is sufficient (the ideal way to host would be via ADF -- [read this document](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-deploy-ssis-packages-azure) for more information on configuring the SSIS runtime in ADF.

### Assessment

The remaining challenge is completing the database assessment. If there are no team preferences for tooling, the team can leverage the Database Migration Assistant to capture/evalute performance counters. As of this writing, it requires Powershell and is not done from within the GUI. Read the [Microsoft Docs](https://docs.microsoft.com/en-us/sql/dma/dma-sku-recommend-sql-db?view=sql-server-ver15) page with more information; as an example, a script to capture the data for 10 minutes might look like:

Run Script:
```powershell
 .\SkuRecommendationDataCollectionScript.ps1 
-ComputerName localhost
-OutputFilePath C:\dma\counters.csv 
-CollectionTimeInSeconds 600 
-DbConnectionString "Server=localhost;Initial Catalog=AdventureWorksLT2017;Integrated Security=SSPI;"
```

And to process those results:

```powershell
Analyze results:
.\DmaCmd.exe /Action=SkuRecommendation /SkuRecommendationInputDataFilePath="c:\dma\counters.csv" /SkuRecommendationTsvOutputResultsFilePath="c:\dma\prices.tsv" /SkuRecommendationJsonOutputResultsFilePath="C:\dma\prices.json” /SkuRecommendationOutputResultsFilePath="C:\dma\prices.html" /SkuRecommendationPreventPriceRefresh=true
```

Those results alone are not sufficient without some "commentary" by the team in evaluating what they see in the data -- for example, clarifying the IO recommendations. 

If the team has a mismatched environment where they need to collect performance counter information from, say, a linux container, they have the following choices:
1. Temporarily configure a Windows VM for capturing the data. The goal is to learn the process.
2. Capture alternative data using DMVs that can support an analysis. Check out [this post from SQL Shack](https://www.sqlshack.com/top-8-new-enhanced-sql-server-2017-dmvs-dmfs-dbas/), [this post from Heroix](https://blog.heroix.com/blog/sql-server-cpu-dmv-queries), and [this one from mssqltips](https://www.mssqltips.com/sqlservertutorial/273/dynamic-management-views/) as examples of DMVs that could be used.

