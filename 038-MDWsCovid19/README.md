
# Modern Data Warehouse - COVID 19
## Introduction
This hack is designed so that the students will construct a fully functional Modern Data Pipeline utilizing COVID-19 data and then creating calcuations on growth vs policies enacted by different governments.  The process of collecting, organizing and making inferences based on different data sources is someting that most data practioners need to do at some point in there career.  This hack teaches how to do this in Azure.  
**Note:  This lab is recommended to be done over at least three days.  Is it very in-depth and will test most students.**

## Learning Objectives
In this hack you will be working to make a recommendation to a fictional government on the COVID-19 mitigation policies they should enact based on collecting, cleaning, correlating and examining avilable data sets. 

The technical learning objectives:

1. Provision a Data Lake
2. Land data in the Data Lake from Cloud resources (Relational and CosmosDB).
3. Land data in the Data Lake from On-Premise resources (an Azure VM is used to simulate an on-prem store).
4. Create Data Pipelines to merge the datasets into usuable format.
5. Define Star Schemas and create a Data Warehouse.
6. Enact version control and administrive approval for all pull requests within Github.
7. Perform calculations on Fact tables.
8. Enable Unit Tests

## Challenges
- Challenge 1: **[Background](Student/01-Background.md)**
   - Prepare for the challenge
- Challenge 2: **[Provision](Student/02-Provision.md)**
   - Provision a Data Storage solution for landing your COVID-19 data sources.
- Challenge 3: **[Ingest from Cloud](Student/03-CloudIngest.md)**
   - Ingest COVID-19 data sources from cloud resources.
- Challenge 4: **[Ingest from On-Premises SQL DB](Student/04-OnPremIngest.md)**
   - Ingest COVID-19 data sources from On-Premises resources.
- Challenge 5: **[Staging and Transformation](Student/05-TransformLoad.md)**
   - Configure data pipelines to transform and load the data into usable sources for a Data Warehouse.
- Challenge 6: **[Calculate and DW Load](Student/06-Calculate.md)**
   - Create Data Warehouse and calculations for growth vs policy. 

## Prerequisites
- Your own Azure subscription with Owner access
- Visual Studio Code
- Azure CLI
- Azure Data Explorer
- Azure Storage Explorer
- Public Github Repository

## Repository Contents
- `../Coach`
    - Coach's Guide
- `../images`
    - Generic image files needed
- `../Student`  
    - Student Challenges
- `../Coach/LabDeployment`
    - ARM Templates 
    - Powershell Scripts 
    - Data for deploying the lab environment

## Contributors
### Microsoft Government Team :
- [Chris Baudo](https://github.com/chrisbaudo) 
- [Binh Cao](https://github.com/binhcaomsft) 
- [Jon Biggs](https://github.com/jobiggs) 
- [Islam El-Ghazali ](https://github.com/islamtg)
- [Sam Abouissa](https://github.com/samy5317)
- [Solomon Woldesenbet](https://github.com/solomonwSLG)
- [Amanda Howard](https://github.com/amandajeanhoward11)
- [Madhu Chanthati](https://github.com/machanth)
- [Chris Blevins](https://github.com/blevinscm)