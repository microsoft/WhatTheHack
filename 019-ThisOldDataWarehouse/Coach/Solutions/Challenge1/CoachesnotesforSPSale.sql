CREATE PROCEDURE [Integration].[MigrateStagedSaleData] 

/* Part 0 - remove execute as owner Not supported in Azure Synapse Analytics */ 

--WITH EXECUTE AS OWNER 

AS 

BEGIN 

    SET NOCOUNT ON; 

    SET XACT_ABORT ON; 

 

    BEGIN TRAN; 

 

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key] 

                               FROM Integration.Lineage 

                               WHERE [Table Name] = N'Sale' 

                               AND [Data Load Completed] IS NULL 

                               ORDER BY [Lineage Key] DESC); 

 

/* Part 1 - 

    -- Find the dimension keys required for foreign key to support joins between Fact and Dimension tables

-- Required Fix - From clause on update with an alias doesn't work.  Table can be referred on the update line. 

*/ 

    /* 

UPDATE s 

        SET s.[City Key] = COALESCE((SELECT TOP(1) c.[City Key] 

                                     FROM Dimension.City AS c 

                                     WHERE c.[WWI City ID] = s.[WWI City ID] 

                                     AND s.[Last Modified When] > c.[Valid From] 

                                     AND s.[Last Modified When] <= c.[Valid To] 

 ORDER BY c.[Valid From]), 0), 

            s.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key] 

                                           FROM Dimension.Customer AS c 

                                           WHERE c.[WWI Customer ID] = s.[WWI Customer ID] 

                                           AND s.[Last Modified When] > c.[Valid From] 

                                           AND s.[Last Modified When] <= c.[Valid To] 

       ORDER BY c.[Valid From]), 0), 

            s.[Bill To Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key] 

                                                 FROM Dimension.Customer AS c 

                                                 WHERE c.[WWI Customer ID] = s.[WWI Bill To Customer ID] 

                                                 AND s.[Last Modified When] > c.[Valid From] 

                                                 AND s.[Last Modified When] <= c.[Valid To] 

             ORDER BY c.[Valid From]), 0), 

            s.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key] 

                                           FROM Dimension.[Stock Item] AS si 

                                           WHERE si.[WWI Stock Item ID] = s.[WWI Stock Item ID] 

                                           AND s.[Last Modified When] > si.[Valid From] 

                                           AND s.[Last Modified When] <= si.[Valid To] 

       ORDER BY si.[Valid From]), 0), 

            s.[Salesperson Key] = COALESCE((SELECT TOP(1) e.[Employee Key] 

                                            FROM Dimension.Employee AS e 

                                            WHERE e.[WWI Employee ID] = s.[WWI Salesperson ID] 

                                            AND s.[Last Modified When] > e.[Valid From] 

                                            AND s.[Last Modified When] <= e.[Valid To] 

        ORDER BY e.[Valid From]), 0) 

    FROM Integration.Sale_Staging AS s; 

*/ 

UPDATE Integration.Sale_Staging 

        SET [City Key] = COALESCE((SELECT TOP(1) c.[City Key] 

                                     FROM Dimension.City AS c 

                                     WHERE c.[WWI City ID] = Integration.Sale_Staging.[WWI City ID] 

                                     AND Integration.Sale_Staging.[Last Modified When] > c.[Valid From] 

                                     AND Integration.Sale_Staging.[Last Modified When] <= c.[Valid To] 

 ORDER BY c.[Valid From]), 0), 

            [Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key] 

                                           FROM Dimension.Customer AS c 

                                           WHERE c.[WWI Customer ID] = Integration.Sale_Staging.[WWI Customer ID] 

                                           AND Integration.Sale_Staging.[Last Modified When] > c.[Valid From] 

                                           AND Integration.Sale_Staging.[Last Modified When] <= c.[Valid To] 

       ORDER BY c.[Valid From]), 0), 

            [Bill To Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key] 

                                                 FROM Dimension.Customer AS c 

                                                 WHERE c.[WWI Customer ID] = Integration.Sale_Staging.[WWI Bill To Customer ID] 

                                                 AND Integration.Sale_Staging.[Last Modified When] > c.[Valid From] 

                                                 AND Integration.Sale_Staging.[Last Modified When] <= c.[Valid To] 

             ORDER BY c.[Valid From]), 0), 

            [Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key] 

                                           FROM Dimension.[Stock Item] AS si 

                                           WHERE si.[WWI Stock Item ID] = Integration.Sale_Staging.[WWI Stock Item ID] 

                                           AND Integration.Sale_Staging.[Last Modified When] > si.[Valid From] 

                                           AND Integration.Sale_Staging.[Last Modified When] <= si.[Valid To] 

       ORDER BY si.[Valid From]), 0), 

            [Salesperson Key] = COALESCE((SELECT TOP(1) e.[Employee Key] 

                                            FROM Dimension.Employee AS e 

                                            WHERE e.[WWI Employee ID] = Integration.Sale_Staging.[WWI Salesperson ID] 

                                            AND Integration.Sale_Staging.[Last Modified When] > e.[Valid From] 

                                            AND Integration.Sale_Staging.[Last Modified When] <= e.[Valid To] 

        ORDER BY e.[Valid From]), 0) 

 

/* Part 2 -  

    -- Remove any existing entries for any of these invoices 

-- Required fix.   Alias on Fact.Sale doesn't work. 

*/ 

/* 

    DELETE s 

    FROM Fact.Sale AS s 

    WHERE s.[WWI Invoice ID] IN (SELECT [WWI Invoice ID] FROM Integration.Sale_Staging); 

*/ 

DELETE 

    FROM Fact.Sale 

    WHERE [WWI Invoice ID] IN (SELECT [WWI Invoice ID] FROM Integration.Sale_Staging); 

     

/* Part 3 - 

-- Insert all current details for these invoices 

-- No changes necessary 

*/ 

    INSERT Fact.Sale 

        ([City Key], [Customer Key], [Bill To Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key], 

         [Salesperson Key], [WWI Invoice ID], [Description], Package, Quantity, [Unit Price], [Tax Rate], 

         [Total Excluding Tax], [Tax Amount], Profit, [Total Including Tax], [Total Dry Items], [Total Chiller Items], [Lineage Key]) 

    SELECT [City Key], [Customer Key], [Bill To Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key], 

           [Salesperson Key], [WWI Invoice ID], [Description], Package, Quantity, [Unit Price], [Tax Rate], 

           [Total Excluding Tax], [Tax Amount], Profit, [Total Including Tax], [Total Dry Items], [Total Chiller Items], @LineageKey 

    FROM Integration.Sale_Staging; 

 

    UPDATE Integration.Lineage 

        SET [Data Load Completed] = SYSDATETIME(), 

            [Was Successful] = 1 

    WHERE [Lineage Key] = @LineageKey; 

 

/* Part 4  

   - Set cutoff date/time 

   - remove from clause 

*/ 

    UPDATE Integration.[ETL Cutoff] 

        SET [Cutoff Time] = (SELECT [Source System Cutoff Time] 

                             FROM Integration.Lineage 

                             WHERE [Lineage Key] = @LineageKey) 

    --FROM Integration.[ETL Cutoff] 

    WHERE [Table Name] = N'Sale'; 

 

    COMMIT; 

/* Part 5 

   -Remove return statement 

*/ 

    --RETURN 0; 

END; 

GO 