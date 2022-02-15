IF OBJECT_ID ( 'SalesLT.spDeleteAddress', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spDeleteAddress;
GO

CREATE PROCEDURE SalesLT.spDeleteAddress

AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM S2
    FROM SalesLT.Address S2
        INNER JOIN [Staging].[Address] S1
            ON S2.AddressID = S1.AddressID
        Where S2.AddressID = S1.AddressID
        and S1.__$operation = 1

;
END;
GO