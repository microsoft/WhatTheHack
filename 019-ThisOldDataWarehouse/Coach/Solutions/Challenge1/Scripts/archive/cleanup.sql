/****** Object:  Table [dbo].[sessiontouser]    Script Date: 6/9/2020 9:25:15 PM ******/
DROP TABLE [dbo].[sessiontouser]
GO

/****** Object:  Table [Dimension].[City]    Script Date: 6/9/2020 9:23:34 PM ******/
DROP TABLE [Dimension].[City]
GO

/****** Object:  Table [Dimension].[Customer]    Script Date: 6/9/2020 9:23:42 PM ******/
DROP TABLE [Dimension].[Customer]
GO

/****** Object:  Table [Dimension].[Date]    Script Date: 6/9/2020 9:23:58 PM ******/
DROP TABLE [Dimension].[Date]
GO

/****** Object:  Table [Dimension].[Employee]    Script Date: 6/9/2020 9:24:09 PM ******/
DROP TABLE [Dimension].[Employee]
GO

/****** Object:  Table [Dimension].[Payment Method]    Script Date: 6/9/2020 9:24:21 PM ******/
DROP TABLE [Dimension].[Payment Method]
GO

/****** Object:  Table [Dimension].[Stock Item]    Script Date: 6/9/2020 9:24:33 PM ******/
DROP TABLE [Dimension].[Stock Item]
GO

/****** Object:  Table [Dimension].[Supplier]    Script Date: 6/9/2020 9:24:44 PM ******/
DROP TABLE [Dimension].[Supplier]
GO

/****** Object:  Table [Dimension].[Transaction Type]    Script Date: 6/9/2020 9:24:54 PM ******/
DROP TABLE [Dimension].[Transaction Type]
GO

/****** Object:  Table [Fact].[Movement]    Script Date: 6/9/2020 9:25:53 PM ******/
DROP TABLE [Fact].[Movement]
GO

/****** Object:  Table [Fact].[Order]    Script Date: 6/9/2020 9:26:03 PM ******/
DROP TABLE [Fact].[Order]
GO

/****** Object:  Table [Fact].[Purchase]    Script Date: 6/9/2020 9:26:18 PM ******/
DROP TABLE [Fact].[Purchase]
GO

/****** Object:  Table [Fact].[Sale]    Script Date: 6/9/2020 9:26:29 PM ******/
DROP TABLE [Fact].[Sale]
GO

/****** Object:  Table [Fact].[Stock Holding]    Script Date: 6/9/2020 9:26:42 PM ******/
DROP TABLE [Fact].[Stock Holding]
GO

/****** Object:  Table [Fact].[Transaction]    Script Date: 6/9/2020 9:26:53 PM ******/
DROP TABLE [Fact].[Transaction]
GO

/****** Object:  Table [Integration].[City_Staging]    Script Date: 6/9/2020 9:27:32 PM ******/
DROP TABLE [Integration].[City_Staging]
GO

/****** Object:  Table [Integration].[Customer_Staging]    Script Date: 6/9/2020 9:28:03 PM ******/
DROP TABLE [Integration].[Customer_Staging]
GO

/****** Object:  Table [Integration].[Employee_Staging]    Script Date: 6/9/2020 9:28:33 PM ******/
DROP TABLE [Integration].[Employee_Staging]
GO

/****** Object:  Table [Integration].[ETL Cutoff]    Script Date: 6/9/2020 9:28:43 PM ******/
DROP TABLE [Integration].[ETL Cutoff]
GO

/****** Object:  Table [Integration].[Lineage]    Script Date: 6/9/2020 9:28:53 PM ******/
DROP TABLE [Integration].[Lineage]
GO

/****** Object:  Table [Integration].[Load_Control]    Script Date: 6/9/2020 9:29:03 PM ******/
DROP TABLE [Integration].[Load_Control]
GO

/****** Object:  Table [Integration].[Movement_Staging]    Script Date: 6/9/2020 9:29:13 PM ******/
DROP TABLE [Integration].[Movement_Staging]
GO

/****** Object:  Table [Integration].[Order_Staging]    Script Date: 6/9/2020 9:29:22 PM ******/
DROP TABLE [Integration].[Order_Staging]
GO

/****** Object:  Table [Integration].[PaymentMethod_Staging]    Script Date: 6/9/2020 9:29:32 PM ******/
DROP TABLE [Integration].[PaymentMethod_Staging]
GO

/****** Object:  Table [Integration].[Purchase_Staging]    Script Date: 6/9/2020 9:29:43 PM ******/
DROP TABLE [Integration].[Purchase_Staging]
GO

