--EXECUTE IN DW TO ADD CONTROL VALUES FOR ETL CUTOFF TABLE

ALTER TABLE Integration.[ETL Cutoff]
ADD [GroupId] [int] ;

ALTER TABLE Integration.[ETL Cutoff]
ADD [SequenceId] [int] ;
	
ALTER TABLE Integration.[ETL Cutoff]
ADD [isActive] [bit] ;

UPDATE [Integration].[ETL Cutoff]  SET GroupId = 1, SequenceId = 1, isActive = 1  WHERE [Table Name] = 'City'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 1, SequenceId = 5, isActive = 1  WHERE [Table Name] = 'Customer'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 1, SequenceId = 10, isActive = 1  WHERE [Table Name] = 'Employee'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 1, SequenceId = 15, isActive = 1  WHERE [Table Name] = 'Payment Method'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 1, SequenceId = 20, isActive = 1  WHERE [Table Name] = 'Stock Item'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 1, SequenceId = 25, isActive = 1  WHERE [Table Name] = 'Supplier'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 1, SequenceId = 30, isActive = 1  WHERE [Table Name] = 'Transaction Type'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 2, SequenceId = 35, isActive = 1  WHERE [Table Name] = 'Movement'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 2, SequenceId = 40, isActive = 1  WHERE [Table Name] = 'Order'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 2, SequenceId = 45, isActive = 1  WHERE [Table Name] = 'Purchase'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 2, SequenceId = 55, isActive = 1  WHERE [Table Name] = 'Sale'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 2, SequenceId = 60, isActive = 1  WHERE [Table Name] = 'Stock Holding'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 2, SequenceId = 65, isActive = 1  WHERE [Table Name] = 'Transaction'
UPDATE [Integration].[ETL Cutoff]  SET GroupId = 0, SequenceId = 999, isActive = 0  WHERE [Table Name] = 'Date'


