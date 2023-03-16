# Challenge 04 - Time to Analyze Data - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

Please make sure that the Students have the deployment files within the archive you will provide (should have `/Challenge00/` and `/Challenge04/` folders, please do not provide `/Challenge02/` as that is a coach's reference implementation).

Ideally, the students will have opted to leverage Azure Synapse Link to solve the analytical scenario/problem:
- The students should enable the Azure Synapse Link feature for their Azure Cosmos DB Account, and choose the `clickstream` container.
- The students should enable a short TTL on the Azure Cosmos DB container for the clickstream data, as there is no reason to keep the data points in this more expensive data store, and set a longer TTL on the Synapse Link store. For example:
    - Time to Live: 86400 seconds (1 day) - for the `clickstream` container.
    - Analytical Storage Time to Live: 2628000 (1 month) - for the Analytical store.
- The students should have deployed an Azure Synapse Workspace
- The students should show a sample query (either using Spark Pools or Serverless) in Synapse.
- As a bonus, the students should enable custom partitioning of the data in the Analytical store. Since in the Analytical store, data is not partitioned, doing so may greatly benefit both cost and performance of their analytical queries. They can use the guidance linked in [this document](https://docs.microsoft.com/en-us/azure/cosmos-db/configure-custom-partitioning?tabs=python) to configure the custom partitioning. A suggestion would be to partition using two jobs:
    - By date and User Id. This would be useful for analytical queries that filter/aggregate on date and user
    - By date and Page Id. This would be useful for analytical queries that filter/aggregate on date and page
    - Job definitions:
        ```
        # Job 1
        spark.read\
            .format("cosmos.olap") \
            .option("spark.synapse.linkedService", "<linked service name>") \
            .option("spark.cosmos.container", "clickstream") \
            .option("spark.cosmos.asns.execute.partitioning", "true") \
            .option("spark.cosmos.asns.partition.keys", "date String, user_id int") \
            .option("spark.cosmos.asns.basePath", "/mnt/CosmosDBPartitionedStoreByDateByUser/") \
            .option("spark.cosmos.asns.merge.partitioned.files", "true") \
            .option("spark.cosmos.asns.partitioning.maxRecordsPerFile", "2000000") \
            .option("spark.cosmos.asns.partitioning.shuffle.partitions", "400") \
            .load()

        # Job 2
        spark.read\
            .format("cosmos.olap") \
            .option("spark.synapse.linkedService", "<linked service name>") \
            .option("spark.cosmos.container", "clickstream") \
            .option("spark.cosmos.asns.execute.partitioning", "true") \
            .option("spark.cosmos.asns.partition.keys", "date String, page_id int") \
            .option("spark.cosmos.asns.basePath", "/mnt/CosmosDBPartitionedStoreByDateByPage/") \
            .option("spark.cosmos.asns.merge.partitioned.files", "true") \
            .option("spark.cosmos.asns.partitioning.maxRecordsPerFile", "2000000") \
            .option("spark.cosmos.asns.partitioning.shuffle.partitions", "400") \
            .load()
        ```
        Each job would need to be triggered by scheduling a separate PySpark notebook.
    - A sample query that generates the number of distinct page hits by user by date:
        ```
        SELECT
            page_id AS 'Page Id',
            COUNT(DISTINCT(user_id)) AS 'Number of Hits',
            date AS 'Date'
        FROM
            OPENROWSET(
                BULK 'https://<adlsaccount>.dfs.core.windows.net/<container_name>/mnt/CosmosDBPartitionedStoreByDateByPage/**',
                FORMAT = 'PARQUET'
            ) AS [result]
        GROUP BY [date], page_id
        ```
    - A sample query that generates the number of distinct pages visited by each user by date:
        ```
        SELECT
            user_id AS 'User Id',
            COUNT(DISTINCT(page_id)) AS 'Number of Hits',
            date AS 'Date'
        FROM
            OPENROWSET(
                BULK 'https://<adlsaccount>.dfs.core.windows.net/<container_name>/mnt/CosmosDBPartitionedStoreByDateByUser/**',
                FORMAT = 'PARQUET'
            ) AS [result]
        GROUP BY [date], user_id
        ```
