# Challenge 0 - Setup

**[Home](../../../README.md)** - [Next Challenge>](../Challenge01/Challenge01.md)

## Pre-requisites 

An Azure subscription is required that can deploy Azure SQL resources (Azure SQL Database and Azure SQL Database Managed Instance), Virtual Machines.

## Introduction

Nearly all challenges require resources in an Azure subscription to complete. A single subscription can be shared to the team, or team members can work in their own individual subscriptions.

The scenarios presented simulate on-premises environments; teams have flexibility to choose how to configure these environments based on preferences and environmental considerations.  For example, a team with limited bandwidth or networking constraints (such as difficulty in forwarding ports to connect to SQL Server from the cloud) may choose to set up the simulated "on-premises" environments in an Azure VM with SQL Server.  Another team may install the databases on a local machine, or configure them in docker.  Choose what works best for the team and hints will be provided along the way.

In this hack, some prerequisites will be challenge-specific: for example, a challenge might say, "This challenge requires the AdventureWorks database..." along with any necessary configuration.  As such, this setup is designed to provide general requirements while each challenge will list specific needs for that challenge only, as not all databases and tools are required for all challenges.

## Description

The objective of the setup is to ensure you have access to a subscription where resources may be deployed.  You also need an environment to host the tools required and to host the databases -- for the purposes of this hack, we'll refer to this as the customer's on-premises environment, even if it is located the cloud.

## Success Criteria

1. Pick a cool team name!  You and your team are part of a new SI start-up that is developing a practice on migrating and modernizing data solutions.  
1. Decide on the on-premises environment and have the following databases loaded; note, this can be in a VM in Azure running SQL Server, on a local SQL instance, in containers/Docker, etc.:
    - AdventureWorks2017 *or* AdventureWorksLT2017
        - AdventureWorksLT2017 is a bit easier and faster, better for teams with no prior experience and extremely limited bandwidth
        - AdventureWorks2017 is the preferred database as it presents a few challenges but may require a bit of experience and higher bandwidth to migrate, if migrating for a local machine.
    - WideWorldImporters (OLTP)
    - WideWorldImporters (DW)
1. Install Azure Data Studio and, optionally, SQL Management Studio.

## Learning Resources

* [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)
* [SQL Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
* [AdventureWorks Databases](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)
* [WideWorldImporters-Full.bak](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0)
* [WideWorldImportersDW-Full.bak](https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0)

## Tips (Optional)

* [Quickstart: Run SQL Server container with Docker](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver15&pivots=cs1-powershell)
* When considering the environment to host the "on premises" databases, consider connectivity constraints.  Most corporate environments will limit your ability to connect to a database from outside of the network.  Home environments may work well if you are comfortable in configuring NAT / port forwarding.  

## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*



