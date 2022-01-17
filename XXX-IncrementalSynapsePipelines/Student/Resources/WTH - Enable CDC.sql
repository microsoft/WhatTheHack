-- ====  
-- Enable Database for CDC template   
-- ====  
/*
USE AdventureWorks  
GO  
EXEC sys.sp_cdc_enable_db  
GO
*/

-- =========  
-- Enable a Table Without Using a Gating Role template   
-- =========  
USE AdventureWorks 
GO  
EXEC sys.sp_cdc_enable_table  
@source_schema = N'SalesLT',  
@source_name   = N'CustomerAddress',  
@role_name     = NULL,  
@supports_net_changes = 1  
GO  


-- =====  
-- Disable a Capture Instance for a Table template   
-- ====
/*
USE AdventureWorksLT  
GO  
EXEC sys.sp_cdc_disable_table  
@source_schema = N'SalesLT',  
@source_name   = N'Address',  
@capture_instance = N'SalesLT_Address'  
GO  

sys.sp_cdc_help_change_data_capture
*/

select * from [cdc].[SalesLT_Customer_CT]

select * from [cdc].[change_tables]