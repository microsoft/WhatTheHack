select AddressID, AddressLine1, CountryRegion from SalesLT.Address order by AddressID DESC

select COUNT(*) as Rows from SalesLT.Address

select MAX(AddressID) from SalesLT.Address



select CustomerID, firstname, lastname, Phone from SalesLT.Customer order by CustomerID DESC

select COUNT(*) as Rows from SalesLT.Customer

select MAX(CustomerID) from SalesLT.Customer


select * from SalesLT.CustomerAddress order by CustomerID DESC


Select C.CustomerID, C.firstname, C.lastname, C.phone, C.companyname, A.AddressLine1, A. City, A.StateProvince, A.Postalcode, A.CountryRegion
From SalesLT.Customer C 
inner join SalesLT.CustomerAddress CA on C.CustomerID=Ca.CustomerID
inner join SalesLT.Address A on CA.AddressID=A.AddressID
order by C.customerID DESC