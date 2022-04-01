# What The Hack - Intro To OSS DB Migration to Azure OSS DB
## Introduction
This hack includes a optional [lecture presentation](Coach/OSS-DB-What-the-Hack-Lecture.pptx?raw=true) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

The tips in this coach's guide are intended to help you guide the attendees as they go through the challenges. You should not immediately give them out. It is okay for the attendees to struggle for a bit before arriving at the solution. This is often the best way for them to learn. Use your best judgement for deciding when to give them additional help.

You will need to zip up the files in the Resources directory under the Student directory and place it in the Files section of the General Teams channel. 

## Challenge tips
- Challenge 0: **[Pre-requisites - Setup Environment and Prerequisites!](00-prereqs.md)**
   - Prepare your environment to run the sample application
- Challenge 1: **[Discovery and assessment](01-discovery.md)**
   - Assess the application's PostgreSQL/MySQL databases
- Challenge 2: **[Offline migration](02-offline-migration.md)**
   - Dump the "on-prem" databases, create databases for Azure DB for PostgreSQL/MySQL and restore them
- Challenge 3: **[Offline Cutover and Validation](03-offline-cutover-validation.md)**
   - Reconfigure the application to use the appropriate connection string and validate that the application is working
- Challenge 4: **[Online Migration](04-online-migration.md)** 
   - Create new databases in Azure DB for PostgreSQL/MySQL and use the Azure Database Migration Service to replicate the data from the on-prem databases
- Challenge 5: **[Online Cutover and Validation](05-online-cutover-validation.md)**
   - Reconfigure the application to use the appropriate connection string for Azure DB for PostgreSQL/MySQL
- Challenge 6: **[Private Endpoints](06-private-endpoint.md)**
   - Reconfigure the application to use configure Azure DB for PostgreSQL/MySQL with a private endpoint so it can be used with a private IP address
- Challenge 7: **[Replication](07-replication.md)**
   - Add an additional replica to the Azure DB for PostgreSQL/MySQL
