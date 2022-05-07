/****************************************************************************************
--Why this update never completes even if writings are not overlapping ?
--Is it blocked by one other transaction ?
--If yes could you identify the blocker and why ?
--What type of lock does it need ?

--Tips:
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transactions-sql-data-warehouse?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transactions-sql-data-warehouse?view=aps-pdw-2016-au7#locking-behavior
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-transactions
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-develop-best-practices-transactions
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-waits-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-sessions-transact-sql?view=aps-pdw-2016-au7
https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/who-is-blocking-me/ba-p/1431932
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/kill-transact-sql?view=sql-server-ver15

****************************************************************************************/

/****************************************************************************************
STEP 1 of 5 - This command should never complete
Run this update after you run C3_A_Simulate_Writings.ps1 powershell script and wait for it to complete.
It will update Sales.FactInternetSales and will use an exclusive lock on the table. 
This will prevent further writings against the table.

All Azure Synapse Analytics locks are table level or higher
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transactions-sql-data-warehouse?view=aps-pdw-2016-au7

****************************************************************************************/

DECLARE @c SMALLINT
DECLARE @t SMALLINT

SELECT @c = (SELECT COUNT(*) FROM Sales.DimCurrency) 

UPDATE Sales.FactInternetSales SET CurrencyKey = ABS(CHECKSUM(NEWID())) % @c + 1
WHERE OrderDateKey >=20210101 AND OrderDateKey <= 20210630
OPTION (LABEL= 'Update - Tentative')
GO

/****************************************************************************************
STEP 2 of 5 - its status should be "Suspended" since it is waiting for its lock
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-pdw-exec-requests-transact-sql?view=aps-pdw-2016-au7#:~:text=An%20attacker%20can%20use%20sys.dm_pdw_exec_requests%20to%20retrieve%20information,STATE%20permission%20and%20by%20not%20having%20database-specific%20permission.

--Run code below using another session
****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Update - Tentative'
SELECT * FROM sys.dm_pdw_waits WHERE session_id = 'session_id'
GO

/****************************************************************************************
STEP 3 of 5 - Using DMVs you can identify blocked and blocking sessions.

https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/who-is-blocking-me/ba-p/1431932

Then you can decide to kill the blocker or the blocked or to let them naturally complete.
In this example it will never complete, Ps1 script doesn't contain the proper Commit\Rollback transaction

****************************************************************************************/

WITH blocked_sessions (login_name, blocked_session, state, type, command, object)
AS
(
SELECT 
    sessions.login_name,
    blocked.session_id as blocked_session, 
    blocked.state , 
    blocked.type,
    requests.command,
    blocked.object_name
    FROM sys.dm_pdw_waits blocked
    JOIN sys.dm_pdw_exec_requests requests
        ON blocked.request_id = requests.request_id
    JOIN sys.dm_pdw_exec_sessions sessions
        ON blocked.session_id = sessions.session_id
    WHERE blocked.state <> 'Granted'
    )
--merging with blocking session info
SELECT 
    blocked_sessions.login_name as blocked_user,
    blocked_sessions.blocked_session as blocked_session,
    blocked_sessions.state as blocked_state,
    blocked_sessions.type as blocked_type,
    blocked_sessions.command as blocked_command,
    sessions.login_name as blocking_user,
    blocking.session_id as blocking_session, 
    blocking.state as blocking_state, 
    blocking.type as blocking_type,
    requests.command as blocking_command
    FROM sys.dm_pdw_waits blocking
    JOIN blocked_sessions 
        ON blocked_sessions.object = blocking.object_name
    JOIN sys.dm_pdw_exec_requests requests
        ON blocking.request_id = requests.request_id
    JOIN sys.dm_pdw_exec_sessions sessions
        ON blocking.session_id = sessions.session_id
    WHERE blocking.state = 'Granted'
GO


/****************************************************************************************
STEP 4 of 5 - Killing blocking sessionwill solve the issue.
Explain attendees they need to carefully decidewchich transaction they hva to kill.
Rolling back a very long transaction might heavilly affect the system due to T-Log reverse reading

****************************************************************************************/

KILL 'Blocking session_id'
GO

/****************************************************************************************
STEP 5 of 5 - Now blocked session should complete in few seconds
****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Update - Tentative'
SELECT * FROM sys.dm_pdw_waits WHERE session_id = 'session_id'
GO