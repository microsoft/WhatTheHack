IF OBJECT_ID ( 'SalesLT.spUpdateCustomerAddress', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spUpdateCustomerAddress;
GO

CREATE PROCEDURE SalesLT.spUpdateCustomerAddress

AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SalesLT.CustomerAddress
        SET
            CustomerID = S1.CustomerID
            , AddressID = S1.AddressID
            , AddressType = S1.AddressType
            , rowguid = S1.rowguid
            , ModifiedDate = S1.ModifiedDate
            
        from Staging.CustomerAddress S1
        where [SalesLT].[CustomerAddress].rowguid = S1.rowguid
        and S1.__$operation = 4
        and S1.tran_begin_time = (
                                    select MAX(s2.tran_begin_time) 
                                    from Staging.CustomerAddress s2 
                                    where s2.rowguid=s1.rowguid and S2.__$operation in (4)
                                )
                                
;
END;
GO

EXEC SalesLT.spUpdateCustomerAddress