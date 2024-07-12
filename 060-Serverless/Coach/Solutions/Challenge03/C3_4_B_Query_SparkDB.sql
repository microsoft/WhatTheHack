/*****************************************************************************************************************************
What the hack - Serverless - How to work with it
CHALLENGE 03 - Excercise 04 - B - Query spark DB

https://learn.microsoft.com/en-us/azure/synapse-analytics/metadata/table
https://learn.microsoft.com/en-us/azure/synapse-analytics/metadata/matabase#create-and-connect-to-spark-database-with-serverless-sql-pool
https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-storage-files-spark-tables

Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/
USE WTHServerless_SparkDB
GO

SELECT TOP 10 * FROM factinternetsales_partitioned
WHERE YEAR = 2020 AND MONTH = 05
GO