 insert into [SalesLT].[CustomerAddress] 
     (CustomerID, AddressID, AddressType, ModifiedDate) 
 values 
     ('30130', '11386', 'Main Office', GETDATE()),
     ('30131', '11387', 'Main Office', GETDATE()),
	 ('30132', '11388', 'Main Office', GETDATE())


--delete from [SalesLT].[Address] where Addressid > '11382'

select * from [SalesLT].[Customer] order by CustomerID DESC

select * from [SalesLT].[Address] order by AddressID DESC

select * from [SalesLT].[CustomerAddress] order by ModifiedDate DESC

select * from [cdc].[SalesLT_CustomerAddress_CT] order by ModifiedDate DESC