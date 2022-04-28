IF OBJECT_ID ( 'SalesLT.spUpdateAddress', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spUpdateAddress;
GO

CREATE PROCEDURE SalesLT.spUpdateAddress

AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SalesLT.Address
        SET
            AddressID = S1.AddressID
            , AddressLine1 = S1.AddressLine1
            , AddressLine2 = S1.AddressLine2
            , City = S1.City
            , StateProvince = S1.StateProvince
            , CountryRegion = S1.CountryRegion
            , PostalCode = S1.PostalCode
            , rowguid = S1.rowguid
            , ModifiedDate = S1.ModifiedDate
            
        from Staging.Address S1
        where [SalesLT].[Address].AddressID = S1.AddressID
        and S1.__$operation = 4
        and S1.tran_begin_time = (
                                    select MAX(s2.tran_begin_time) 
                                    from Staging.Address s2 
                                    where s2.addressid=s1.addressid and S2.__$operation in (4)
                                )
;
END;
GO