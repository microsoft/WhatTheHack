-- DROP PROCEDURE [Integration].[MigrateStagedMovementData] 

CREATE PROCEDURE [Integration].[MigrateStagedMovementData] 

/* Part 0 - remove execute as owner. Not supported in Azure Synapse Analytics */ 

--WITH EXECUTE AS OWNER 

AS 

BEGIN 

    SET NOCOUNT ON; 

    SET XACT_ABORT ON; 

 

    BEGIN TRAN; 

 

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key] 

                               FROM Integration.Lineage 

                               WHERE [Table Name] = N'Movement' 

                               AND [Data Load Completed] IS NULL 

                               ORDER BY [Lineage Key] DESC); 

 

    -- Find the dimension keys required for foreign key to support joins between Fact and Dimension tables

/* Part 1 - Fix the update statement, from clause not supported, get rid of table aliases*/ 

/* 

    UPDATE m 

        SET m.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key] 

                                           FROM Dimension.[Stock Item] AS si 

                                           WHERE si.[WWI Stock Item ID] = m.[WWI Stock Item ID] 

                                           AND m.[Last Modifed When] > si.[Valid From] 

                                           AND m.[Last Modifed When] <= si.[Valid To] 

       ORDER BY si.[Valid From]), 0), 

            m.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key] 

                                         FROM Dimension.Customer AS c 

                                         WHERE c.[WWI Customer ID] = m.[WWI Customer ID] 

                                         AND m.[Last Modifed When] > c.[Valid From] 

                                         AND m.[Last Modifed When] <= c.[Valid To] 

     ORDER BY c.[Valid From]), 0), 

            m.[Supplier Key] = COALESCE((SELECT TOP(1) s.[Supplier Key] 

                                         FROM Dimension.Supplier AS s 

                                         WHERE s.[WWI Supplier ID] = m.[WWI Supplier ID] 

                                         AND m.[Last Modifed When] > s.[Valid From] 

                                         AND m.[Last Modifed When] <= s.[Valid To] 

     ORDER BY s.[Valid From]), 0), 

            m.[Transaction Type Key] = COALESCE((SELECT TOP(1) tt.[Transaction Type Key] 

                                                 FROM Dimension.[Transaction Type] AS tt 

                                                 WHERE tt.[WWI Transaction Type ID] = m.[WWI Transaction Type ID] 

                                                 AND m.[Last Modifed When] > tt.[Valid From] 

                                                 AND m.[Last Modifed When] <= tt.[Valid To] 

             ORDER BY tt.[Valid From]), 0) 

    FROM Integration.Movement_Staging AS m; 

*/ 

    UPDATE Integration.Movement_Staging 

        SET [Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key] 

                                           FROM Dimension.[Stock Item] AS si 

                                           WHERE si.[WWI Stock Item ID] = [WWI Stock Item ID] 

                                           AND [Last Modifed When] > si.[Valid From] 

                                           AND [Last Modifed When] <= si.[Valid To] 

       ORDER BY si.[Valid From]), 0), 

            [Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key] 

                                         FROM Dimension.Customer AS c 

                                         WHERE c.[WWI Customer ID] = [WWI Customer ID] 

                                         AND [Last Modifed When] > c.[Valid From] 

                                         AND [Last Modifed When] <= c.[Valid To] 

     ORDER BY c.[Valid From]), 0), 

            [Supplier Key] = COALESCE((SELECT TOP(1) s.[Supplier Key] 

                                         FROM Dimension.Supplier AS s 

                                         WHERE s.[WWI Supplier ID] = [WWI Supplier ID] 

                                         AND [Last Modifed When] > s.[Valid From] 

                                         AND [Last Modifed When] <= s.[Valid To] 

     ORDER BY s.[Valid From]), 0), 

            [Transaction Type Key] = COALESCE((SELECT TOP(1) tt.[Transaction Type Key] 

                                                 FROM Dimension.[Transaction Type] AS tt 

                                                 WHERE tt.[WWI Transaction Type ID] = [WWI Transaction Type ID] 

                                                 AND [Last Modifed When] > tt.[Valid From] 

                                                 AND [Last Modifed When] <= tt.[Valid To] 

             ORDER BY tt.[Valid From]), 0); 

 

/* Part 2- Refactor Merge statement */ 

