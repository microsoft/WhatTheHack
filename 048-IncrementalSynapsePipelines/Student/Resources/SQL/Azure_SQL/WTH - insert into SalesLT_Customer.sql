 /*
 insert into [SalesLT].[Customer] 
     (firstname, lastname, emailaddress, phone, CompanyName, SalesPerson, ModifiedDate) 
 values 
     ('Nate', 'Gorham', 'nag@swiftcycles.com', '617-555-1212', 'Swift Cycles', 'adventure-works\jillian0', GETDATE()),
     ('Cindy', 'Smith', 'cs@swiftcycles.com', '617-555-1212', 'Swift Cycles', 'adventure-works\jillian0', GETDATE()),
     ('George', 'Bennett', 'gb@swiftcycles.com', '617-555-1212', 'Swift Cycles', 'adventure-works\jillian0', GETDATE())
*/

select * from [SalesLT].[Customer] order by CustomerID DESC

--update [SalesLT].[Customer] set Phone = '617-555-1234', ModifiedDate = GETDATE() where CustomerID = 30123

--delete from [SalesLT].[Customer] where CustomerID > 30123

select * from [cdc].[SalesLT_Customer_CT]

select * from [cdc].[change_tables]




SELECT sys.fn_cdc_get_min_lsn ('SalesLT_Customer')AS min_lsn;

SELECT * FROM [cdc].[fn_cdc_get_all_changes_SalesLT_Customer]


select MAX(TM.tran_begin_time) as NewWatermarkValue from [cdc].[SalesLT_Customer_CT] 
CDC INNER JOIN [cdc].[lsn_time_mapping] TM on CDC.__$start_lsn = TM.start_lsn
 

---  USE SQL Statement instead to check for row count
select count(*) as changecount 
from [cdc].[SalesLT_Customer_CT] CDC 
	INNER JOIN [cdc].[lsn_time_mapping] TM on CDC.__$start_lsn = TM.start_lsn
where tran_begin_time > '2021-10-22 00:00:00.000' 
 and tran_begin_time <= '2022-01-17 11:50:17.540'

---USE SQL Statement instead to check for row values
select CDC.*, TM.tran_begin_time 
from [cdc].[SalesLT_Customer_CT] CDC 
	INNER JOIN [cdc].[lsn_time_mapping] TM on CDC.__$start_lsn = TM.start_lsn
where tran_begin_time > '2021-10-22 00:00:00.000' 
 and tran_begin_time <= '2022-01-17 11:50:17.540'


---  USE Function
 /*
DECLARE  @from_lsn binary(10), @to_lsn binary(10), @begintime datetime, @endtime datetime;  
SET @from_lsn =sys.fn_cdc_get_min_lsn('SalesLT_Customer');  
--SET @from_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than',  '2021-10-22 00:00:00.000');
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', '2022-01-17 14:50:17.540');
SELECT count(1) changecount FROM [cdc].[fn_cdc_get_all_changes_SalesLT_Customer] (@from_lsn, @to_lsn, 'all')
*/

DECLARE  @from_lsn binary(10), @to_lsn binary(10);  
SET @from_lsn =sys.fn_cdc_get_min_lsn('SalesLT_Customer');  
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal',  '2022-01-17 14:50:17.540');
SELECT count(1) changecount FROM [cdc].[fn_cdc_get_all_changes_SalesLT_Customer] (@from_lsn, @to_lsn, 'all')


DECLARE @begin_time datetime, @end_time datetime, @from_lsn binary(10), @to_lsn binary(10), @difftime int;
SET @begin_time = '2021-10-22 00:00:00.000';
SET @end_time = '2022-01-17 11:50:17.540';
SET @difftime = DATEDIFF (hour, GETUTCDATE(), GETDATE());
SET @from_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @begin_time);
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);
SELECT * FROM [cdc].[fn_cdc_get_all_changes_SalesLT_Customer](@from_lsn, @to_lsn, 'all')

select DATEDIFF (hour, GETUTCDATE(), GETDATE());

