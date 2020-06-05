bcp "wwisynapse.Integration.ETL Cutoff" in "Integration.ETL Cutoff.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.ETL Cutoff.log" -w

bcp "wwisynapse.Integration.Lineage" in "Integration.Lineage.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Lineage.log" -w

bcp "wwisynapse.Integration.Customer_Staging" in "Integration.Customer_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Customer_Staging.log" -w

bcp "wwisynapse.Integration.Employee_Staging" in "Integration.Employee_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Employee_Staging.log" -w

bcp "wwisynapse.Integration.Movement_Staging" in "Integration.Movement_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Movement_Staging.log" -w

bcp "wwisynapse.Integration.Order_Staging" in "Integration.Order_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Order_Staging.log" -w

bcp "wwisynapse.Integration.PaymentMethod_Staging" in "Integration.PaymentMethod_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.PaymentMethod_Staging.log" -w

**********bcp "wwisynapse.Dimension.City" in "Dimension.City.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Dimension.City.log" -w

bcp "wwisynapse.Integration.Purchase_Staging" in "Integration.Purchase_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Purchase_Staging.log" -w

bcp "wwisynapse.Dimension.Customer" in "Dimension.Customer.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Dimension.Customer.log" -w

bcp "wwisynapse.Integration.Sale_Staging" in "Integration.Sale_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Sale_Staging.log" -w

bcp "wwisynapse.Integration.StockHolding_Staging" in "Integration.StockHolding_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.StockHolding_Staging.log" -w

bcp "wwisynapse.Dimension.Date" in "Dimension.Date.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Dimension.Date.log" -w

bcp "wwisynapse.Integration.StockItem_Staging" in "Integration.StockItem_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.StockItem_Staging.log" -w

bcp "wwisynapse.Dimension.Employee" in "Dimension.Employee.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Dimension.Employee.log" -w

bcp "wwisynapse.Integration.Supplier_Staging" in "Integration.Supplier_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Supplier_Staging.log" -w

bcp "wwisynapse.Dimension.Payment Method" in "Dimension.Payment Method.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Dimension.Payment Method.log" -w

bcp "wwisynapse.Integration.Transaction_Staging" in "Integration.Transaction_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.Transaction_Staging.log" -w

bcp "wwisynapse.Integration.TransactionType_Staging" in "Integration.TransactionType_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.TransactionType_Staging.log" -w

bcp "wwisynapse.Dimension.Stock Item" in "Dimension.Stock Item.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Dimension.Stock Item.log" -w

bcp "wwisynapse.Dimension.Supplier" in "Dimension.Supplier.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Dimension.Supplier.log" -w

bcp "wwisynapse.Dimension.Transaction Type" in "Dimension.Transaction Type.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Dimension.Transaction Type.log" -w

bcp "wwisynapse.Fact.Movement" in "Fact.Movement.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Fact.Movement.log" -w

bcp "wwisynapse.Fact.Order" in "Fact.Order.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Fact.Order.log" -w

bcp "wwisynapse.dbo.sessiontouser" in "dbo.sessiontouser.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "dbo.sessiontouser.log" -w

bcp "wwisynapse.Fact.Purchase" in "Fact.Purchase.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Fact.Purchase.log" -w

bcp "wwisynapse.Fact.Sale" in "Fact.Sale.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Fact.Sale.log" -w

bcp "wwisynapse.Fact.Stock Holding" in "Fact.Stock Holding.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Fact.Stock Holding.log" -w

bcp "wwisynapse.Fact.Transaction" in "Fact.Transaction.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Fact.Transaction.log" -w

bcp "wwisynapse.Integration.City_Staging" in "Integration.City_Staging.txt" -S "wwisynapse.database.windows.net" -U "user@wwisynapse.database.windows.net" -P "Pass@word1!" -r "\r" -t "|" -q -e "Integration.City_Staging.log" -w

