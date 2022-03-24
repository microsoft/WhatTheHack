# What The Hack - Incremental Synapse Pipelines <br> <i>Utilizing Change Data Capture in Azure SQL</i> 

## Introduction
If you accept the challenge to attend, you and your teammates will work together to help take data from a transactional Azure SQL database and copy it into a Synapse Dedicated Pool to be used as a reporting warehouse.  

But wait there’s more!  As you add data to your transactional database, it needs to automatically make it to the proper tables in the reporting warehouse so we can see the changes in near real time in a report.  

Four words…  <B>Trigger an Incremental Copy</B>.

## Learning Objectives
Upon completion of this Hack, you will be able to setup an Azure environment to incrementally copy data from an Azure SQL Database to a Synapse Dedicated Pool utilizing the Change Data Capture functionality within Azure SQL. 

You will also have utilizized how to implement a watermark table to validate the last copied execution in case of a trigger failure.

From a SQL Dedicated Pool perspective, you will gain hands-on experience with regards to the use of Staging Tables and how to copy those to production tables and use the proper distribution model.


## Challenges
- Challenge 0: **[Setup the Source and Target Environments](Student/Challenge-00.md)**
   - Standup and configure the Azure SQL and Synapse Environments
- Challenge 1: **[Initial Data Load into the Dedicated Pool](Student/Challenge-01.md)**
   - Use Synapse Pipelines to perform the initial data load
- Challenge 2: **[Create Incremental Load Pipelines](Student/Challenge-02.md)**
   - Implement Change Data Capture, create the synapse pipelines and the proper Dedicated Pool architecture to be used as a target for the pipelines and a source for reporting.
- Challenge 3: **[Setup the Trigger to Automate the Incremental Load](Student/Challenge-03.md)**
   - Create the trigger within Synapse to automate the pipeline and add data to SQL and watch it flow through the staging and production tables in the dedicated pool and viewable in your Power BI Report.

## Prerequisites
- One Azure Subscription per group.  One person must be the owner and the others the contributors.
- Tool(s) to interact with Azure SQL and a Synapse Dedicated Pool.  Plenty of options here.
- Power BI Desktop

## Contributors
•	**[Jack Bender](https://www.linkedin.com/in/jack-bender/)**  <BR>
•	**[Chris Fleming](https://www.linkedin.com/in/chris-fleming/)**
