/*****************************************************************************************************************************
What the hack - Serverless - Monitoring
CHALLENGE 05 - Excercise 01 
--While you run the smaall queries script, take sometime to analize the group of DMVs results so you can get more information about the current status of running queries on serverless
	--https://github.com/JocaPC/qpi/blob/master/src/qpi.sql
	--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-statistics
	--https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/best-practices-serverless-sql-pool
Contributors: Liliam Leme - Luca Ferrari

*****************************************************************************************************************************/
USE Serverless
GO
/****************************************************************************************
--STEP 1 of 7
--1) Which stats was created by the database for which table. Which ones were created manually?
****************************************************************************************/


	SELECT
        sm.[name]                           AS [schema_name]
,       tb.[name]                           AS [table_name]
,       st.[name]                           AS [stats_name]
,       st.[filter_definition]              AS [stats_filter_definition]
,       st.[has_filter]                     AS [stats_is_filtered]
,       STATS_DATE(st.[object_id],st.[stats_id])
                                            AS [stats_last_updated_date]
,       co.[name]                           AS [stats_column_name]
,       ty.[name]                           AS [column_type]
,       co.[max_length]                     AS [column_max_length]
,       co.[precision]                      AS [column_precision]
,       co.[scale]                          AS [column_scale]
,       co.[is_nullable]                    AS [column_is_nullable]
,       co.[collation_name]                 AS [column_collation_name]
,       QUOTENAME(sm.[name])+'.'+QUOTENAME(tb.[name])
                                            AS two_part_name
,       QUOTENAME(DB_NAME())+'.'+QUOTENAME(sm.[name])+'.'+QUOTENAME(tb.[name])
                                            AS three_part_name,
		st.[user_created] ------------------------------------------------------------->1 means it was user created
		FROM    sys.objects                         AS ob
		JOIN    sys.stats           AS st ON    ob.[object_id]      = st.[object_id]
		JOIN    sys.stats_columns   AS sc ON    st.[stats_id]       = sc.[stats_id]
									AND         st.[object_id]      = sc.[object_id]
		JOIN    sys.columns         AS co ON    sc.[column_id]      = co.[column_id]
									AND         sc.[object_id]      = co.[object_id]
		JOIN    sys.types           AS ty ON    co.[user_type_id]   = ty.[user_type_id]
		JOIN    sys.tables          AS tb ON    co.[object_id]      = tb.[object_id]
		JOIN    sys.schemas         AS sm ON    tb.[schema_id]      = sm.[schema_id]
		--WHERE   st.[user_created] = 1


/****************************************************************************************
--STEP 2 of 7
---2) how many active actions do I have open per database?
****************************************************************************************/

Select     
    DB_NAME(s.database_id) as DBName, 
    COUNT(s.database_id) as NumberOfConnections,
    nt_user_name as username, 
    login_name as LoginName,
    program_name as ApplicationName 
FROM 
    sys.dm_exec_requests req
    JOIN sys.dm_exec_sessions s ON req.session_id = s.session_id
GROUP BY 
    s.database_id, nt_user_name, login_name, program_name

	
/****************************************************************************************
--STEP 3 of 7
--3) Requests and Sessions
--how many requests are active running?
****************************************************************************************/

Select     
    DB_NAME(s.database_id) as DBName, 
    s.nt_user_name as username, 
    s.login_name as LoginName,
    s.program_name as ApplicationName,
	req.start_time as Starttime_request,
	req.status as request_status,
	req.session_id,
	req.command,
	req.connection_id,
	req.wait_type,
	req.wait_time,
	req.blocking_session_id,
	req.transaction_id,
	req.reads,
	req.writes,
	req.logical_reads,
	req.row_count,
	req.granted_query_memory,
	req.dist_statement_id,
	s.login_time,
	s.host_name,
	s.program_name,
	s.host_process_id,
	s.client_version,
	s.client_interface_name,
	s.cpu_time,
	s.memory_usage,
	s.total_scheduled_time,
	s.total_elapsed_time,
	s.original_login_name	 
