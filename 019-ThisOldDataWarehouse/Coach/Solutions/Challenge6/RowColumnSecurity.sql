//Column Based Security Challenge
GRANT SELECT ON Fact.Sale([Sale Key]
      ,[City Key]
      ,[Customer Key]
      ,[Bill To Customer Key]
      ,[Stock Item Key]
      ,[Invoice Date Key]
      ,[Delivery Date Key]
      ,[Salesperson Key]
      ,[WWI Invoice ID]
      ,[Description]
      ,[Package]
      ,[Quantity]
      ,[Unit Price]
      ,[Tax Rate]
      ,[Total Excluding Tax]
      ,[Tax Amount]
      ,[Total Including Tax]
      ,[Total Dry Items]
      ,[Total Chiller Items]
      ,[Lineage Key]) TO WWIConsultantNJ,WWIConsultantAL;
	  
	  

//Row Based Security Challenge
//Lookup appropriate city keys in the dimension.city table  
CREATE SCHEMA Secure;  
GO 

create function secure.geo(@citykey as bigint)
returns table
with schemabinding
as 
return (
    select condition = 1
    WHERE
    (SUSER_SNAME() = 'WWIConsultantNJ' AND @citykey in(38443,xxxx,xxxx,xxxx))
	OR 
	(SUSER_SNAME() = 'WWIConsultantAL' AND @citykey in(65854,xxxx,xxxx,xxxx))
	OR
	(SUSER_SNAME() = 'sqlauditadmin')
)

Create SECURITY POLICY GeoFilter  
ADD FILTER PREDICATE secure.geo([City Key])
ON Fact.Sale
WITH (STATE = ON);  
GO