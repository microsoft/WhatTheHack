-- Run Explain Plan and copy results into VS Code.  Format XML Code to review results.  Execute each combination of Dimension.[City] based on different distribution and index options.
-- Experiment will help you understand the optimal distribution key to prevent unnecessary shuffles.
-- Query is from Power BI Report on the "High Level Dashboard" Page and click on "Total Sales by Province".  If you open up the Performance analyzer and "Copy query" for this table you will be able to capture SQL Statement
-- Delete all DAX components and just keep the SQL Syntax
-- There are two joins in this explain plan on Date and City table. We will only focus on City for this exercise but the response times in Power BI might not improvement substantially since Date table is included
-- Look at bottom of this document for optimal Explain Plan
-- Sometime the explain plan might not be consistent across runs

EXPLAIN WITH_RECOMMENDATIONS(
SELECT 
TOP (1000001) [t3].[State Province],SUM([t0].[Total Including Tax])
 AS [a0]
FROM 
(
((select [$Table].[Sale Key] as [Sale Key],
    [$Table].[City Key] as [City Key],
    [$Table].[Customer Key] as [Customer Key],
    [$Table].[Bill To Customer Key] as [Bill To Customer Key],
    [$Table].[Stock Item Key] as [Stock Item Key],
    [$Table].[Invoice Date Key] as [Invoice Date Key],
    [$Table].[Delivery Date Key] as [Delivery Date Key],
    [$Table].[Salesperson Key] as [Salesperson Key],
    [$Table].[WWI Invoice ID] as [WWI Invoice ID],
    [$Table].[Description] as [Description],
    [$Table].[Package] as [Package],
    [$Table].[Quantity] as [Quantity],
    [$Table].[Unit Price] as [Unit Price],
    [$Table].[Tax Rate] as [Tax Rate],
    [$Table].[Total Excluding Tax] as [Total Excluding Tax],
    [$Table].[Tax Amount] as [Tax Amount],
    [$Table].[Profit] as [Profit],
    [$Table].[Total Including Tax] as [Total Including Tax],
    [$Table].[Total Dry Items] as [Total Dry Items],
    [$Table].[Total Chiller Items] as [Total Chiller Items],
    [$Table].[Lineage Key] as [Lineage Key]
from [Fact].[Sale] as [$Table]) AS [t0]

 left outer join 

(select [_].[Date] as [Invoice Date],
    [_].[Day Number] as [Day Number],
    [_].[Day] as [Day],
    [_].[Month] as [Month],
    [_].[Short Month] as [Short Month],
    [_].[Calendar Month Number] as [Calendar Month Number],
    [_].[Calendar Month Label] as [Calendar Month Label],
    [_].[Calendar Year] as [Calendar Year],
    [_].[Calendar Year Label] as [Calendar Year Label],
    [_].[Fiscal Month Number] as [Fiscal Month Number],
    [_].[Fiscal Month Label] as [Fiscal Month Label],
    [_].[Fiscal Year] as [Fiscal Year],
    [_].[Fiscal Year Label] as [Fiscal Year Label],
    [_].[ISO Week Number] as [ISO Week Number]
from [Dimension].[Date] as [_]) AS [t1] on 
(
[t0].[Invoice Date Key] = [t1].[Invoice Date]
)
)


 left outer join 

(select [$Table].[City Key] as [City Key],
    [$Table].[WWI City ID] as [WWI City ID],
    [$Table].[City] as [City],
    [$Table].[State Province] as [State Province],
    [$Table].[Country] as [Country],
    [$Table].[Continent] as [Continent],
    [$Table].[Sales Territory] as [Sales Territory],
    [$Table].[Region] as [Region],
    [$Table].[Subregion] as [Subregion],
    [$Table].[Latest Recorded Population] as [Latest Recorded Population],
    [$Table].[Valid From] as [Valid From],
    [$Table].[Valid To] as [Valid To],
    [$Table].[Lineage Key] as [Lineage Key]
from [Dimension].[City] as [$Table]) AS [t3] on 
(
[t0].[City Key] = [t3].[City Key]
)
)

WHERE 
(
([t1].[Invoice Date] < CAST( '20200701 00:00:00' AS datetime))
 AND 
([t1].[Invoice Date] >= CAST( '20100701 00:00:00' AS datetime))
)

GROUP BY [t3].[State Province] 
)
//*
*******OPTIMAL EXPLAIN PLAN*****************
<?xml version="1.0" encoding="utf-8"?>
<dsql_query number_nodes="1" number_distributions="60" number_distributions_per_node="60">
	<sql>
		(  SELECT   TOP (1000001) [t3].[State Province],SUM([t0].[Total Including Tax])   AS [a0]  FROM   (  ((select [$Table].[Sale Key] as [Sale Key],      [$Table].[City Key] as [City Key],      [$Table].[Customer Key] as [Customer Key],      [$Table].[Bill To Customer Key] as [Bill To Customer Key],      [$Table].[Stock Item Key] as [Stock Item Key],      [$Table].[Invoice Date Key] as [Invoice Date Key],      [$Table].[Delivery Date Key] as [Delivery Date Key],      [$Table].[Salesperson Key] as [Salesperson Key],      [$Table].[WWI Invoice ID] as [WWI Invoice ID],      [$Table].[Description] as [Description],      [$Table].[Package] as [Package],      [$Table].[Quantity] as [Quantity],      [$Table].[Unit Price] as [Unit Price],      [$Table].[Tax Rate] as [Tax Rate],      [$Table].[Total Excluding Tax] as [Total Excluding Tax],      [$Table].[Tax Amount] as [Tax Amount],      [$Table].[Profit] as [Profit],      [$Table].[Total Including Tax] as [Total Including Tax],      [$Table].[Total Dry Items] as [Total Dry Items],      [$Table].[Total Chiller Items] as [Total Chiller Items],      [$Table].[Lineage Key] as [Lineage Key]  from [Fact].[Sale] as [$Table]) AS [t0]     left outer join     (select [_].[Date] as [Invoice Date],      [_].[Day Number] as [Day Number],      [_].[Day] as [Day],      [_].[Month] as [Month],      [_].[Short Month] as [Short Month],      [_].[Calendar Month Number] as [Calendar Month Number],      [_].[Calendar Month Label] as [Calendar Month Label],      [_].[Calendar Year] as [Calendar Year],      [_].[Calendar Year Label] as [Calendar Year Label],      [_].[Fiscal Month Number] as [Fiscal Month Number],      [_].[Fiscal Month Label] as [Fiscal Month Label],      [_].[Fiscal Year] as [Fiscal Year],      [_].[Fiscal Year Label] as [Fiscal Year Label],      [_].[ISO Week Number] as [ISO Week Number]  from [Dimension].[Date] as [_]) AS [t1] on   (  [t0].[Invoice Date Key] = [t1].[Invoice Date]  )  )       left outer join     (select [$Table].[City Key] as [City Key],      [$Table].[WWI City ID] as [WWI City ID],      [$Table].[City] as [City],      [$Table].[State Province] as [State Province],      [$Table].[Country] as [Country],      [$Table].[Continent] as [Continent],      [$Table].[Sales Territory] as [Sales Territory],      [$Table].[Region] as [Region],      [$Table].[Subregion] as [Subregion],      [$Table].[Latest Recorded Population] as [Latest Recorded Population],      [$Table].[Valid From] as [Valid From],      [$Table].[Valid To] as [Valid To],      [$Table].[Lineage Key] as [Lineage Key]  from [Dimension].[City] as [$Table]) AS [t3] on   (  [t0].[City Key] = [t3].[City Key]  )  )    WHERE   (  ([t1].[Invoice Date] &lt; CAST( '20200701 00:00:00' AS datetime))   AND   ([t1].[Invoice Date] &gt;= CAST( '20100701 00:00:00' AS datetime))  )    GROUP BY [t3].[State Province]   )
	</sql>
	<dsql_operations total_cost="0.0266757790071187" total_number_operations="5">
		<dsql_operation operation_type="RND_ID">
			<identifier>
				TEMP_ID_53
			</identifier>
		</dsql_operation>
		<dsql_operation operation_type="ON">
			<location permanent="false" distribution="AllDistributions" />
			<sql_operations>
				<sql_operation type="statement">
					CREATE TABLE [qtabledb].[dbo].[TEMP_ID_53] ([State Province] NVARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, [col] DECIMAL(38, 2) NOT NULL ) WITH(DISTRIBUTED_MOVE_FILE='');
				</sql_operation>
			</sql_operations>
		</dsql_operation>
		<dsql_operation operation_type="SHUFFLE_MOVE">
			<operation_cost cost="0.0266757790071187" accumulative_cost="0.0266757790071187" average_rowsize="109" output_rows="51.7195" GroupNumber="42" />
			<source_statement>
				SELECT [T1_1].[State Province] AS [State Province], [T1_1].[col] AS [col] FROM (SELECT SUM([T2_2].[Total Including Tax]) AS [col], [T2_1].[State Province] AS [State Province] FROM (SELECT [T3_1].[State Province] AS [State Province], [T3_1].[City Key] AS [City Key] FROM [wwisynapse].[Dimension].[City] AS T3_1) AS T2_1 RIGHT OUTER JOIN  (SELECT [T3_2].[City Key] AS [City Key], [T3_2].[Total Including Tax] AS [Total Including Tax] FROM (SELECT [T4_1].[Date] AS [Date] FROM [wwisynapse].[Dimension].[Date] AS T4_1 WHERE (([T4_1].[Date] &gt;= CAST ('07-01-2010 00:00:00.000' AS DATETIME)) AND ([T4_1].[Date] &lt; CAST ('07-01-2020 00:00:00.000' AS DATETIME)))) AS T3_1 INNER JOIN  (SELECT [T4_1].[Invoice Date Key] AS [Invoice Date Key], [T4_1].[City Key] AS [City Key], [T4_1].[Total Including Tax] AS [Total Including Tax] FROM [wwisynapse].[Fact].[Sale] AS T4_1 WHERE (([T4_1].[Invoice Date Key] &gt;= CAST ('07-01-2010 00:00:00.000' AS DATETIME)) AND ([T4_1].[Invoice Date Key] &lt; CAST ('07-01-2020 00:00:00.000' AS DATETIME)))) AS T3_2  ON ([T3_1].[Date] = [T3_2].[Invoice Date Key])) AS T2_2  ON ([T2_2].[City Key] = [T2_1].[City Key]) GROUP BY [T2_1].[State Province]) AS T1_1  OPTION (MAXDOP 1, MIN_GRANT_PERCENT = [MIN_GRANT], DISTRIBUTED_MOVE(N''))
			</source_statement>
			<destination_table>
				[TEMP_ID_53]
			</destination_table>
			<shuffle_columns>
				State Province;
			</shuffle_columns>
		</dsql_operation>
		<dsql_operation operation_type="RETURN">
			<location distribution="AllDistributions" />
			<select>
				SELECT [T1_1].[State Province] AS [State Province], [T1_1].[col] AS [col] FROM (SELECT TOP (CAST ((1000001) AS BIGINT)) SUM([T2_1].[col]) AS [col], [T2_1].[State Province] AS [State Province] FROM [qtabledb].[dbo].[TEMP_ID_53] AS T2_1 GROUP BY [T2_1].[State Province]) AS T1_1  OPTION (MAXDOP 1, MIN_GRANT_PERCENT = [MIN_GRANT])
			</select>
		</dsql_operation>
		<dsql_operation operation_type="ON">
			<location permanent="false" distribution="AllDistributions" />
			<sql_operations>
				<sql_operation type="statement">
					DROP TABLE [qtabledb].[dbo].[TEMP_ID_53]
				</sql_operation>
			</sql_operations>
		</dsql_operation>
	</dsql_operations>
</dsql_query>
*//