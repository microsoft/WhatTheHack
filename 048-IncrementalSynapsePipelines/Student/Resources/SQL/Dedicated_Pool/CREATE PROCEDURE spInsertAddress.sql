IF OBJECT_ID ( 'SalesLT.spInsertAddress', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spInsertAddress;
GO

CREATE PROCEDURE SalesLT.spInsertAddress

AS
BEGIN
    SET NOCOUNT ON;
    INSERT SalesLT.Address
        (
            AddressID
            , AddressLine1
            , AddressLine2
            , City
            , StateProvince
            , CountryRegion
            , PostalCode
            , rowguid
            , ModifiedDate
        )

    SELECT
            AddressID
            , AddressLine1
            , AddressLine2
            , City
            , StateProvince
            , CountryRegion
            , PostalCode
            , rowguid
            , ModifiedDate

    from Staging.Address S1
    where NOT EXISTS (SELECT AddressID FROM SalesLT.Address S2 WHERE S2.AddressID = S1.AddressID)
    and S1.__$operation = 2
;
END;
GO