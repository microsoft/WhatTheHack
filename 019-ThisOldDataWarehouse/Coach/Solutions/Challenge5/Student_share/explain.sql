-- Run Explain Plan and copy results into VS Code.  Format XML Code to review results.  Execute each combination of Dimension.[Stock Item] based on different distribution and index options.
-- Recommend to your coach which option is the best one for Azure Synapse.  Test out for other Dimension tables for consistency and update accordingly.
-- Experiment will help you understand the optimal distribution key to prevent unnecessary shuffles.
-- Query is from Power BI Report on the "High Level Dashboard" Page and click on "Total Quantity by STock Item".  If you open up the Performance analyzer and "Copy query" for this table you will be able to capture SQL Statement
-- Delete all DAX components and just keep the SQL Syntax

EXPLAIN WITH_RECOMMENDATIONS(
SELECT 
TOP (1000001) [t5].[Stock Item],SUM(
CAST([t0].[Quantity] as BIGINT)
)
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

(select [$Table].[Stock Item Key] as [Stock Item Key],
    [$Table].[WWI Stock Item ID] as [WWI Stock Item ID],
    [$Table].[Stock Item] as [Stock Item],
    [$Table].[Color] as [Color],
    [$Table].[Selling Package] as [Selling Package],
    [$Table].[Buying Package] as [Buying Package],
    [$Table].[Brand] as [Brand],
    [$Table].[Size] as [Size],
    [$Table].[Lead Time Days] as [Lead Time Days],
    [$Table].[Quantity Per Outer] as [Quantity Per Outer],
    [$Table].[Is Chiller Stock] as [Is Chiller Stock],
    [$Table].[Barcode] as [Barcode],
    [$Table].[Tax Rate] as [Tax Rate],
    [$Table].[Unit Price] as [Unit Price],
    [$Table].[Recommended Retail Price] as [Recommended Retail Price],
    [$Table].[Typical Weight Per Unit] as [Typical Weight Per Unit],
    [$Table].[Photo] as [Photo],
    [$Table].[Valid From] as [Valid From],
    [$Table].[Valid To] as [Valid To],
    [$Table].[Lineage Key] as [Lineage Key]
from [Dimension].[Stock Item] as [$Table]) AS [t5] on 
(
[t0].[Stock Item Key] = [t5].[Stock Item Key]
)
)

WHERE 
(
([t1].[Invoice Date] < CAST( '20200603 00:00:00' AS datetime))
 AND 
([t1].[Invoice Date] >= CAST( '20100603 00:00:00' AS datetime))
)

GROUP BY [t5].[Stock Item] 
)