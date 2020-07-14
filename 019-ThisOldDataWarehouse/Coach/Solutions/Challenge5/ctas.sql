--COACH'S Note.  Success criteria #3 is to determine which table design is optimal for the City Table
--This script will simulate the different table distributions so students can easily see the differences.
--WARNING -- Explain plan is not always consistent in terms of overall cost and steps.
--Ideal plan should have cost less than 2 and steps around 6.
--Database cost isn't a perfect match to response times in Power BI.  The query from "Total Sales by Quantity" also joins to the date table and might be reason for minimal response time improvements.
*****BEST Outcome is with Distribution Replicate and Clustered Index******
*****Worse Outcome is with Round Robin with Hash******

--This query identifies which Replicated Table(s) have not been replicated across all nodes of the cluster.
--This happens after each load or after inserting,deleting or updating a table.
--First statement determines if table has resides on one node
SELECT [ReplicatedTable] = t.[name]
  FROM sys.tables t  
  JOIN sys.pdw_replicated_table_cache_state c  
    ON c.object_id = t.object_id
  JOIN sys.pdw_table_distribution_properties p
    ON p.object_id = t.object_id
  WHERE c.[state] = 'NotReady'
    AND p.[distribution_policy_desc] = 'REPLICATE'

--Simple statement to replicate data across all nodes.
--Run this each time you run the CTAS statement with a replicate or load more data into the tables
SELECT TOP 1 * FROM [Dimension].[City]

--There are three simulations.  Run each one with the explain plan to compare results (total cost, steps, and response time) -- 
	-- One, Round Robin Distribution with Heap
	-- Two, Replicate with a Clustered Index
	-- Three, Replicate with Clustered Columnstore Index


--ROUND ROBIN DISTRIBUTION with a HEAP index
--Run explain plan to see costs
--Check Skew report to see graph of how data is distributed across distributions
CREATE TABLE [Dimension].[City_ROUND_ROBIN]
WITH
  (
    HEAP,
    DISTRIBUTION = ROUND_ROBIN
  )  
AS SELECT * FROM [Dimension].[City]
OPTION  (LABEL  = 'CTAS : City_ROUNDROBIN')

-- Switch table names
RENAME OBJECT [Dimension].[City] to [City_old];
RENAME OBJECT [Dimension].[City_ROUND_ROBIN] TO [City];

DROP TABLE [Dimension].[City;

--Replicate DISTRIBUTION with a CLUSTERED INDEX
--Run Select statement on line 18 before running the explain plan
--Run explain plan to see the costs
--Check Skew report to see graph of how data is distributed across distributions
CREATE TABLE [Dimension].[City_REPLICATE]
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[City Key] ASC
	)
)
AS SELECT * FROM [Dimension].[City]
OPTION  (LABEL  = 'CTAS : City_REPLICATE')

-- Switch table names
RENAME OBJECT [Dimension].[City] to [City_old];
RENAME OBJECT [Dimension].[City_REPLICATE] TO [City];

DROP TABLE [Dimension].[City_old];

--Replicate DISTRIBUTION with a CLUSTERED COLUMNSTORE INDEX
--Run Select statement on line 18 before running the explain plan
--Run explain plan to see the costs
--Check Skew report to see graph of how data is distributed across distributions
CREATE TABLE [Dimension].[City_REPLICATE]
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
AS SELECT * FROM [Dimension].[City]
OPTION  (LABEL  = 'CTAS : City_REPLICATE')

-- Switch table names
RENAME OBJECT [Dimension].[City] to [City_old];
RENAME OBJECT [Dimension].[City_REPLICATE] TO [City];

DROP TABLE [Dimension].[City_old];