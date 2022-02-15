--Step 1 - Create secondary table to copy records
CREATE TABLE SalesLT.Address2  
WITH   
  (   
    CLUSTERED COLUMNSTORE INDEX,  
    DISTRIBUTION = ROUND_ROBIN   
  )  
AS SELECT * FROM SalesLT.Address

--Step 2 - Drop Primart table
--DROP TABLE SalesLT.Address

--Step 3 - Create Primary table with Hash Distribution
CREATE TABLE SalesLT.Address  
WITH   
  (   
    CLUSTERED COLUMNSTORE INDEX,  
    DISTRIBUTION = HASH(AddressID) 
  )  
AS SELECT * FROM SalesLT.Address2

--Step 4 - Drop Secondary table
--DROP TABLE SalesLT.Address2


Select * from SalesLT.Address order by AddressID DESC  


