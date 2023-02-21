/*****************************************************************************************************************************
What the hack - Serverless - Monitoring
CHALLENGE 05 - Excercise 01 
---Creating the workload:
--While you run the smaall queries script, take sometime to analize the group of DMVs results so you can get more information about the current status of running queries on serverless
	--https://github.com/JocaPC/qpi/blob/master/src/qpi.sql
	--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics
	--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool
Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/
USE Serverless
GO
/****************************************************************************************
--STEP 1 of 1
--LOOP INCREASE 1 BY 1 UNTIL 1000 IN INTERVALS OF 5 SECONDS
--WHILE THIS RUN. LOOK THE MONITORING DMVS
****************************************************************************************/

DECLARE @COUNT AS INT = 0


WHILE @COUNT <> 1000

BEGIN 

	WAITFOR DELAY '00:00:05'

    SET @COUNT = @COUNT+1


    -- This is auto-generated code
    SELECT
    *
    FROM
        OPENROWSET(
            BULK 'https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolder/Delta/date_DW_Delta/*.parquet',
            FORMAT = 'PARQUET'
        ) AS [result]



        SELECT
        TOP 100 *
    FROM
        OPENROWSET(
            BULK 'https://YourStorageAccount.blob.core.windows.net/YourContainer/YourFolder/Delta/date_DW_Delta//DayName=Friday/part-00000-b6908105-1c3b-4084-84f3-e0c30083ef4f.c000.snappy.parquet',
            FORMAT = 'PARQUET'
        ) AS [result]




END

