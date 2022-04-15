IF OBJECT_ID ( 'SalesLT.spInsertCustomer', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spInsertCustomer;
GO

CREATE PROCEDURE SalesLT.spInsertCustomer

AS
BEGIN
    SET NOCOUNT ON;
    INSERT SalesLT.Customer
        (
            CustomerID
            , NameStyle
            , Title
            , FirstName
            , MiddleName
            , LastName
            , Suffix
            , CompanyName
            , SalesPerson
            , EmailAddress
            , Phone
            , PasswordHash
            , PasswordSalt
            , rowguid
            , ModifiedDate
        )

    SELECT
            CustomerID
            , NameStyle
            , Title
            , FirstName
            , MiddleName
            , LastName
            , Suffix
            , CompanyName
            , SalesPerson
            , EmailAddress
            , Phone
            , PasswordHash
            , PasswordSalt
            , rowguid
            , ModifiedDate
            
    from Staging.Customer S1
    where NOT EXISTS (SELECT CustomerID FROM SalesLT.Customer S2 WHERE S2.CustomerID = S1.CustomerID)
    and S1.__$operation = 2

;
END;
GO