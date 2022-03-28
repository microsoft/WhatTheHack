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

DECLARE @c SMALLINT
DECLARE @t SMALLINT

SELECT @c = (SELECT COUNT(*) FROM Sales.DimCurrency) 


UPDATE Sales.FactInternetSales SET CurrencyKey = ABS(CHECKSUM(NEWID())) % @c + 1
WHERE OrderDateKey >=20210101 AND OrderDateKey <= 20210630
OPTION (LABEL= 'Update - Tentative')
GO

--Run code below using another session
SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Update - Tentative'
SELECT * FROM sys.dm_pdw_waits WHERE session_id = 'SID19156'
GO


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

KILL 'Blocking or Blocked session_id'
GO


SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Update - Tentative'
SELECT * FROM sys.dm_pdw_waits WHERE session_id = 'SID586'
GO