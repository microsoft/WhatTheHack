/****************************************************************************************
--Why this update never completes even if writings are not overlapping ?
--Is it blocked by one other transaction ?
--If yes could you identify the blocker and why ?
--What type of lock does it need ?

--Tips:
--Investigate locking behavior
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
STOP1 - Run this update and explain its behavior
****************************************************************************************/

DECLARE @c SMALLINT
DECLARE @t SMALLINT

SELECT @c = (SELECT COUNT(*) FROM Sales.DimCurrency) 


UPDATE Sales.FactInternetSales SET CurrencyKey = ABS(CHECKSUM(NEWID())) % @c + 1
WHERE OrderDateKey >=20210101 AND OrderDateKey <= 20210630
OPTION (LABEL = 'Transaction 2 - Update - OrderDateKey >=20210101 AND OrderDateKey <= 20210630')
GO



/****************************************************************************************
STEP2 -OPEN a new query and execute below steps
	-Check if the UPDATE command is running or not
	-Explain the [status], what does suspended means ?
****************************************************************************************/

SELECT * FROM sys.dm_pdw_exec_requests WHERE [LABEL] = 'Transaction 2 - Update - OrderDateKey >=20210101 AND OrderDateKey <= 20210630'
GO

/****************************************************************************************
STEP3 - Why the update is blocked ?
****************************************************************************************/
SELECT * FROM sys.dm_pdw_waits WHERE request_id = 'request_id'
GO

/****************************************************************************************
STEP4 -  Who is blocking me and why ?
		check this: https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/who-is-blocking-me/ba-p/1431932
		- Would this behavior happen with SELECT commands also involving same table ?
		- Would you explain why ?
		- What you can do to let the blocked UPDATE to complete ?
		(KILL/COMMIT/ROLLBACK)
		- Can you test it ?
		- Data used by transacions do not overlap, What about the lock type ?
****************************************************************************************/


