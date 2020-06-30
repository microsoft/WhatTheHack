bcp "[WideWorldImportersDW].[Integration].[ETL Cutoff]" out "Integration.ETL Cutoff.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Lineage]" out "Integration.Lineage.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Customer_Staging]" out "Integration.Customer_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Employee_Staging]" out "Integration.Employee_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Movement_Staging]" out "Integration.Movement_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Order_Staging]" out "Integration.Order_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[PaymentMethod_Staging]" out "Integration.PaymentMethod_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "SELECT [City Key],[WWI City ID],[City],[State Province],[Country],[Continent],[Sales Territory],[Region],[Subregion],[Latest Recorded Population],[Valid From],[Valid To],[Lineage Key] from [WideWorldImportersDW].[Dimension].[City]" queryout "Dimension.City.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Purchase_Staging]" out "Integration.Purchase_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Dimension].[Customer]" out "Dimension.Customer.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Sale_Staging]" out "Integration.Sale_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[StockHolding_Staging]" out "Integration.StockHolding_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Dimension].[Date]" out "Dimension.Date.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[StockItem_Staging]" out "Integration.StockItem_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Dimension].[Employee]" out "Dimension.Employee.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Supplier_Staging]" out "Integration.Supplier_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Dimension].[Payment Method]" out "Dimension.Payment Method.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[Transaction_Staging]" out "Integration.Transaction_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[TransactionType_Staging]" out "Integration.TransactionType_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Dimension].[Stock Item]" out "Dimension.Stock Item.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Dimension].[Supplier]" out "Dimension.Supplier.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Dimension].[Transaction Type]" out "Dimension.Transaction Type.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Fact].[Movement]" out "Fact.Movement.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Fact].[Order]" out "Fact.Order.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[dbo].[sessiontouser]" out "dbo.sessiontouser.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Fact].[Purchase]" out "Fact.Purchase.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Fact].[Sale]" out "Fact.Sale.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Fact].[Stock Holding]" out "Fact.Stock Holding.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "[WideWorldImportersDW].[Integration].[v_FactTrans_Export]" out "Fact.Transaction.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

bcp "SELECT [City Staging Key],[WWI City ID],[City],[State Province],[Country],[Continent],[Sales Territory],[Region],[Subregion],[Latest Recorded Population],[Valid From],[Valid To] from [WideWorldImportersDW].[Integration].[City_Staging]" queryout "Integration.City_Staging.txt" -S "MDWSQL" -T -r "\r" -t "|" -w

