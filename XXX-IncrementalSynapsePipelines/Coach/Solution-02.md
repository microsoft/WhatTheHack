# Challenge #2: Create Incremental Load Pipelines - Coach's Guide

[< Previous Challenge](Solution-01.md) - **[Home](README.md)** - [Next Challenge>](Solution-03.md)

## Notes & Guidance

# Enabling Change Data Capture on the SQL Database

Here are some sample SQL scripts to Enable Change Data Capture on the AdventureWorks SQL database and add, update and delete records on the SalesLT tables.

Enable Database for CDC template

```
USE AdventureWorks  
GO  
EXEC sys.sp_cdc_enable_db  
GO
```

Enable a Table Without Using a Gating Role template
```
USE AdventureWorks 
GO  
EXEC sys.sp_cdc_enable_table  
@source_schema = N'SalesLT',  
@source_name   = N'Customer',  
@role_name     = NULL,  
@supports_net_changes = 1  
GO  
```

View cdc table(s) enabled
```
select * from [cdc].[SalesLT_Customer_CT]
```

Insert Records into the Customer table
```
 insert into [SalesLT].[Customer] 
     (firstname, lastname, emailaddress, phone, CompanyName, SalesPerson, ModifiedDate) 
 values 
     ('Nate', 'Gorham', 'nag@swiftcycles.com', '617-555-1212', 'Swift Cycles', 'adventure-works\jillian0', GETDATE()),
     ('Cindy', 'Smith', 'cs@swiftcycles.com', '617-555-1212', 'Swift Cycles', 'adventure-works\jillian0', GETDATE()),
     ('George', 'Bennett', 'gb@swiftcycles.com', '617-555-1212', 'Swift Cycles', 'adventure-works\jillian0', GETDATE())
```

Update Records on the Customer table
```
update [SalesLT].[Customer] set Phone = '617-555-1234', ModifiedDate = GETDATE() where CustomerID = 30123

```

Delete Records from the Customer table
```
delete from [SalesLT].[Customer] where CustomerID > 30123
```

# Create the Pipeline Reference Database

The pipeline reference database will need to be created, please follow the steps on pages 3-4 in the word document listed in the student section.  It is also referenced below.

## Tips

*The following document was used in a Customer PoC and may be helpful with this challenge.  Just keep in mind that the scenario in the PoC was a bit different so some sections of the document may not be relevant to this challenge.*

- [SQLMI to Dedicated Pool Proof of Concept](./Resources/SQLMItoDedicatedPoolProofofConcept.docx)