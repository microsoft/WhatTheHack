--This code set is for educational purposes only.  Encourage students to use the scripts in /Scripts folder to create the stored procedures.  Feel free to share with students once they complete it but don't deploy these scripts into production.
--Post May 2020 only T_SQL incompatibilities are "EXECUTE AS OWNER" and "RETURN".

--DROP PROCEDURE [Integration].[MigrateStagedCityData] 

CREATE PROCEDURE [Integration].[MigrateStagedCityData] 

/* Part 0 - comment out execute as owner.  Not supported in Azure Synapse Analytics*/
--WITH EXECUTE AS OWNER 

AS 

BEGIN 

    SET NOCOUNT ON; 

    SET XACT_ABORT ON; 

 

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999'; 

 

    BEGIN TRAN; 

 

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key] 

                               FROM Integration.Lineage 

                               WHERE [Table Name] = N'City' 

                               AND [Data Load Completed] IS NULL 

                               ORDER BY [Lineage Key] DESC); 

 

/*  Part 1 - close off old records for Slowing Changing Dimensions Type II  

    There are two solutions
	1. CTAS 
	2. CTE with Column List (Recommended Solution for WTH)

*/ 

--Common Table expression [Original T-SQL Statement] 
--CTE supported after May 2020
--Updated Notes to include original T-SQL Statement
--Commented out old recommendations for reference
WITH RowsToCloseOff 

    AS 

    ( 

        SELECT c.[WWI City ID], MIN(c.[Valid From]) AS [Valid From] 

        FROM Integration.City_Staging AS c 

        GROUP BY c.[WWI City ID] 

    ) 

    UPDATE c 

        SET c.[Valid To] = rtco.[Valid From] 

    FROM Dimension.City AS c 

    INNER JOIN RowsToCloseOff AS rtco 

    ON c.[WWI City ID] = rtco.[WWI City ID] 

    WHERE c.[Valid To] = @EndOfTime; 
/*
-- Common Table Expression with column list (Previous workaround for WTH prior to May 2020)

WITH RowsToCloseOff([WWI City ID], [Valid From])
    AS
    (
        SELECT c.[WWI City ID], MIN(c.[Valid From]) AS [Valid From]
        FROM Integration.City_Staging AS c
        GROUP BY c.[WWI City ID]
    )
    UPDATE c
        SET c.[Valid To] = rtco.[Valid From]
    FROM Dimension.City AS c
    INNER JOIN RowsToCloseOff AS rtco
    ON c.[WWI City ID] = rtco.[WWI City ID]
    WHERE c.[Valid To] = @EndOfTime;
/*

--Create Table as Selet (CTAS) as a replacement for CTE (Alternative workaround for WTH prior to Mahy 2020)
/*

CREATE TABLE Integration.City_Staging_Temp 

WITH (DISTRIBUTION = REPLICATE) 

AS  

SELECT c.[WWI City ID], MIN(c.[Valid From]) AS [Valid From] 

    FROM Integration.City_Staging AS c 

    GROUP BY c.[WWI City ID] 

 */

 --ANSI JOINS were not supported in Synapse prior to May 2020.
 --Privous workaround were to replace with implicit join in the WHERE clause.
UPDATE Dimension.City 

SET c.[Valid To] = rtco.[Valid From] 

    FROM Integration.City_Staging_Temp AS rtco 

    WHERE c.[WWI City ID] = rtco.[WWI City ID]  

AND c.[Valid To] = @EndOfTime; 

/*  Part 2 - Insert dimension records to staging  

No changes 

*/ 

    INSERT Dimension.City 

        ([WWI City ID], City, [State Province], Country, Continent, 

         [Sales Territory], Region, Subregion, [Location], 

         [Latest Recorded Population], [Valid From], [Valid To], 

         [Lineage Key]) 

    SELECT [WWI City ID], City, [State Province], Country, Continent, 

           [Sales Territory], Region, Subregion, [Location], 

           [Latest Recorded Population], [Valid From], [Valid To], 

           @LineageKey 

    FROM Integration.City_Staging; 

 

 

--Part 3 - Update Load Control tables  

    UPDATE Integration.Lineage 

        SET [Data Load Completed] = SYSDATETIME(), 

            [Was Successful] = 1 

    WHERE [Lineage Key] = @LineageKey; 

 

 

    UPDATE 

        SET [Cutoff Time] = (SELECT TOP 1 [Source System Cutoff Time] 

                             FROM Integration.Lineage 

                             WHERE [Lineage Key] = @LineageKey) 

    FROM Integration.[ETL Cutoff] 

    WHERE [Table Name] = N'City' 

 

 

/* Step 4 - clean up the CTAS table   

   Added this statement to cleanup the CTAS table that was used instead of a CTE 

*/

/*
--Required if you use CTAS tables
DROP TABLE Integration.City_Staging_Temp 
*/
 

    COMMIT; 

 

/* Part 4 - comment out return statment, they're unsupported by Azure Synapse */ 

    --RETURN 0 

 

END 