/*  Merge the data into the fact table.   

The general guidance here would be to union all the updated rows with all the inserted rowas as a CTAS then drop the old table and rename the new table. 

This won't work because this table has a surrogate key that is auto populated, and CTAS will not preserve the identity column. 

The best way to acheive this is with an UPDATE followed by an INSERT. 

Keep in mind that UPDATE statements are finicky about JOIN clauses in SQL DW.  You need to join in the where clause. (Implicit join)

*/ 

/* 

    MERGE Fact.Movement AS m 

    USING Integration.Movement_Staging AS ms 

    ON m.[WWI Stock Item Transaction ID] = ms.[WWI Stock Item Transaction ID] 

    WHEN MATCHED THEN 

        UPDATE SET m.[Date Key] = ms.[Date Key], 

                   m.[Stock Item Key] = ms.[Stock Item Key], 

                   m.[Customer Key] = ms.[Customer Key], 

                   m.[Supplier Key] = ms.[Supplier Key], 

                   m.[Transaction Type Key] = ms.[Transaction Type Key], 

                   m.[WWI Invoice ID] = ms.[WWI Invoice ID], 

                   m.[WWI Purchase Order ID] = ms.[WWI Purchase Order ID], 

                   m.Quantity = ms.Quantity, 

                   m.[Lineage Key] = @LineageKey 

    WHEN NOT MATCHED THEN 

        INSERT ([Date Key], [Stock Item Key], [Customer Key], [Supplier Key], [Transaction Type Key], 

                [WWI Stock Item Transaction ID], [WWI Invoice ID], [WWI Purchase Order ID], Quantity, [Lineage Key]) 

        VALUES (ms.[Date Key], ms.[Stock Item Key], ms.[Customer Key], ms.[Supplier Key], ms.[Transaction Type Key], 

                ms.[WWI Stock Item Transaction ID], ms.[WWI Invoice ID], ms.[WWI Purchase Order ID], ms.Quantity, @LineageKey); 

*/ 

UPDATE	Fact.Movement 

SET	Fact.Movement.[Date Key] = ms.[Date Key], 

Fact.Movement.[Stock Item Key] = ms.[Stock Item Key], 

Fact.Movement.[Customer Key] = ms.[Customer Key], 

Fact.Movement.[Supplier Key] = ms.[Supplier Key], 

Fact.Movement.[Transaction Type Key] = ms.[Transaction Type Key], 

Fact.Movement.[WWI Invoice ID] = ms.[WWI Invoice ID], 

Fact.Movement.[WWI Purchase Order ID] = ms.[WWI Purchase Order ID], 

Fact.Movement.Quantity = ms.Quantity, 

Fact.Movement.[Lineage Key] = @LineageKey 

FROM	Integration.Movement_Staging AS ms 

WHERE	Fact.Movement.[WWI Stock Item Transaction ID] = ms.[WWI Stock Item Transaction ID] 

 

INSERT	Fact.Movement 

( 

[Date Key], 

[Stock Item Key], 

[Customer Key], 

[Supplier Key], 

[Transaction Type Key], 

[WWI Invoice ID], 

[WWI Purchase Order ID], 

Quantity, 

[Lineage Key] 

) 

SELECT	ms.[Date Key], 

ms.[Stock Item Key], 

ms.[Customer Key], 

ms.[Supplier Key], 

ms.[Transaction Type Key], 

ms.[WWI Invoice ID], 

ms.[WWI Purchase Order ID], 

ms.Quantity, 

@LineageKey as [Lineage Key] 

FROM Integration.Movement_Staging AS ms 

WHERE NOT EXISTS 

( 

SELECT * 

FROM Fact.Movement AS m 

WHERE m.[WWI Stock Item Transaction ID] = ms.[WWI Stock Item Transaction ID] 

) 

 

 

    UPDATE Integration.Lineage 

        SET [Data Load Completed] = SYSDATETIME(), 

            [Was Successful] = 1 

    WHERE [Lineage Key] = @LineageKey; 

 

/* Part 4 - remove from statement */ 

    UPDATE Integration.[ETL Cutoff] 

        SET [Cutoff Time] = (SELECT [Source System Cutoff Time] 

                             FROM Integration.Lineage 

                             WHERE [Lineage Key] = @LineageKey) 

    --FROM Integration.[ETL Cutoff] 

    WHERE [Table Name] = N'Movement'; 

 

    COMMIT; 

/* Part 5 - remove return statement */ 

    --RETURN 0; 

END; 

GO 