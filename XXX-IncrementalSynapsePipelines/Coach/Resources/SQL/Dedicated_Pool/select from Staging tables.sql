select * from Staging.Address order by AddressID DESC

select * from Staging.Customer order by CustomerID DESC

select * from Staging.CustomerAddress order by CustomerID DESC

--delete from Staging.CustomerAddress where __$operation = 4