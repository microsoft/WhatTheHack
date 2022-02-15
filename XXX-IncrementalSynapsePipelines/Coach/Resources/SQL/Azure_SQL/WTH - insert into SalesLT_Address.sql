 insert into [SalesLT].[Address] 
     (AddressLine1, City, StateProvince, CountryRegion, PostalCode, ModifiedDate) 
 values 
     ('5 Wayside Road', 'Burlington', 'MA', 'USA', '01803', GETDATE()),
     ('1 Cambridge Ctr', 'Cambridge', 'MA', 'USA', '02142', GETDATE()),
	 ('150 Trumbull St', 'Hartford', 'CT', 'USA', '06103', GETDATE())

--update [SalesLT].[Address] set AddressLine1 = '280 Trumbull St', ModifiedDate = GetDate() where Addressid = '11402'

--delete from [SalesLT].[Address] where Addressid > '11382'

select * from [SalesLT].[Address] order by AddressID DESC

select * from [cdc].[SalesLT_Address_CT] order by ModifiedDate DESC

--delete from [cdc].[SalesLT_Address_CT] where Addressid > '30123'

select * from cdc.lsn_time_mapping order by tran_begin_time DESC

select CDC.*, TM.tran_begin_time from [cdc].[SalesLT_Address_CT] CDC INNER JOIN [cdc].[lsn_time_mapping] TM on CDC.__$start_lsn = TM.start_lsn

select count(*) as changecount from [cdc].[SalesLT_Address_CT] CDC INNER JOIN [cdc].[lsn_time_mapping] TM on CDC.__$start_lsn = TM.start_lsn


SELECT sys.fn_cdc_get_min_lsn ('SalesLT_Address')AS min_lsn;


select MAX(TM.tran_begin_time) as NewWatermarkValue from [cdc].[SalesLT_Address_CT] 
CDC INNER JOIN [cdc].[lsn_time_mapping] TM on CDC.__$start_lsn = TM.start_lsn
 

---  USE SQL Statement instead to check for row count
select count(*) as changecount 
from [cdc].[SalesLT_Address_CT] CDC 
	INNER JOIN [cdc].[lsn_time_mapping] TM on CDC.__$start_lsn = TM.start_lsn
where tran_begin_time > '2021-10-22 00:00:00.000' 
 and tran_begin_time <= '2022-01-17 15:50:17.540'

---USE SQL Statement instead to check for row values
select CDC.*, TM.tran_begin_time 
from [cdc].[SalesLT_Address_CT] CDC 
	INNER JOIN [cdc].[lsn_time_mapping] TM on CDC.__$start_lsn = TM.start_lsn
where tran_begin_time > '2021-10-22 00:00:00.000' 
 and tran_begin_time <= '2022-01-17 15:50:17.540'

