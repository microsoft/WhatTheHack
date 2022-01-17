IF OBJECT_ID ( 'SalesLT.spUpdateCustomer', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spUpdateCustomer;
GO

CREATE PROCEDURE SalesLT.spUpdateCustomer

AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SalesLT.Customer
        SET
            NameStyle = S1.NameStyle
            , Title = S1.Title
            , FirstName = S1.FirstName
            , MiddleName = S1.MiddleName
            , LastName = S1.LastName
            , Suffix = S1.Suffix
            , CompanyName = S1.CompanyName
            , SalesPerson = S1.SalesPerson
            , EmailAddress = S1.EmailAddress
            , Phone = S1.Phone
            , PasswordHash= S1.PasswordHash
            , PasswordSalt = S1.PasswordSalt
            , rowguid = S1.rowguid
            , ModifiedDate = S1.ModifiedDate
            
        from Staging.Customer S1
        where [SalesLT].[Customer].CustomerID = S1.CustomerID
        and S1.__$operation = 4
        and S1.tran_begin_time = (
                                    select MAX(s2.tran_begin_time) 
                                    from Staging.Customer s2 
                                    where s2.Customerid=s1.Customerid and S2.__$operation in (4)
                                )
                                
;
END;
GO