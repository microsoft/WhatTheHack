
# Modern Data Warehouse - COVID 19
## Introduction
This hack is inspired by the Modern Data Warehouse Open Hack.  It is designed so that the students will construct a fully functional Modern Data Pipeline utilizing COVID-19 data and then creating calcuations on growth vs policies enacted by different governments.  The process of collecting, organizing and making inferences based on different data sources is someting that most data practioners need to do at some point in there career.  This hack teaches how to do this in Azure.  
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
1. Background: **[Learn about the fictional government of Caladan and your tasks](Student/00-Background.md)**
   - Prepare for the challenge
2. Challenge 01: **[Provision](Student/01-Provision.md)**
   - Provision a Data Storage solution for landing your COVID-19 data sources.
3. Challenge 02: **[Ingest 1](Student/02-CloudIngest.md)**
   - Ingest COVID-19 data sources from cloud resources.
4. Challenge 03: **[Ingest 2](Student/03-OnPremIngest.md)**
   - Ingest COVID-19 data sources from On-Premises resources.
5. Challenge 04: **[Transform and Load](Student/04-TransformLoad.md)**
   - Configure data pipelines to transform and load the data into usable sources for a Data Warehouse
6. Challenge 05: **[Calculate](Student/05-Calculate.md)**
   - Create Data Warehouse and calculations for growth vs policy. 

## Prerequisites
- Your own Azure subscription with Owner access and follow the instruction of the **[Lab Deployment](036-MDW-COVID19\Student\LabDeployment\README.md)**
- Visual Studio Code
- Azure CLI
- Azure Data Explorer
- Azure Storage Explorer
- Public Github Repository

## Repository Contents (Optional)
- `../Coach`
    - Coach's Guide
- `../images`
    - Generic image files needed
- `../Student`  
    - Student Challenges
- `../Student/LabDeployment`
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

