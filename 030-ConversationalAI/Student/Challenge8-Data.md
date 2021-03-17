# Challenge 8: Add Advanced intelligence to your Bot using Azure Data Services
[< Previous Challenge](./Challenge7-CICD.md) - **[Home](../README.md)** 
## Introduction
Organizations generate a lot of data in different format. A use case for this challenge is that a company collect data from external source and using a compute services to extract, load and transform the data into insight and surface up to the Bot. In this challenge, you will use Azure Databricks to extract ESG initiative statement from different companies website and use ML models to analyze the key strategy each company has. The final data is stored in a Azure Data store services (Cosmos or Azure Sql db). Then, use the Bot we have built so far and call the data. 
	
## Description

1. Add a Azure Databricks resource create a cluster with 7.X ML Spark and Standard Cluster mode.

2. Import the Notebook in the Student/Resource folder to your Workspace and read through the logic there. 

3. Set up a Azure SQLDB account and create a database and a container as the data serve layer

4. Go back to your Databricks and update the cell (cmd 44) with the Azure SQL DB account details you just created.

5. (Option) If you want to save the result also in ADLS, you need you update cmd 39. If not, you can bypass cmd39.

3. Run the Notebook and make sure there is data saved to Azure SQL DB Table

4. Go back to your Bot Composer and enable Bot local Run Time, create a customer action which links the Bot Composer to Azure SQL DB data. 


## Success Criteria
* Create a sample question from the FSI bot which querying the data in Azure SQL DB.


## Resources
* [Orignial Databrick blog on the ESG analysis](https://databricks.com/blog/2020/07/10/a-data-driven-approach-to-environmental-social-and-governance.html)
* [Bot Composer Custom Actions](https://docs.microsoft.com/en-us/composer/how-to-add-custom-action?tabs=csharp)



# Congratulations

You have finished the challenges for this Hack. 
We are updating the content continuously. Stay Tuned.