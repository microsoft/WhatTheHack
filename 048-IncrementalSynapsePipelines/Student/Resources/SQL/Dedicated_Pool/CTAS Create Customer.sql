--Step 1 - Create secondary table to copy records
CREATE TABLE SalesLT.Customer2  
WITH   
  (   
    CLUSTERED COLUMNSTORE INDEX,  
    DISTRIBUTION = ROUND_ROBIN   
  )  
AS SELECT * FROM SalesLT.Customer

--Step 2 - Drop Primart table
--DROP TABLE SalesLT.Customer

--Step 3 - Create Primary table with Hash Distribution
CREATE TABLE SalesLT.Customer  
WITH   
  (   
    CLUSTERED COLUMNSTORE INDEX,  
    DISTRIBUTION = HASH(CustomerID) 
  )  
AS SELECT * FROM SalesLT.Customer2

--Step 4 - Drop Secondary table
--DROP TABLE SalesLT.Customer2


Select * from SalesLT.Customer order by CustomerID DESC  