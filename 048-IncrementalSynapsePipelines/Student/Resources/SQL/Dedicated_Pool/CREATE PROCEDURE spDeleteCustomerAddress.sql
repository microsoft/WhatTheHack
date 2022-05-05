IF OBJECT_ID ( 'SalesLT.spDeleteCustomerAddress', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spDeleteCustomerAddress;
GO

CREATE PROCEDURE SalesLT.spDeleteCustomerAddress

AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM S2
    FROM SalesLT.CustomerAddress S2
    INNER JOIN [Staging].[CustomerAddress] S1
        ON S2.CustomerID = S1.CustomerID
        AND S2.AddressID = S1.AddressID
    Where S2.CustomerID = S1.CustomerID
    and S2.AddressID = S1.AddressID
    and S1.__$operation = 1
;
END;
GO