/****** Object:  Table [Integration].[Sale_Staging]    Script Date: 6/9/2020 9:29:56 PM ******/
DROP TABLE [Integration].[Sale_Staging]
GO

/****** Object:  Table [Integration].[StockHolding_Staging]    Script Date: 6/9/2020 9:30:09 PM ******/
DROP TABLE [Integration].[StockHolding_Staging]
GO

/****** Object:  Table [Integration].[StockItem_Staging]    Script Date: 6/9/2020 9:30:23 PM ******/
DROP TABLE [Integration].[StockItem_Staging]
GO

/****** Object:  Table [Integration].[Supplier_Staging]    Script Date: 6/9/2020 9:30:33 PM ******/
DROP TABLE [Integration].[Supplier_Staging]
GO

/****** Object:  Table [Integration].[Transaction_Staging]    Script Date: 6/9/2020 9:30:45 PM ******/
DROP TABLE [Integration].[Transaction_Staging]
GO

/****** Object:  Table [Integration].[TransactionType_Staging]    Script Date: 6/9/2020 9:30:57 PM ******/
DROP TABLE [Integration].[TransactionType_Staging]
GO

/****** Object:  View [dbo].[vTableSizes]    Script Date: 6/9/2020 9:32:26 PM ******/
DROP VIEW [dbo].[vTableSizes]
GO

/****** Object:  View [Integration].[v_City_Stage]    Script Date: 6/9/2020 9:32:38 PM ******/
DROP VIEW [Integration].[v_City_Stage]
GO

/****** Object:  View [Integration].[v_Customer_Stage]    Script Date: 6/9/2020 9:32:48 PM ******/
DROP VIEW [Integration].[v_Customer_Stage]
GO

/****** Object:  View [Integration].[v_Employee_Stage]    Script Date: 6/9/2020 9:32:58 PM ******/
DROP VIEW [Integration].[v_Employee_Stage]
GO

/****** Object:  View [Integration].[v_PaymentMethod_Stage]    Script Date: 6/9/2020 9:33:13 PM ******/
DROP VIEW [Integration].[v_PaymentMethod_Stage]
GO

/****** Object:  View [Integration].[v_StockItem_Stage]    Script Date: 6/9/2020 9:33:22 PM ******/
DROP VIEW [Integration].[v_StockItem_Stage]
GO

/****** Object:  View [Integration].[v_Supplier_Stage]    Script Date: 6/9/2020 9:33:42 PM ******/
DROP VIEW [Integration].[v_Supplier_Stage]
GO

/****** Object:  View [Integration].[v_TransactionType_Stage]    Script Date: 6/9/2020 9:33:54 PM ******/
DROP VIEW [Integration].[v_TransactionType_Stage]
GO

/****** Object:  StoredProcedure [Integration].[PopulateDateDimensionForYear]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[PopulateDateDimensionForYear]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedTransactionTypeData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedTransactionTypeData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedTransactionData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedTransactionData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedSupplierData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedSupplierData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedStockItemData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedStockItemData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedStockHoldingData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedStockHoldingData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedSaleData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedSaleData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedPurchaseData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedPurchaseData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedPaymentMethodData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedPaymentMethodData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedOrderData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedOrderData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedMovementData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedMovementData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedEmployeeData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedEmployeeData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedCustomerData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedCustomerData]
GO
/****** Object:  StoredProcedure [Integration].[MigrateStagedCityData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[MigrateStagedCityData]
GO
/****** Object:  StoredProcedure [Integration].[IngestCityData]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[IngestCityData]
GO
/****** Object:  StoredProcedure [Integration].[GetLoadDate]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[GetLoadDate]
GO
/****** Object:  StoredProcedure [Integration].[GetLineageKey]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[GetLineageKey]
GO
/****** Object:  StoredProcedure [Integration].[GetLastETLCutoffTime]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[GetLastETLCutoffTime]
GO
/****** Object:  StoredProcedure [Integration].[CreateLineageKey]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[CreateLineageKey]
GO
/****** Object:  StoredProcedure [Integration].[Configuration_ReseedETL]    Script Date: 6/9/2020 9:35:10 PM ******/
DROP PROCEDURE [Integration].[Configuration_ReseedETL]
GO

/****** Object:  Schema [Dimension]    Script Date: 6/9/2020 9:37:26 PM ******/
DROP SCHEMA [Dimension]
GO

/****** Object:  Schema [Fact]    Script Date: 6/9/2020 9:37:41 PM ******/
DROP SCHEMA [Fact]
GO

/****** Object:  Schema [Integration]    Script Date: 6/9/2020 9:37:54 PM ******/
DROP SCHEMA [Integration]
GO

