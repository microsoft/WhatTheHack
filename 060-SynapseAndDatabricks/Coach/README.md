# What The Hack - Bronze-Silver-Gold Using Synapse and Databricks - Coach Guide

## Introduction

Welcome to the coach's guide for the Bronze-Silver-Gold Using Synapse and Databricks What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an optional [lecture presentation](./Bronze-Silver-Gold.pptx?raw=true) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Understand the basics of Synapse
	 - Understand the basics of Databricks
	 - Understand Delta Lake Concepts
	 - Understand the basics of Key Vault
	 - Understand Data Lake Best Practices
- Challenge 01: **[Building Out the Bronze](./Solution-01.md)**
	 - Standup and configure the Synapse and Databricks Environments
	 - Agree on and begin to implement the three-tiered architecture 
	 - Hydrate the Bronze Data Lake
	 - Ensure no connection details are stored on the Linked Service or in Notebooks
- Challenge 02: **[Standardizing on Silver](./Solution-02.md)**
	 - Move the data from the Bronze Layer to the Silver Layer 
	 - Apply Delta Format to the Silver Layer
	 - Perform consolidation and standardization
- Challenge 03: **[Go for the Gold](./Solution-03.md)**
	 - Take data from the Silver Layer and make it business analyst ready
	 - Understand the basics of data models
- Challenge 04: **[Visualize the Results](./Solution-04.md)**
	 - Create Power BI assets to showcase your results


## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Additional Coach Prerequisites

The purpose of this hackathon is for the participants to utilize the three-tier data lake architecture to combine different data sources into one Delta Lake architecture that can be utilized.  

For Challenge 0, students will need to import data from both the AdventureWorks and WideWorldImporters databases into the Bronze layer.  Thus, before hosting this hackathon the lead Coach must setup these databases in an Azure SQL environment so that the students can connect to these as a source.  We want the students to focus on Databricks and Synapse technologies and not be responsible for setting up these databases.

These databases can be obtained at the following sites:
- [AdventureWorks sample databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)
- [World-Wide-Importers sample databases](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers) 

The above links should have database backup/restore scripts and SQL scripts to deploy the databases, use either one of those options at your discretion.  

Also, make sure to create a database reader account that the users can utilize to read the various tables.  The `CREATE LOGIN HackathonUser.sql` script is located in the [Solutions](./Solutions) folder and can be used for this purpose.

### Student Resources

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

Each team/squad will collaborate in one student's Azure subscription.  The subscription chosen must have the ability to add all users to that subscription and give them Contributor access within the Resource Group created for this hackathon. It would be better to give all users Owner access, just so that RBAC assignments can be done if and when required. The steps on how to do that are provided [here](https://learn.microsoft.com/en-us/azure/role-based-access-control/quickstart-assign-role-user-portal).
  
In terms of Azure services, the following services would generally be used.  
 - [Azure Data Lake Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) - Details on how to setup an ADLS Storage Account can be found [here](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal).
 - [Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/introduction/) - This is optional. In case the students want to focus more on Synapse instead and use the pipelines. In case we opt for Databricks, details on how to setup Azure Databricks can be found [here](https://learn.microsoft.com/en-us/azure/databricks/getting-started/quick-start?source=recommendations).
 - [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) - Details on how to setup Kay Vault can be found [here](https://learn.microsoft.com/en-us/azure/key-vault/general/quick-create-portal).
 - [Azure Synapse Analytics](https://learn.microsoft.com/en-us/azure/synapse-analytics/overview-what-is) - Details on how to setup a Synapse workspace can be found [here](https://learn.microsoft.com/en-us/azure/synapse-analytics/get-started-create-workspace).
 - [Azure Synapse Dedicated SQL Pools](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) - This is optional again, depending on what is chosen as the Gold Layer. Details of setup on Azure Synapse dedicated pools can be found [here](https://learn.microsoft.com/en-us/azure/synapse-analytics/quickstart-create-sql-pool-studio).
 - [Power BI](https://learn.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview) - Not technically Azure, but is needed for one of the Gold Layer options and for the visualization piece. Need to make sure the students have either licensed or trial versions of PowerBI to try out.
   
More detailed learning resources have been provided in the Student sections as well, but feel free to refer to these links at your discretion.

## Session Guidance 

This What the Hack was designed and executed for a remote/virtual audience.

We initially conducted this hackathon in three - 4 hour sessions for a total of 12 hours. It was done over a three week period with each session being conducted on a Friday.

- Day 1
  - Challenge 1 - Building Out the Bronze
  - Challenge 2 - Standardizing on Silver
 
- Day 2
  - Challenge 2 - Standardizing on Silver
  - Challenge 3 - Go for the Gold

- Day 3
  - Challenge 3 - Go for the Gold
  - Challenge 4 - Visualize the Results

We also had the attendees fill out a survey during registration to gauge their expertise and we made sure that each team was balanced with experts and beginners using the following questions:

- Experience Level with ADF/ Synapse Pipelines (100=Newbie -> 400=SME)
- Experience Level with ADF/Synapse Data Flows
- Experience Level with Azure Databricks
- Experience Level with Power BI

Answers were single select options of 100/200/300/400

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc. meant to be provided to students. (Must be packaged up by the coach and provided to students at the start of the event)