FROM 
    sys.dm_exec_requests req
    JOIN sys.dm_exec_sessions s ON req.session_id = s.session_id
	WHERE req.status<> 'background' 
	AND req.command <>'TASK MANAGER'

/****************************************************************************************
--STEP 4 of 7
--4) Open sessions per program, database
--how many session are open by program?
****************************************************************************************/

select
    DB_NAME(database_id) as DBName, 
    nt_user_name as username, 
    login_name as LoginName,
    program_name as ApplicationName,
	host_name,
	program_name,
	COUNT(*) AS NB_Connections
from sys.dm_exec_sessions
GROUP BY DB_NAME(database_id) , 
    nt_user_name , 
    login_name ,
    program_name ,
	host_name,
	program_name

/****************************************************************************************
--STEP 5 of 7
--5)  Looking into more details to the requests and query execution:
--what are about the requests running? which one consumes more or less resource?
****************************************************************************************/


SELECT 
		req.session_id, req.blocking_session_id AS 'blocked', 
		req.database_id AS db_id, req.command, 
		req.total_elapsed_time AS 'elapsed_time', req.cpu_time, req.granted_query_memory AS 'granted_memory', req.logical_reads, 
		req.wait_time, CAST(req.wait_type AS VARCHAR(16)) AS 'wait_type', 
		req.open_transaction_count AS 'tran_count', 
		req.reads, req.writes,  
		req.start_time, req.status, req.connection_id, req.user_id, 
		req.group_id, -- KATMAI (SQL2008)
		req.transaction_id, req.request_id, 
		CAST(req.plan_handle AS VARBINARY(26)) AS 'plan_handle', 
		CAST(req.sql_handle AS VARBINARY(26)) AS 'sql_handle', 
		req.nest_level,
		req.statement_start_offset AS 'stmt_start', req.statement_end_offset AS 'stmt_end', 
		req.query_hash, req.query_plan_hash
	FROM sys.dm_exec_requests req
	WHERE session_id<>@@SPID 
	and status<> 'background' and command <>'TASK MANAGER'

/****************************************************************************************
--STEP 6 of 7
--6)  Looking the history execution
	--ordeing by data processed
****************************************************************************************/

SELECT  * 
FROM sys.dm_exec_requests_history req where transaction_ID = 23022567
Order by data_processed_mb desc
--Order by total_elapsed_time_ms desc --ordering by execution time



---Note transaction_ID column from dm_exec_requests_history has the the same as request_id you will find under Synapse studio -> monitoring-> SQL requests

/****************************************************************************************
--STEP 7 of 7
--7)  Query active on the query store:
	1) --Which queries are the most resource intensive? whih query is the one that takes longer time to execute?
	--https://github.com/JocaPC/qpi/blob/master/src/qpi.sql ( source)	
****************************************************************************************/


SELECT
	  IIF(LEFT(text,1) = '(', TRIM(')' FROM SUBSTRING( text, (PATINDEX( '%)[^),]%', text))+1, LEN(text))), text) ,
		 IIF(LEFT(text,1) = '(', SUBSTRING( text, 2, (PATINDEX( '%)[^),]%', text+')'))-2), '') ,
		execution_type_desc = status COLLATE Latin1_General_CS_AS,
		first_execution_time = start_time, last_execution_time = NULL, count_executions = NULL,
		elapsed_time_s = total_elapsed_time /1000.0,
		cpu_time_s = cpu_time /1000.0,
		logical_io_reads = logical_reads,
		logical_io_writes = writes,
		physical_io_reads = reads,
		num_physical_io_reads = NULL,
		clr_time = NULL,
		--dop,
		--row_count,
		memory_mb = granted_query_memory *8 /1000,
		log_bytes = NULL,
		tempdb_space = NULL,
		query_text_id = NULL, query_id = NULL, plan_id = NULL,
		database_id, connection_id, session_id, request_id, command,
		interval_mi = null,
		start_time,
		end_time = null,
		sql_handle
FROM    sys.dm_exec_requests
		CROSS APPLY sys.dm_exec_sql_text(sql_handle)
