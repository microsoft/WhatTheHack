IF OBJECT_ID ( 'SalesLT.spDeleteCustomer', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spDeleteCustomer;
GO

CREATE PROCEDURE SalesLT.spDeleteCustomer

AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM S2
    FROM SalesLT.Customer S2
    INNER JOIN [Staging].[Customer] S1
        ON S2.CustomerID = S1.CustomerID
    Where S2.CustomerID = S1.CustomerID
    and S1.__$operation = 1

;
END;
GO