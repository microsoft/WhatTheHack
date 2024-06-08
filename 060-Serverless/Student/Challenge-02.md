# Challenge 02 - Data Types and Data Statistics 

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites
- You have to complete **Challenge-01**
- Relevant permissions according to the documentation: [Azure Synapse RBAC roles](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-synapse-rbac-roles)

# Introduction

In this challenge you will access your Data Lake and will see how to infer data type and how to use predicate pushdown. 
Then you'll dig into the importance of statistics. 

**Learning objectives:**
- Get understanding on how auto data types infer works. 
- Understand how to retrieve table schema from data files with no need to scan all of them
- Statistics on Parquet and CSV table

### Schema infer and predicate pushdown
You've been asked to get the schema and determine if the inferred data types from Parquet files in "Factinternetsales" folder is the proper one or can be improved. 
- Can you get the schema from the parquet files without reading the entire dataset ?
- Are you able to optimize the OPENROWSET to benefit from Predicate pushdown when running this query ?

```sql
SELECT
    PRODUCTKEY
	,DUEDATEKEY
	,CUSTOMERKEY
FROM  
    OPENROWSET(
        BULK 'https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolder/Parquet/Factinternetsales',
        FORMAT='PARQUET'
    ) AS Rows
WHERE SALESORDERNUMBER = 'SO23532017081857'
```


### Statistics 

The more Serverless knows about data the better performance it can provide when accessing them.
Statistidcs are fundamentals and might heavilly affect query's performance.
- Do you need to manually create all the statistics needed to optimize the query below ?
- Can you explain why ?
- Can you find the statistics details ?

```sql
SELECT 
	Fis.SalesTerritoryKey
	,Fis.OrderDateKey
	, Dsr.SalesReasonName
	, AVG(CAST(SalesAmount AS DECIMAL(38,4))) SalesAmount_AVG
	, AVG(CAST(OrderQuantity AS DECIMAL(38,4))) OrderQuantity_AVG
FROM Ext_FactInternetSales Fis 
	INNER JOIN Ext_FactInternetSalesReasons Fisr
		ON Fisr.SalesOrderNumber = Fis.SalesOrderNumber
			AND Fisr.SalesOrderLineNumber = Fis.SalesOrderLineNumber
	INNER JOIN Ext_DimSalesReasons Dsr
		ON Fisr.SalesReasonKey = Dsr.SalesReasonKey
WHERE OrderDateKey = 20010703
	GROUP BY Fis.SalesTerritoryKey, Fis.OrderDateKey, Dsr.SalesReasonName
ORDER BY Fis.OrderDateKey
```


## Success Criteria
- Properly understand how to leverage manual schema definition with OPENROWSET
- Optimize inferred data type
- Good understanding about predicate pushdown and how to leverage it
- Leverage the CREATE STATISTCS command or Auto-Create statistic feature to improve queries performance

### Learning Resources

[Table data types in Synapse SQL](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-data-types)  
[Data types - Best practices](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#data-types)  
[Get the schema using sp_describe_first_result_set](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-describe-first-result-set-transact-sql?view=sql-server-ver16)  
[Predicate Pushdown](https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool#use-proper-collation-to-utilize-predicate-pushdown-for-character-columns)  
[Statistics in Serverless SQL Pool](<https://learn.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics#statistics-in-serverless-sql-pool>)  
[Create Stats on a folder - sp_create_openrowset_statistics](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-create-openrowset-statistics)  
[Drop Stats from a folder - sp_drop_openrowset_statistics](<https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-drop-openrowset-statistics>)  
