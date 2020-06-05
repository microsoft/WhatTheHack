--Identifies which Replicated tables have not been replicated across all nodes of the cluster.
--After inserting,deleting or updating a table, you will need to run a query against it the first time to replicate it across all nodes.
--First statement determines if table resides on one node
SELECT [ReplicatedTable] = t.[name]
  FROM sys.tables t  
  JOIN sys.pdw_replicated_table_cache_state c  
    ON c.object_id = t.object_id
  JOIN sys.pdw_table_distribution_properties p
    ON p.object_id = t.object_id
  WHERE c.[state] = 'NotReady'
    AND p.[distribution_policy_desc] = 'REPLICATE'

--Simple statement to replicate data across all nodes.
--Run this each time you run the CTAS statement with a replicate
SELECT TOP 1 * FROM [Dimension].[Stock Item]


--ROUND ROBIN DISTRIBUTION with a HEAP index
--Run explain plan to see costs
--Check Skew report to see graph of how data is distributed across distributions
CREATE TABLE [Dimension].[Stock_Item_ROUND_ROBIN]
WITH
  (
    HEAP,
    DISTRIBUTION = ROUND_ROBIN
  )  
AS SELECT * FROM [Dimension].[Stock Item]
OPTION  (LABEL  = 'CTAS : Stock_Item_ROUNDROBIN')

-- Switch table names
RENAME OBJECT [Dimension].[Stock Item] to [Stock_Item_old];
RENAME OBJECT [Dimension].[Stock_Item_ROUND_ROBIN] TO [Stock Item];

DROP TABLE [Dimension].[Stock_Item_old];

--Replicate DISTRIBUTION with a CLUSTERED INDEX
--Run Select statement on line 18 before running the explain plan
--Run explain plan to see the costs
--Check Skew report to see graph of how data is distributed across distributions
CREATE TABLE [Dimension].[Stock_Item_REPLICATE]
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Stock Item] ASC
	)
)
AS SELECT * FROM [Dimension].[Stock Item]
OPTION  (LABEL  = 'CTAS : Stock_Item_REPLICATE')

-- Switch table names
RENAME OBJECT [Dimension].[Stock Item] to [Stock_Item_old];
RENAME OBJECT [Dimension].[Stock_Item_REPLICATE] TO [Stock Item];

DROP TABLE [Dimension].[Stock_Item_old];

--Replicate DISTRIBUTION with a CLUSTERED COLUMNSTORE INDEX
--Run Select statement on line 18 before running the explain plan
--Run explain plan to see the costs
--Check Skew report to see graph of how data is distributed across distributions
CREATE TABLE [Dimension].[Stock_Item_REPLICATE]
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
AS SELECT * FROM [Dimension].[Stock Item]
OPTION  (LABEL  = 'CTAS : Stock_Item_REPLICATE')

-- Switch table names
RENAME OBJECT [Dimension].[Stock Item] to [Stock_Item_old];
RENAME OBJECT [Dimension].[Stock_Item_REPLICATE] TO [Stock Item];

DROP TABLE [Dimension].[Stock_Item_old];