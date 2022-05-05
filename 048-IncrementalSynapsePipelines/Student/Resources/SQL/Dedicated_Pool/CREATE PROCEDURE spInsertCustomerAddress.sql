IF OBJECT_ID ( 'SalesLT.spInsertCustomerAddress', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spInsertCustomerAddress;
GO

CREATE PROCEDURE SalesLT.spInsertCustomerAddress

AS
BEGIN
    SET NOCOUNT ON;
    INSERT SalesLT.CustomerAddress
        (
            CustomerID
            , AddressID
            , AddressType
            , rowguid
            , ModifiedDate
        )

    SELECT
            CustomerID
            , AddressID
            , AddressType
            , rowguid
            , ModifiedDate
            
    from Staging.CustomerAddress S1
    where NOT EXISTS (SELECT CustomerID, AddressID FROM SalesLT.CustomerAddress S2 
                        WHERE S2.CustomerID = S1.CustomerID AND S2.AddressID = S1.AddressID)
    and S1.__$operation = 2

;
END;
GO