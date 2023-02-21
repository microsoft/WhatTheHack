# Challenge 4  - Delta integration and CETAS performance.

[< Previous Challenge>](./Solution-03.md) - **[Home](../README.md)** - [Next Challenge> ](./Solution-05.md) 


## Notes & Guidance

In this challenge you will read a Delta file on Synapse serverless as also understand the goals in use CETAS.

**Learning objectives:**

- Understand Synapse Serverless and Delta file integration
- Understand partition elimination concepts in which means in another words:
  *Data partition elimination refers to the database server's ability to determine, based on query predicates,* 
  *that only a subset of the data partitions in a table need to be accessed to answer a query.*
- Understand performance impact of CETAS

**Condition of success:**

- Understand how the partition the file organize the information under the storage

- Impacts in terms of performance and how to review the information available

- Choose the best approach for the query design.

## Query delta format

 First lets use the Ms.Docs example: 

 Run the contents of this script against your SQL Serverless Pool Database:

 https://raw.githubusercontent.com/Azure-Samples/Synapse/main/SQL/Samples/LdwSample/SampleDB.sql

Run the following query provided on the docs: [Query Delta Lake format using serverless SQL pool - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-delta-lake-format#query-partitioned-data)

```
SELECT
        YEAR(pickup_datetime) AS year,
        passenger_count,
        COUNT(*) AS cnt
FROM  
    OPENROWSET(
        BULK 'yellow',
        DATA_SOURCE = 'DeltaLakeStorage',
        FORMAT='DELTA'
    ) nyc
WHERE
    nyc.year = 2017
    AND nyc.month IN (1, 2, 3)
    AND pickup_datetime BETWEEN CAST('1/1/2017' AS datetime) AND CAST('3/31/2017' AS datetime)
GROUP BY
    passenger_count,
    YEAR(pickup_datetime)
ORDER BY
    YEAR(pickup_datetime),
    passenger_count;
```

Considering the data is partition per year:
The OPENROWSET function will eliminate partitions that don't match the year and month in the where clause.
This file/partition pruning technique will significantly reduce your data set, improve performance, and reduce the cost of the query.

## Create your own Delta folder using Spark

Create a new notebook in your Synapse workspace and run the code below to create the delta dataset. 
Chenge the path using the proper container

```pyspark
%%pyspark

from delta.tables import *

sourcepath_fis = 'abfss://YourContainer@YourStorageAccount.dfs.core.windows.net/YourFolder/Parquet/Factinternetsales/'
destinationpath_fis = 'abfss://YourContainer@YourStorageAccount.dfs.core.windows.net/YourFolder/Delta/Factinternetsales/'

sourcepath_reason = 'abfss://useYourContainerrs@YourStorageAccount.dfs.core.windows.net/YourFolder/Parquet/Factinternetsalesreasons/'
destinationpath_reason = 'abfss://YourContainer@YourStorageAccount.dfs.core.windows.net/YourFolder/Delta/Factinternetsalesreasons/'

sourcepath_dimreason = 'abfss://YourContainer@YourStorageAccount.dfs.core.windows.net/YourFolder/Parquet/Dimsalesreasons/'
destinationpath_dimreason = 'abfss://YourContainer@YourStorageAccount.dfs.core.windows.net/YourFolder/Delta/Dimsalesreasons/'

fis = spark.read.parquet(sourcepath_fis); 
fis.write.format("delta").mode("overwrite").option('overwriteSchema','true').save(destinationpath_fis) 

fisr = spark.read.parquet(sourcepath_reason); 
fisr.write.format("delta").mode("overwrite").option('overwriteSchema','true').save(destinationpath_reason) 

fisr = spark.read.parquet(sourcepath_dimreason); 
fisr.write.format("delta").mode("overwrite").option('overwriteSchema','true').save(destinationpath_dimreason) 

```

## Query your own delta folder

 Run the query - [C4_1_Delta.sql](./Solutions/Challenge04/C4_1_Delta.sql) on Synapse Studio, point to Built in - Serverless database:

- Adjust the script under the storage details to reflect the structure that you use to create the delta parquet files. 

- Run  the query more than once. So you can get the real execution time, after the first execution. Take notes of the execution time.

  Question: why do you think the first execution was slower than the second execution? Ans: Because  of the stats creation

## Delta

 Run the query on Synapse Studio - [C4_2_Fact_and_dim.sql](./Solutions/Challenge04/C4_2_Fact_and_dim.sql), point to Built in - Serverless database.

Take note of the time of execution.

 Run the query - [C4_3_CETAS.sql](./Solutions/Challenge04/C4_3_CETAS.sql) on Synapse Studio, point to Built in - Serverless database.
 Follow this by running [C4_Fact_and_dimensions_CETAS.sql](./Solutions/Challenge04/C4_4_Fact_and_dimensions_CETAS.sql)

- Can you notice the performance difference? *As data is consolidated in one file parquet on the storage account is much more faster the execution than access the files and filtering them according to the query*
- Can you tell why? Ans:it is faster to get the data consolidated in one than to let for the optimizer solve this query while searching for the data through the files.
- Check the path configured on the storage, the path that you configured for [C4_3_CETAS.sql](./Solutions/Challenge04/C4_3_CETAS.sql) What do you see as CETAS reference for Serveless

**Achieving more... Delta Time travel with Spark**

**What is Time travel using Delta?** 

Time travel enables point-in-time query snapshots or even rolls back erroneous updates when you are using Delta on top of parquet.


**Lets..Actually, use Delta Time travel**


For example. The plan here is to export a point in time to recover a change in a transaction. 
You can find more information about Delta/Spark here: 
[Overview of how to use Linux Foundation Delta Lake in Apache Spark for Azure Synapse Analytics - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-delta-lake-overview?pivots=programming-language-python#read-older-versions-of-data-using-time-travel)

For example, accidently changed the data from the Dimension as follows:


```
%%pyspark
##Whoops Data was changed accidentaly

from delta.tables import *
from pyspark.sql.functions import *

sourcepath = 'abfss://YourContainer@YourStorageAccount.dfs.core.windows.net/YourFolder/Delta/Dimsalesreasons/'
deltaTable = DeltaTable.forPath(spark, sourcepath)
 

# Update the table
deltaTable.update(
    condition = "SalesReasonName <> 'Demo Event'",
    set = { "SalesReasonName": "'Demo EventX'" }
 )
```


**Challenge**
Use as reference:  [Delta Time Travel on Spark](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/synapse-spark-delta-time-travel/ba-p/3646789)

  - How Can you recovery the data prior the change? Ans: yes you can recover. Look over the Delta table history to find the checkpoint for recovery. ref: https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/synapse-spark-delta-time-travel/ba-p/3646789

  - Can you save the data recovered to a different folder? *Yes, look the notebook under the solution resource*

  - How can you find the right version of the data which it was changed? *Yes, look the notebook under the solution resource*

  - Can you read it from Serveless SQL Pool, aftermath? *yes. Just query the folder on Serveless SQL Pool*

 [Notebook solution -Spark](https://dev.azure.com/LFerrariProjects/Serverless/_git/WTH-Serverless?path=/Coach/Solutions/Challenge04/C4_DeltaTimeTravel.ipynb&version=GBmain)
 
## Learning Resources

[[Query Delta Lake format using serverless SQL pool - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-delta-lake-format#query-partitioned-data)

[Serverless SQL pool self-help - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/resources-self-help-sql-on-demand?tabs=x80070002#delta-lake)

[CREATE EXTERNAL TABLE AS SELECT (CETAS) in Synapse SQL - Azure Synapse Analytics | Microsoft Docs](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-cetas)# Challenge 4  - Delta integration and CETAS performance.

[Delta Time Travel on Spark](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/synapse-spark-delta-time-travel/ba-p/3646789)-data-storage#filename-function)