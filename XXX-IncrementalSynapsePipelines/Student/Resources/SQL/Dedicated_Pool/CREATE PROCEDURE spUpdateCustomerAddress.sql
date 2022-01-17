IF OBJECT_ID ( 'SalesLT.spUpdateCustomerAddress', 'P' ) IS NOT NULL
    DROP PROCEDURE SalesLT.spUpdateCustomerAddress;
GO

CREATE PROCEDURE SalesLT.spUpdateCustomerAddress

AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SalesLT.Customer
        SET
            AddressType = S1.AddressType
            , rowguid = S1.rowguid
            , ModifiedDate = S1.ModifiedDate
            
        from Staging.CustomerAddress S1
        where [SalesLT].[CustomerAddress].CustomerID = S1.CustomerID
        and [SalesLT].[CustomerAddress].AddressID = S1.AddressID
        and S1.__$operation = 4
        and S1.tran_begin_time = (
                                    select MAX(s2.tran_begin_time) 
                                    from Staging.CustomerAddress s2 
                                    where s2.CustomerID=s1.CustomerID and s2.AddressID=s1.AddressID and S2.__$operation in (4)
                                )
                                
;
END;
GO