--UPDATE ON 4/18/22  Rollback of unsupported T-SQL expressions in Synapse Analytics
--as of 4/22 Synapse supports
--Common Table Expressions
--Merge Statements (In Preview does not support IDENTITY Columns) Kept INSERT/UPDATE WORKAROUND
--UPDATE Statements with JOINS and Subqueries
--Rollback workarounds and use native code from WWI Samples

--Cleanup Dimension schema 
IF object_id('[Dimension].[City]','U') IS NOT NULL DROP TABLE [Dimension].[City]
IF object_id('[Dimension].[Customer]','U') IS NOT NULL DROP TABLE [Dimension].[Customer]
IF object_id('[Dimension].[Date]','U') IS NOT NULL DROP TABLE [Dimension].[Date]
IF object_id('[Dimension].[Employee]','U') IS NOT NULL DROP TABLE [Dimension].[Employee]
IF object_id('[Dimension].[Payment Method]','U') IS NOT NULL DROP TABLE [Dimension].[Payment Method]
IF object_id('[Dimension].[Stock Item]','U') IS NOT NULL DROP TABLE [Dimension].[Stock Item]
IF object_id('[Dimension].[Supplier]','U') IS NOT NULL DROP TABLE [Dimension].[Supplier]
IF object_id('[Dimension].[Transaction Type]','U') IS NOT NULL DROP TABLE [Dimension].[Transaction Type]
IF schema_id('Dimension') IS NOT NULL DROP SCHEMA [Dimension]
GO

--Cleanup Fact schema
IF object_id('[Fact].[Movement]','U') IS NOT NULL DROP TABLE [Fact].[Movement]
IF object_id('[Fact].[Order]','U') IS NOT NULL DROP TABLE [Fact].[Order]
IF object_id('[Fact].[Purchase]','U') IS NOT NULL DROP TABLE [Fact].[Purchase]
IF object_id('[Fact].[Sale]','U') IS NOT NULL DROP TABLE [Fact].[Sale]
IF object_id('[Fact].[Stock Holding]','U') IS NOT NULL DROP TABLE [Fact].[Stock Holding]
IF object_id('[Fact].[Transaction]','U') IS NOT NULL DROP TABLE [Fact].[Transaction]
IF schema_id('Fact') IS NOT NULL DROP SCHEMA [Fact]
GO

--Cleanup Integration Schema
IF object_id('[Integration].[City_Staging]','U') IS NOT NULL DROP TABLE [Integration].[City_Staging]
IF object_id('[Integration].[Customer_Staging]','U') IS NOT NULL DROP TABLE [Integration].[Customer_Staging]
IF object_id('[Integration].[Employee_Staging]','U') IS NOT NULL DROP TABLE [Integration].[Employee_Staging]
IF object_id('[Integration].[ETL Cutoff]','U') IS NOT NULL DROP TABLE [Integration].[ETL Cutoff]
IF object_id('[Integration].[Lineage]','U') IS NOT NULL DROP TABLE [Integration].[Lineage]
IF object_id('[Integration].[Load_Control]','U') IS NOT NULL DROP TABLE [Integration].[Load_Control]
IF object_id('[Integration].[Movement_Staging]','U') IS NOT NULL DROP TABLE [Integration].[Movement_Staging]
IF object_id('[Integration].[Order_Staging]','U') IS NOT NULL DROP TABLE [Integration].[Order_Staging]
IF object_id('[Integration].[PaymentMethod_Staging]','U') IS NOT NULL DROP TABLE [Integration].[PaymentMethod_Staging]
IF object_id('[Integration].[Purchase_Staging]','U') IS NOT NULL DROP TABLE [Integration].[Purchase_Staging]
IF object_id('[Integration].[Sale_Staging]','U') IS NOT NULL DROP TABLE [Integration].[Sale_Staging]
IF object_id('[Integration].[StockHolding_Staging]','U') IS NOT NULL DROP TABLE [Integration].[StockHolding_Staging]
IF object_id('[Integration].[StockItem_Staging]','U') IS NOT NULL DROP TABLE [Integration].[StockItem_Staging]
IF object_id('[Integration].[Supplier_Staging]','U') IS NOT NULL DROP TABLE [Integration].[Supplier_Staging]
IF object_id('[Integration].[Transaction_Staging]','U') IS NOT NULL DROP TABLE [Integration].[Transaction_Staging]
IF object_id('[Integration].[TransactionType_Staging]','U') IS NOT NULL DROP TABLE [Integration].[TransactionType_Staging]

IF object_id('[Integration].[vTableSizes]','V')  IS NOT NULL DROP VIEW [Integration].[vTableSizes]

IF object_id('[Integration].[Configuration_ReseedETL]','P')  IS NOT NULL DROP PROCEDURE [Integration].[Configuration_ReseedETL]
IF object_id('[Integration].[GetLastETLCutoffTime]','P')  IS NOT NULL DROP PROCEDURE [Integration].[GetLastETLCutoffTime]
IF object_id('[Integration].[GetLineageKey]','P')  IS NOT NULL DROP PROCEDURE [Integration].[GetLineageKey]
IF object_id('[Integration].[GetLoadDate]','P')  IS NOT NULL DROP PROCEDURE [Integration].[GetLoadDate]
IF object_id('[Integration].[MigrateStagedCityData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedCityData]
IF object_id('[Integration].[MigrateStagedCustomerData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedCustomerData]
IF object_id('[Integration].[MigrateStagedEmployeeData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedEmployeeData]
IF object_id('[Integration].[MigrateStagedMovementData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedMovementData]
IF object_id('[Integration].[MigrateStagedOrderData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedOrderData]
IF object_id('[Integration].[MigrateStagedPaymentMethodData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedPaymentMethodData]
IF object_id('[Integration].[MigrateStagedPurchaseData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedPurchaseData]
IF object_id('[Integration].[MigrateStagedSaleData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedSaleData]
IF object_id('[Integration].[MigrateStagedStockHoldingData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedStockHoldingData]
IF object_id('[Integration].[MigrateStagedStockItemData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedStockItemData]
IF object_id('[Integration].[MigrateStagedSupplierData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedSupplierData]
IF object_id('[Integration].[MigrateStagedTransactionData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedTransactionData]
IF object_id('[Integration].[MigrateStagedTransactionTypeData]','P')  IS NOT NULL DROP PROCEDURE [Integration].[MigrateStagedTransactionTypeData]
IF object_id('[Integration].[PopulateDateDimensionForYear]','P')  IS NOT NULL DROP PROCEDURE [Integration].[PopulateDateDimensionForYear]
IF schema_id('Integration') IS NOT NULL DROP SCHEMA [Integration]
GO

--Create schemas
CREATE SCHEMA [Dimension]
GO
CREATE SCHEMA [Fact]
GO
CREATE SCHEMA [Integration]
GO

--Create dimension tables

/****** Object:  Table [Dimension].[City]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[City]
(
	[City Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI City ID] [int] NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State Province] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](60) NOT NULL,
	[Continent] [nvarchar](30) NOT NULL,
	[Sales Territory] [nvarchar](50) NOT NULL,
	[Region] [nvarchar](30) NOT NULL,
	[Subregion] [nvarchar](30) NOT NULL,
	[Latest Recorded Population] [bigint] NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED INDEX
	(
		[City Key] ASC
	)
)
GO

/****** Object:  Table [Dimension].[Customer]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Customer]
(
	[Customer Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Customer ID] [int] NOT NULL,
	[Customer] [nvarchar](100) NOT NULL,
	[Bill To Customer] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Buying Group] [nvarchar](50) NOT NULL,
	[Primary Contact] [nvarchar](50) NOT NULL,
	[Postal Code] [nvarchar](10) NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Customer Key] ASC
	)
)
GO


/****** Object:  Table [Dimension].[Date]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Date]
(
	[Date] [date] NOT NULL,
	[Day Number] [int] NOT NULL,
	[Day] [nvarchar](10) NOT NULL,
	[Month] [nvarchar](10) NOT NULL,
	[Short Month] [nvarchar](3) NOT NULL,
	[Calendar Month Number] [int] NOT NULL,
	[Calendar Month Label] [nvarchar](20) NOT NULL,
	[Calendar Year] [int] NOT NULL,
	[Calendar Year Label] [nvarchar](10) NOT NULL,
	[Fiscal Month Number] [int] NOT NULL,
	[Fiscal Month Label] [nvarchar](20) NOT NULL,
	[Fiscal Year] [int] NOT NULL,
	[Fiscal Year Label] [nvarchar](10) NOT NULL,
	[ISO Week Number] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Date] ASC
	)
)
GO

/****** Object:  Table [Dimension].[Employee]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Employee]
(
	[Employee Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Employee ID] [int] NOT NULL,
	[Employee] [nvarchar](50) NOT NULL,
	[Preferred Name] [nvarchar](50) NOT NULL,
	[Is Salesperson] [bit] NOT NULL,
	[Photo] [varbinary](8000) NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Employee Key] ASC
	)
)
GO


/****** Object:  Table [Dimension].[Payment Method]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Payment Method]
(
	[Payment Method Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Payment Method ID] [int] NOT NULL,
	[Payment Method] [nvarchar](50) NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Payment Method Key] ASC
	)
)
GO

/****** Object:  Table [Dimension].[Stock Item]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Stock Item]
(
	[Stock Item Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Stock Item ID] [int] NOT NULL,
	[Stock Item] [nvarchar](100) NOT NULL,
	[Color] [nvarchar](20) NOT NULL,
	[Selling Package] [nvarchar](50) NOT NULL,
	[Buying Package] [nvarchar](50) NOT NULL,
	[Brand] [nvarchar](50) NOT NULL,
	[Size] [nvarchar](20) NOT NULL,
	[Lead Time Days] [int] NOT NULL,
	[Quantity Per Outer] [int] NOT NULL,
	[Is Chiller Stock] [bit] NOT NULL,
	[Barcode] [nvarchar](50) NULL,
	[Tax Rate] [decimal](18, 3) NOT NULL,
	[Unit Price] [decimal](18, 2) NOT NULL,
	[Recommended Retail Price] [decimal](18, 2) NULL,
	[Typical Weight Per Unit] [decimal](18, 3) NOT NULL,
	[Photo] [varbinary](8000) NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Stock Item Key] ASC
	)
)
GO

/****** Object:  Table [Dimension].[Supplier]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Supplier]
(
	[Supplier Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Supplier ID] [int] NOT NULL,
	[Supplier] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Primary Contact] [nvarchar](50) NOT NULL,
	[Supplier Reference] [nvarchar](20) NULL,
	[Payment Days] [int] NOT NULL,
	[Postal Code] [nvarchar](10) NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Supplier Key] ASC
	)
)
GO


/****** Object:  Table [Dimension].[Transaction Type]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Dimension].[Transaction Type]
(
	[Transaction Type Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Transaction Type ID] [int] NOT NULL,
	[Transaction Type] [nvarchar](50) NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[Transaction Type Key] ASC
	)
)
GO


/****** Object:  Table [Fact].[Movement]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[Movement]
(
	[Movement Key] [bigint] IDENTITY(1,1) NOT NULL,
	[Date Key] [date] NOT NULL,
	[Stock Item Key] [int] NOT NULL,
	[Customer Key] [int] NULL,
	[Supplier Key] [int] NULL,
	[Transaction Type Key] [int] NOT NULL,
	[WWI Stock Item Transaction ID] [int] NOT NULL,
	[WWI Invoice ID] [int] NULL,
	[WWI Purchase Order ID] [int] NULL,
	[Quantity] [int] NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [WWI Stock Item Transaction ID] ),
	CLUSTERED INDEX
	(
		[Movement Key] ASC
	)
)
GO

/****** Object:  Table [Fact].[Order]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[Order]
(
	[Order Key] [bigint] IDENTITY(1,1) NOT NULL,
	[City Key] [int] NOT NULL,
	[Customer Key] [int] NOT NULL,
	[Stock Item Key] [int] NOT NULL,
	[Order Date Key] [date] NOT NULL,
	[Picked Date Key] [date] NULL,
	[Salesperson Key] [int] NOT NULL,
	[Picker Key] [int] NULL,
	[WWI Order ID] [int] NOT NULL,
	[WWI Backorder ID] [int] NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Unit Price] [decimal](18, 2) NOT NULL,
	[Tax Rate] [decimal](18, 3) NOT NULL,
	[Total Excluding Tax] [decimal](18, 2) NOT NULL,
	[Tax Amount] [decimal](18, 2) NOT NULL,
	[Total Including Tax] [decimal](18, 2) NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [WWI Order ID] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO

/****** Object:  Table [Fact].[Purchase]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[Purchase]
(
	[Purchase Key] [bigint] IDENTITY(1,1) NOT NULL,
	[Date Key] [date] NOT NULL,
	[Supplier Key] [int] NOT NULL,
	[Stock Item Key] [int] NOT NULL,
	[WWI Purchase Order ID] [int] NULL,
	[Ordered Outers] [int] NOT NULL,
	[Ordered Quantity] [int] NOT NULL,
	[Received Outers] [int] NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Is Order Finalized] [bit] NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [WWI Purchase Order ID] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO

/****** Object:  Table [Fact].[Sale]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[Sale]
(
	[Sale Key] [bigint] IDENTITY(1,1) NOT NULL,
	[City Key] [int] NOT NULL,
	[Customer Key] [int] NOT NULL,
	[Bill To Customer Key] [int] NOT NULL,
	[Stock Item Key] [int] NOT NULL,
	[Invoice Date Key] [date] NOT NULL,
	[Delivery Date Key] [date] NULL,
	[Salesperson Key] [int] NOT NULL,
	[WWI Invoice ID] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[Package] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Unit Price] [decimal](18, 2) NOT NULL,
	[Tax Rate] [decimal](18, 3) NOT NULL,
	[Total Excluding Tax] [decimal](18, 2) NOT NULL,
	[Tax Amount] [decimal](18, 2) NOT NULL,
	[Profit] [decimal](18, 2) NOT NULL,
	[Total Including Tax] [decimal](18, 2) NOT NULL,
	[Total Dry Items] [int] NOT NULL,
	[Total Chiller Items] [int] NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [City Key] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO

/****** Object:  Table [Fact].[Stock Holding]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[Stock Holding]
(
	[Stock Holding Key] [bigint] IDENTITY(1,1) NOT NULL,
	[Stock Item Key] [int] NOT NULL,
	[Quantity On Hand] [int] NOT NULL,
	[Bin Location] [nvarchar](20) NOT NULL,
	[Last Stocktake Quantity] [int] NOT NULL,
	[Last Cost Price] [decimal](18, 2) NOT NULL,
	[Reorder Level] [int] NOT NULL,
	[Target Stock Level] [int] NOT NULL,
	[Lineage Key] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [Stock Item Key] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO

/****** Object:  Table [Fact].[Transaction]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Fact].[Transaction]
(
	[Transaction Key] [bigint] IDENTITY(1,1) NOT NULL,
	[Date Key] [date] NOT NULL,
	[Customer Key] [int] NULL,
	[Bill To Customer Key] [int] NULL,
	[Supplier Key] [int] NULL,
	[Transaction Type Key] [int] NOT NULL,
	[Payment Method Key] [int] NULL,
	[WWI Customer Transaction ID] [int] NULL,
	[WWI Supplier Transaction ID] [int] NULL,
	[WWI Invoice ID] [int] NULL,
	[WWI Purchase Order ID] [int] NULL,
	[Supplier Invoice Number] [nvarchar](20) NULL,
	[Total Excluding Tax] [decimal](18, 2) NOT NULL,
	[Tax Amount] [decimal](18, 2) NOT NULL,
	[Total Including Tax] [decimal](18, 2) NOT NULL,
	[Outstanding Balance] [decimal](18, 2) NOT NULL,
	[Is Finalized] [bit] NOT NULL,
	[Lineage Key] [int] NOT NULL,
	[WWI Transaction ID] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = HASH ( [WWI Transaction ID] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO

--Create staging tables

/****** Object:  Table [Integration].[City_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[City_Staging]
(
	[City Staging Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI City ID] [int] NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State Province] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](60) NOT NULL,
	[Continent] [nvarchar](30) NOT NULL,
	[Sales Territory] [nvarchar](50) NOT NULL,
	[Region] [nvarchar](30) NOT NULL,
	[Subregion] [nvarchar](30) NOT NULL,
	[Latest Recorded Population] [bigint] NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[Customer_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Customer_Staging]
(
	[Customer Staging Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Customer ID] [int] NOT NULL,
	[Customer] [nvarchar](100) NOT NULL,
	[Bill To Customer] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Buying Group] [nvarchar](50) NOT NULL,
	[Primary Contact] [nvarchar](50) NOT NULL,
	[Postal Code] [nvarchar](10) NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[Employee_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Employee_Staging]
(
	[Employee Staging Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Employee ID] [int] NOT NULL,
	[Employee] [nvarchar](50) NOT NULL,
	[Preferred Name] [nvarchar](50) NOT NULL,
	[Is Salesperson] [bit] NOT NULL,
	[Photo] [varbinary](8000) NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[ETL Cutoff]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[ETL Cutoff]
(
	[Table Name] [nvarchar](128) NOT NULL,
	[Cutoff Time] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

/****** Object:  Table [Integration].[Lineage]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Lineage]
(
	[Lineage Key] [int] IDENTITY(1,1) NOT NULL,
	[Data Load Started] [datetime2](7) NOT NULL,
	[Table Name] [nvarchar](128) NOT NULL,
	[Data Load Completed] [datetime2](7) NULL,
	[Was Successful] [bit] NOT NULL,
	[Source System Cutoff Time] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

/****** Object:  Table [Integration].[Load_Control]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Load_Control]
(
	[Load_Date] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

/****** Object:  Table [Integration].[Movement_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Movement_Staging]
(
	[Movement Staging Key] [bigint] IDENTITY(1,1) NOT NULL,
	[Date Key] [date] NULL,
	[Stock Item Key] [int] NULL,
	[Customer Key] [int] NULL,
	[Supplier Key] [int] NULL,
	[Transaction Type Key] [int] NULL,
	[WWI Stock Item Transaction ID] [int] NULL,
	[WWI Invoice ID] [int] NULL,
	[WWI Purchase Order ID] [int] NULL,
	[Quantity] [int] NULL,
	[WWI Stock Item ID] [int] NULL,
	[WWI Customer ID] [int] NULL,
	[WWI Supplier ID] [int] NULL,
	[WWI Transaction Type ID] [int] NULL,
	[Last Modifed When] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[Order_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Order_Staging]
(
	[Order Staging Key] [bigint] IDENTITY(1,1) NOT NULL,
	[City Key] [int] NULL,
	[Customer Key] [int] NULL,
	[Stock Item Key] [int] NULL,
	[Order Date Key] [date] NULL,
	[Picked Date Key] [date] NULL,
	[Salesperson Key] [int] NULL,
	[Picker Key] [int] NULL,
	[WWI Order ID] [int] NULL,
	[WWI Backorder ID] [int] NULL,
	[Description] [nvarchar](100) NULL,
	[Package] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[Unit Price] [decimal](18, 2) NULL,
	[Tax Rate] [decimal](18, 3) NULL,
	[Total Excluding Tax] [decimal](18, 2) NULL,
	[Tax Amount] [decimal](18, 2) NULL,
	[Total Including Tax] [decimal](18, 2) NULL,
	[Lineage Key] [int] NULL,
	[WWI City ID] [int] NULL,
	[WWI Customer ID] [int] NULL,
	[WWI Stock Item ID] [int] NULL,
	[WWI Salesperson ID] [int] NULL,
	[WWI Picker ID] [int] NULL,
	[Last Modified When] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[PaymentMethod_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[PaymentMethod_Staging]
(
	[Payment Method Staging Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Payment Method ID] [int] NOT NULL,
	[Payment Method] [nvarchar](50) NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO


/****** Object:  Table [Integration].[Purchase_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Purchase_Staging]
(
	[Purchase Staging Key] [bigint] IDENTITY(1,1) NOT NULL,
	[Date Key] [date] NULL,
	[Supplier Key] [int] NULL,
	[Stock Item Key] [int] NULL,
	[WWI Purchase Order ID] [int] NULL,
	[Ordered Outers] [int] NULL,
	[Ordered Quantity] [int] NULL,
	[Received Outers] [int] NULL,
	[Package] [nvarchar](50) NULL,
	[Is Order Finalized] [bit] NULL,
	[WWI Supplier ID] [int] NULL,
	[WWI Stock Item ID] [int] NULL,
	[Last Modified When] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO


/****** Object:  Table [Integration].[Sale_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Sale_Staging]
(
	[Sale Staging Key] [bigint] IDENTITY(1,1) NOT NULL,
	[City Key] [int] NULL,
	[Customer Key] [int] NULL,
	[Bill To Customer Key] [int] NULL,
	[Stock Item Key] [int] NULL,
	[Invoice Date Key] [date] NULL,
	[Delivery Date Key] [date] NULL,
	[Salesperson Key] [int] NULL,
	[WWI Invoice ID] [int] NULL,
	[Description] [nvarchar](100) NULL,
	[Package] [nvarchar](50) NULL,
	[Quantity] [int] NULL,
	[Unit Price] [decimal](18, 2) NULL,
	[Tax Rate] [decimal](18, 3) NULL,
	[Total Excluding Tax] [decimal](18, 2) NULL,
	[Tax Amount] [decimal](18, 2) NULL,
	[Profit] [decimal](18, 2) NULL,
	[Total Including Tax] [decimal](18, 2) NULL,
	[Total Dry Items] [int] NULL,
	[Total Chiller Items] [int] NULL,
	[WWI City ID] [int] NULL,
	[WWI Customer ID] [int] NULL,
	[WWI Bill To Customer ID] [int] NULL,
	[WWI Stock Item ID] [int] NULL,
	[WWI Salesperson ID] [int] NULL,
	[Last Modified When] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[StockHolding_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[StockHolding_Staging]
(
	[Stock Holding Staging Key] [bigint] IDENTITY(1,1) NOT NULL,
	[Stock Item Key] [int] NULL,
	[Quantity On Hand] [int] NULL,
	[Bin Location] [nvarchar](20) NULL,
	[Last Stocktake Quantity] [int] NULL,
	[Last Cost Price] [decimal](18, 2) NULL,
	[Reorder Level] [int] NULL,
	[Target Stock Level] [int] NULL,
	[WWI Stock Item ID] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[StockItem_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[StockItem_Staging]
(
	[Stock Item Staging Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Stock Item ID] [int] NOT NULL,
	[Stock Item] [nvarchar](100) NOT NULL,
	[Color] [nvarchar](20) NOT NULL,
	[Selling Package] [nvarchar](50) NOT NULL,
	[Buying Package] [nvarchar](50) NOT NULL,
	[Brand] [nvarchar](50) NOT NULL,
	[Size] [nvarchar](20) NOT NULL,
	[Lead Time Days] [int] NOT NULL,
	[Quantity Per Outer] [int] NOT NULL,
	[Is Chiller Stock] [bit] NOT NULL,
	[Barcode] [nvarchar](50) NULL,
	[Tax Rate] [decimal](18, 3) NOT NULL,
	[Unit Price] [decimal](18, 2) NOT NULL,
	[Recommended Retail Price] [decimal](18, 2) NULL,
	[Typical Weight Per Unit] [decimal](18, 3) NOT NULL,
	[Photo] [varbinary](8000) NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO


/****** Object:  Table [Integration].[Supplier_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Supplier_Staging]
(
	[Supplier Staging Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Supplier ID] [int] NOT NULL,
	[Supplier] [nvarchar](100) NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Primary Contact] [nvarchar](50) NOT NULL,
	[Supplier Reference] [nvarchar](20) NULL,
	[Payment Days] [int] NOT NULL,
	[Postal Code] [nvarchar](10) NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[Transaction_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[Transaction_Staging]
(
	[Transaction Staging Key] [bigint] IDENTITY(1,1) NOT NULL,
	[Date Key] [date] NULL,
	[Customer Key] [int] NULL,
	[Bill To Customer Key] [int] NULL,
	[Supplier Key] [int] NULL,
	[Transaction Type Key] [int] NULL,
	[Payment Method Key] [int] NULL,
	[WWI Customer Transaction ID] [int] NULL,
	[WWI Supplier Transaction ID] [int] NULL,
	[WWI Invoice ID] [int] NULL,
	[WWI Purchase Order ID] [int] NULL,
	[Supplier Invoice Number] [nvarchar](20) NULL,
	[Total Excluding Tax] [decimal](18, 2) NULL,
	[Tax Amount] [decimal](18, 2) NULL,
	[Total Including Tax] [decimal](18, 2) NULL,
	[Outstanding Balance] [decimal](18, 2) NULL,
	[Is Finalized] [bit] NULL,
	[WWI Customer ID] [int] NULL,
	[WWI Bill To Customer ID] [int] NULL,
	[WWI Supplier ID] [int] NULL,
	[WWI Transaction Type ID] [int] NULL,
	[WWI Payment Method ID] [int] NULL,
	[Last Modified When] [datetime2](7) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  Table [Integration].[TransactionType_Staging]    Script Date: 5/12/2020 3:25:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Integration].[TransactionType_Staging]
(
	[Transaction Type Staging Key] [int] IDENTITY(1,1) NOT NULL,
	[WWI Transaction Type ID] [int] NOT NULL,
	[Transaction Type] [nvarchar](50) NOT NULL,
	[Valid From] [datetime2](7) NOT NULL,
	[Valid To] [datetime2](7) NOT NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO

/****** Object:  View [dbo].[vTableSizes]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Integration].[vTableSizes]
AS WITH base
AS
(
SELECT 
 GETDATE()                                                             AS  [execution_time]
, DB_NAME()                                                            AS  [database_name]
, s.name                                                               AS  [schema_name]
, t.name                                                               AS  [table_name]
, QUOTENAME(s.name)+'.'+QUOTENAME(t.name)                              AS  [two_part_name]
, nt.[name]                                                            AS  [node_table_name]
, ROW_NUMBER() OVER(PARTITION BY nt.[name] ORDER BY (SELECT NULL))     AS  [node_table_name_seq]
, tp.[distribution_policy_desc]                                        AS  [distribution_policy_name]
, c.[name]                                                             AS  [distribution_column]
, nt.[distribution_id]                                                 AS  [distribution_id]
, i.[type]                                                             AS  [index_type]
, i.[type_desc]                                                        AS  [index_type_desc]
, nt.[pdw_node_id]                                                     AS  [pdw_node_id]
, pn.[type]                                                            AS  [pdw_node_type]
, pn.[name]                                                            AS  [pdw_node_name]
, di.name                                                              AS  [dist_name]
, di.position                                                          AS  [dist_position]
, nps.[partition_number]                                               AS  [partition_nmbr]
, nps.[reserved_page_count]                                            AS  [reserved_space_page_count]
, nps.[reserved_page_count] - nps.[used_page_count]                    AS  [unused_space_page_count]
, nps.[in_row_data_page_count] 
    + nps.[row_overflow_used_page_count] 
    + nps.[lob_used_page_count]                                        AS  [data_space_page_count]
, nps.[reserved_page_count] 
 - (nps.[reserved_page_count] - nps.[used_page_count]) 
 - ([in_row_data_page_count] 
         + [row_overflow_used_page_count]+[lob_used_page_count])       AS  [index_space_page_count]
, nps.[row_count]                                                      AS  [row_count]
from 
    sys.schemas s
INNER JOIN sys.tables t
    ON s.[schema_id] = t.[schema_id]
INNER JOIN sys.indexes i
    ON  t.[object_id] = i.[object_id]
    AND i.[index_id] <= 1
INNER JOIN sys.pdw_table_distribution_properties tp
    ON t.[object_id] = tp.[object_id]
INNER JOIN sys.pdw_table_mappings tm
    ON t.[object_id] = tm.[object_id]
INNER JOIN sys.pdw_nodes_tables nt
    ON tm.[physical_name] = nt.[name]
INNER JOIN sys.dm_pdw_nodes pn
    ON  nt.[pdw_node_id] = pn.[pdw_node_id]
INNER JOIN sys.pdw_distributions di
    ON  nt.[distribution_id] = di.[distribution_id]
INNER JOIN sys.dm_pdw_nodes_db_partition_stats nps
    ON nt.[object_id] = nps.[object_id]
    AND nt.[pdw_node_id] = nps.[pdw_node_id]
    AND nt.[distribution_id] = nps.[distribution_id]
LEFT OUTER JOIN (select * from sys.pdw_column_distribution_properties where distribution_ordinal = 1) cdp
    ON t.[object_id] = cdp.[object_id]
LEFT OUTER JOIN sys.columns c
    ON cdp.[object_id] = c.[object_id]
    AND cdp.[column_id] = c.[column_id]
WHERE pn.[type] = 'COMPUTE'
)
, size
AS
(
SELECT
   [execution_time]
,  [database_name]
,  [schema_name]
,  [table_name]
,  [two_part_name]
,  [node_table_name]
,  [node_table_name_seq]
,  [distribution_policy_name]
,  [distribution_column]
,  [distribution_id]
,  [index_type]
,  [index_type_desc]
,  [pdw_node_id]
,  [pdw_node_type]
,  [pdw_node_name]
,  [dist_name]
,  [dist_position]
,  [partition_nmbr]
,  [reserved_space_page_count]
,  [unused_space_page_count]
,  [data_space_page_count]
,  [index_space_page_count]
,  [row_count]
,  ([reserved_space_page_count] * 8.0)                                 AS [reserved_space_KB]
,  ([reserved_space_page_count] * 8.0)/1000                            AS [reserved_space_MB]
,  ([reserved_space_page_count] * 8.0)/1000000                         AS [reserved_space_GB]
,  ([reserved_space_page_count] * 8.0)/1000000000                      AS [reserved_space_TB]
,  ([unused_space_page_count]   * 8.0)                                 AS [unused_space_KB]
,  ([unused_space_page_count]   * 8.0)/1000                            AS [unused_space_MB]
,  ([unused_space_page_count]   * 8.0)/1000000                         AS [unused_space_GB]
,  ([unused_space_page_count]   * 8.0)/1000000000                      AS [unused_space_TB]
,  ([data_space_page_count]     * 8.0)                                 AS [data_space_KB]
,  ([data_space_page_count]     * 8.0)/1000                            AS [data_space_MB]
,  ([data_space_page_count]     * 8.0)/1000000                         AS [data_space_GB]
,  ([data_space_page_count]     * 8.0)/1000000000                      AS [data_space_TB]
,  ([index_space_page_count]  * 8.0)                                   AS [index_space_KB]
,  ([index_space_page_count]  * 8.0)/1000                              AS [index_space_MB]
,  ([index_space_page_count]  * 8.0)/1000000                           AS [index_space_GB]
,  ([index_space_page_count]  * 8.0)/1000000000                        AS [index_space_TB]
FROM base
)
SELECT * 
FROM size;
GO


--Create Stored Procedures
/****** Object:  StoredProcedure [Integration].[GetLastETLCutoffTime]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[GetLastETLCutoffTime] @TableName [sysname] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SELECT [Cutoff Time] AS CutoffTime
    FROM Integration.[ETL Cutoff]
    WHERE [Table Name] = @TableName;

END;
GO

/****** Object:  StoredProcedure [Integration].[GetLineageKey]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[GetLineageKey] @TableName [sysname],@NewCutoffTime [datetime2](7) AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @DataLoadStartedWhen datetime2(7) = SYSDATETIME();

    INSERT Integration.Lineage
        ([Data Load Started], [Table Name], [Data Load Completed],
         [Was Successful], [Source System Cutoff Time])
    VALUES
        (@DataLoadStartedWhen, @TableName, NULL,
         0, @NewCutoffTime);

    SELECT TOP(1) [Lineage Key] AS LineageKey
    FROM Integration.Lineage
    WHERE [Table Name] = @TableName
    AND [Data Load Started] = @DataLoadStartedWhen
    ORDER BY LineageKey DESC;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[GetLoadDate]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[GetLoadDate] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SELECT [Load_Date] AS LoadDate
    FROM Integration.[Load_Control];

END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedCityData]    Script Date: 6/25/2020 1:14:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedCityData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'City'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    WITH RowsToCloseOff
    AS
    (
        SELECT c.[WWI City ID], MIN(c.[Valid From]) AS [Valid From]
        FROM Integration.City_Staging AS c
        GROUP BY c.[WWI City ID]
    )
    UPDATE c
        SET c.[Valid To] = rtco.[Valid From]
    FROM Dimension.City AS c
    INNER JOIN RowsToCloseOff AS rtco
    ON c.[WWI City ID] = rtco.[WWI City ID]
    WHERE c.[Valid To] = @EndOfTime;

    INSERT Dimension.City
        ([WWI City ID], City, [State Province], Country, Continent,
         [Sales Territory], Region, Subregion,
         [Latest Recorded Population], [Valid From], [Valid To],
         [Lineage Key])
    SELECT [WWI City ID], City, [State Province], Country, Continent,
           [Sales Territory], Region, Subregion,
           [Latest Recorded Population], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.City_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
        SET [Cutoff Time] = (SELECT [Source System Cutoff Time]
                             FROM Integration.Lineage
                             WHERE [Lineage Key] = @LineageKey)
    FROM Integration.[ETL Cutoff]
    WHERE [Table Name] = N'City';

    COMMIT;

END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedCustomerData]    Script Date: 6/25/2020 1:15:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedCustomerData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Customer'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);
	
    WITH RowsToCloseOff
    AS
    (
        SELECT c.[WWI Customer ID], MIN(c.[Valid From]) AS [Valid From]
        FROM Integration.Customer_Staging AS c
        GROUP BY c.[WWI Customer ID]
    )
    UPDATE c
        SET c.[Valid To] = rtco.[Valid From]
    FROM Dimension.Customer AS c
    INNER JOIN RowsToCloseOff AS rtco
    ON c.[WWI Customer ID] = rtco.[WWI Customer ID]
    WHERE c.[Valid To] = @EndOfTime;

    INSERT Dimension.Customer
        ([WWI Customer ID], Customer, [Bill To Customer], Category,
         [Buying Group], [Primary Contact], [Postal Code], [Valid From], [Valid To],
         [Lineage Key])
    SELECT [WWI Customer ID], Customer, [Bill To Customer], Category,
           [Buying Group], [Primary Contact], [Postal Code], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.Customer_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Customer'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Customer';

    COMMIT;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedEmployeeData]    Script Date: 6/25/2020 1:16:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedEmployeeData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Employee'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

  WITH RowsToCloseOff
    AS
    (
        SELECT e.[WWI Employee ID], MIN(e.[Valid From]) AS [Valid From]
        FROM Integration.Employee_Staging AS e
        GROUP BY e.[WWI Employee ID]
    )
    UPDATE e
        SET e.[Valid To] = rtco.[Valid From]
    FROM Dimension.Employee AS e
    INNER JOIN RowsToCloseOff AS rtco
    ON e.[WWI Employee ID] = rtco.[WWI Employee ID]
    WHERE e.[Valid To] = @EndOfTime;

    INSERT Dimension.Employee
        ([WWI Employee ID], Employee, [Preferred Name], [Is Salesperson], Photo, [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Employee ID], Employee, [Preferred Name], [Is Salesperson], Photo, [Valid From], [Valid To],
           @LineageKey
    FROM Integration.Employee_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Employee'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Employee';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedMovementData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedMovementData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Movement'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

    UPDATE Integration.Movement_Staging
        SET Integration.Movement_Staging.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = Integration.Movement_Staging.[WWI Stock Item ID]
                                           AND Integration.Movement_Staging.[Last Modifed When] > si.[Valid From]
                                           AND Integration.Movement_Staging.[Last Modifed When] <= si.[Valid To]
									       ORDER BY si.[Valid From]), 0),
            Integration.Movement_Staging.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                         FROM Dimension.Customer AS c
                                         WHERE c.[WWI Customer ID] = Integration.Movement_Staging.[WWI Customer ID]
                                         AND Integration.Movement_Staging.[Last Modifed When] > c.[Valid From]
                                         AND Integration.Movement_Staging.[Last Modifed When] <= c.[Valid To]
									     ORDER BY c.[Valid From]), 0),
            Integration.Movement_Staging.[Supplier Key] = COALESCE((SELECT TOP(1) s.[Supplier Key]
                                         FROM Dimension.Supplier AS s
                                         WHERE s.[WWI Supplier ID] = Integration.Movement_Staging.[WWI Supplier ID]
                                         AND Integration.Movement_Staging.[Last Modifed When] > s.[Valid From]
                                         AND Integration.Movement_Staging.[Last Modifed When] <= s.[Valid To]
									     ORDER BY s.[Valid From]), 0),
            Integration.Movement_Staging.[Transaction Type Key] = COALESCE((SELECT TOP(1) tt.[Transaction Type Key]
                                                 FROM Dimension.[Transaction Type] AS tt
                                                 WHERE tt.[WWI Transaction Type ID] = Integration.Movement_Staging.[WWI Transaction Type ID]
                                                 AND Integration.Movement_Staging.[Last Modifed When] > tt.[Valid From]
                                                 AND Integration.Movement_Staging.[Last Modifed When] <= tt.[Valid To]
									             ORDER BY tt.[Valid From]), 0);

    -- Update existing Fact records with latest values
	
	UPDATE FACT.MOVEMENT
	SET FACT.MOVEMENT.[Date Key] = Integration.Movement_Staging.[Date Key],
        FACT.MOVEMENT.[Stock Item Key] = Integration.Movement_Staging.[Stock Item Key],
        FACT.MOVEMENT.[Customer Key] = Integration.Movement_Staging.[Customer Key],
        FACT.MOVEMENT.[Supplier Key] = Integration.Movement_Staging.[Supplier Key],
        FACT.MOVEMENT.[Transaction Type Key] = Integration.Movement_Staging.[Transaction Type Key],
        FACT.MOVEMENT.[WWI Invoice ID] = Integration.Movement_Staging.[WWI Invoice ID],
        FACT.MOVEMENT.[WWI Purchase Order ID] = Integration.Movement_Staging.[WWI Purchase Order ID],
        FACT.MOVEMENT.Quantity = Integration.Movement_Staging.Quantity, 
        FACT.MOVEMENT.[Lineage Key] = @LineageKey
		FROM Integration.Movement_Staging
		WHERE FACT.MOVEMENT.[WWI Stock Item Transaction ID] = Integration.Movement_Staging.[WWI Stock Item Transaction ID];    

	--Insert new records into the fact table

    INSERT Fact.Movement 
			([Date Key], [Stock Item Key], [Customer Key], [Supplier Key], [Transaction Type Key],
            [WWI Stock Item Transaction ID], [WWI Invoice ID], [WWI Purchase Order ID], Quantity, [Lineage Key])
    SELECT [Date Key], [Stock Item Key], [Customer Key], [Supplier Key], [Transaction Type Key],
            [WWI Stock Item Transaction ID], [WWI Invoice ID], [WWI Purchase Order ID], Quantity, @LineageKey
			FROM Integration.Movement_Staging
			WHERE [WWI Stock Item Transaction ID] NOT IN (SELECT [WWI Stock Item Transaction ID] FROM FACT.MOVEMENT);
	
	UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Movement'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Movement';
    COMMIT;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedOrderData]    Script Date: 6/25/2020 4:19:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedOrderData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Order'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

 UPDATE o
        SET o.[City Key] = COALESCE((SELECT TOP(1) c.[City Key]
                                     FROM Dimension.City AS c
                                     WHERE c.[WWI City ID] = o.[WWI City ID]
                                     AND o.[Last Modified When] > c.[Valid From]
                                     AND o.[Last Modified When] <= c.[Valid To]
									 ORDER BY c.[Valid From]), 0),
            o.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                         FROM Dimension.Customer AS c
                                         WHERE c.[WWI Customer ID] = o.[WWI Customer ID]
                                         AND o.[Last Modified When] > c.[Valid From]
                                         AND o.[Last Modified When] <= c.[Valid To]
    									 ORDER BY c.[Valid From]), 0),
            o.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = o.[WWI Stock Item ID]
                                           AND o.[Last Modified When] > si.[Valid From]
                                           AND o.[Last Modified When] <= si.[Valid To]
					                       ORDER BY si.[Valid From]), 0),
            o.[Salesperson Key] = COALESCE((SELECT TOP(1) e.[Employee Key]
                                         FROM Dimension.Employee AS e
                                         WHERE e.[WWI Employee ID] = o.[WWI Salesperson ID]
                                         AND o.[Last Modified When] > e.[Valid From]
                                         AND o.[Last Modified When] <= e.[Valid To]
									     ORDER BY e.[Valid From]), 0),
            o.[Picker Key] = COALESCE((SELECT TOP(1) e.[Employee Key]
                                       FROM Dimension.Employee AS e
                                       WHERE e.[WWI Employee ID] = o.[WWI Picker ID]
                                       AND o.[Last Modified When] > e.[Valid From]
                                       AND o.[Last Modified When] <= e.[Valid To]
									   ORDER BY e.[Valid From]), 0)
    FROM Integration.Order_Staging AS o;

    -- Remove any existing entries for any of these orders
	DELETE o
    FROM Fact.[Order] AS o
    WHERE o.[WWI Order ID] IN (SELECT [WWI Order ID] FROM Integration.Order_Staging);
    
    -- Insert all current details for these orders

    INSERT Fact.[Order]
        ([City Key], [Customer Key], [Stock Item Key], [Order Date Key], [Picked Date Key],
         [Salesperson Key], [Picker Key], [WWI Order ID], [WWI Backorder ID], [Description],
         Package, Quantity, [Unit Price], [Tax Rate], [Total Excluding Tax], [Tax Amount],
         [Total Including Tax], [Lineage Key])
    SELECT [City Key], [Customer Key], [Stock Item Key], [Order Date Key], [Picked Date Key],
           [Salesperson Key], [Picker Key], [WWI Order ID], [WWI Backorder ID], [Description],
           Package, Quantity, [Unit Price], [Tax Rate], [Total Excluding Tax], [Tax Amount],
           [Total Including Tax], @LineageKey
    FROM Integration.Order_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Order'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Order';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedPaymentMethodData]    Script Date: 6/25/2020 1:18:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedPaymentMethodData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Payment Method'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

WITH RowsToCloseOff
    AS
    (
        SELECT pm.[WWI Payment Method ID], MIN(pm.[Valid From]) AS [Valid From]
        FROM Integration.PaymentMethod_Staging AS pm
        GROUP BY pm.[WWI Payment Method ID]
    )
    UPDATE pm
        SET pm.[Valid To] = rtco.[Valid From]
    FROM Dimension.[Payment Method] AS pm
    INNER JOIN RowsToCloseOff AS rtco
    ON pm.[WWI Payment Method ID] = rtco.[WWI Payment Method ID]
    WHERE pm.[Valid To] = @EndOfTime;

    INSERT Dimension.[Payment Method]
        ([WWI Payment Method ID], [Payment Method], [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Payment Method ID], [Payment Method], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.PaymentMethod_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Payment Method'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Payment Method';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedPurchaseData]    Script Date: 6/25/2020 4:20:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedPurchaseData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Purchase'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

    UPDATE p
        SET p.[Supplier Key] = COALESCE((SELECT TOP(1) s.[Supplier Key]
                                     FROM Dimension.Supplier AS s
                                     WHERE s.[WWI Supplier ID] = p.[WWI Supplier ID]
                                     AND p.[Last Modified When] > s.[Valid From]
                                     AND p.[Last Modified When] <= s.[Valid To]
									 ORDER BY s.[Valid From]), 0),
            p.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = p.[WWI Stock Item ID]
                                           AND p.[Last Modified When] > si.[Valid From]
                                           AND p.[Last Modified When] <= si.[Valid To]
									       ORDER BY si.[Valid From]), 0)
    FROM Integration.Purchase_Staging AS p;

    -- Remove any existing entries for any of these purchase orders

    DELETE p
    FROM Fact.Purchase AS p
    WHERE p.[WWI Purchase Order ID] IN (SELECT [WWI Purchase Order ID] FROM Integration.Purchase_Staging);

    -- Insert all current details for these purchase orders

    INSERT Fact.Purchase
        ([Date Key], [Supplier Key], [Stock Item Key], [WWI Purchase Order ID], [Ordered Outers], [Ordered Quantity],
         [Received Outers], Package, [Is Order Finalized], [Lineage Key])
    SELECT [Date Key], [Supplier Key], [Stock Item Key], [WWI Purchase Order ID], [Ordered Outers], [Ordered Quantity],
           [Received Outers], Package, [Is Order Finalized], @LineageKey
    FROM Integration.Purchase_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Purchase'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Purchase';

    COMMIT;

   -- RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedSaleData]    Script Date: 6/25/2020 4:21:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedSaleData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Sale'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

	-- Find the dimension keys required

	UPDATE s
        SET s.[City Key] = COALESCE((SELECT TOP(1) c.[City Key]
                                     FROM Dimension.City AS c
                                     WHERE c.[WWI City ID] = s.[WWI City ID]
                                     AND s.[Last Modified When] > c.[Valid From]
                                     AND s.[Last Modified When] <= c.[Valid To]
									 ORDER BY c.[Valid From]), 0),
            s.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                           FROM Dimension.Customer AS c
                                           WHERE c.[WWI Customer ID] = s.[WWI Customer ID]
                                           AND s.[Last Modified When] > c.[Valid From]
                                           AND s.[Last Modified When] <= c.[Valid To]
									       ORDER BY c.[Valid From]), 0),
            s.[Bill To Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                                 FROM Dimension.Customer AS c
                                                 WHERE c.[WWI Customer ID] = s.[WWI Bill To Customer ID]
                                                 AND s.[Last Modified When] > c.[Valid From]
                                                 AND s.[Last Modified When] <= c.[Valid To]
									             ORDER BY c.[Valid From]), 0),
            s.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = s.[WWI Stock Item ID]
                                           AND s.[Last Modified When] > si.[Valid From]
                                           AND s.[Last Modified When] <= si.[Valid To]
									       ORDER BY si.[Valid From]), 0),
            s.[Salesperson Key] = COALESCE((SELECT TOP(1) e.[Employee Key]
                                            FROM Dimension.Employee AS e
                                            WHERE e.[WWI Employee ID] = s.[WWI Salesperson ID]
                                            AND s.[Last Modified When] > e.[Valid From]
                                            AND s.[Last Modified When] <= e.[Valid To]
									        ORDER BY e.[Valid From]), 0)
    FROM Integration.Sale_Staging AS s;

    -- Remove any existing entries for any of these invoices

	DELETE s
    FROM Fact.Sale AS s
    WHERE s.[WWI Invoice ID] IN (SELECT [WWI Invoice ID] FROM Integration.Sale_Staging);


    -- Insert all current details for these invoices

    INSERT Fact.Sale
        ([City Key], [Customer Key], [Bill To Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key],
         [Salesperson Key], [WWI Invoice ID], [Description], Package, Quantity, [Unit Price], [Tax Rate],
         [Total Excluding Tax], [Tax Amount], Profit, [Total Including Tax], [Total Dry Items], [Total Chiller Items], [Lineage Key])
    SELECT [City Key], [Customer Key], [Bill To Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key],
           [Salesperson Key], [WWI Invoice ID], [Description], Package, Quantity, [Unit Price], [Tax Rate],
           [Total Excluding Tax], [Tax Amount], Profit, [Total Including Tax], [Total Dry Items], [Total Chiller Items], @LineageKey
    FROM Integration.Sale_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Sale'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Sale';

    COMMIT;

   -- RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedStockHoldingData]    Script Date: 6/25/2020 4:23:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedStockHoldingData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

	TRUNCATE TABLE Fact.[Stock Holding];

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Stock Holding'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

	UPDATE s
        SET s.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = s.[WWI Stock Item ID]
                                           ORDER BY si.[Valid To] DESC), 0)
    FROM Integration.StockHolding_Staging AS s;

    -- Remove all existing holdings

    --TRUNCATE TABLE Fact.[Stock Holding];

    -- Insert all current stock holdings

    INSERT Fact.[Stock Holding]
        ([Stock Item Key], [Quantity On Hand], [Bin Location], [Last Stocktake Quantity],
         [Last Cost Price], [Reorder Level], [Target Stock Level], [Lineage Key])
    SELECT [Stock Item Key], [Quantity On Hand], [Bin Location], [Last Stocktake Quantity],
           [Last Cost Price], [Reorder Level], [Target Stock Level], @LineageKey
    FROM Integration.StockHolding_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Stock Holding'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Stock Holding';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedStockItemData]    Script Date: 6/25/2020 1:19:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedStockItemData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Stock Item'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

 WITH RowsToCloseOff
    AS
    (
        SELECT s.[WWI Stock Item ID], MIN(s.[Valid From]) AS [Valid From]
        FROM Integration.StockItem_Staging AS s
        GROUP BY s.[WWI Stock Item ID]
    )
    UPDATE s
        SET s.[Valid To] = rtco.[Valid From]
    FROM Dimension.[Stock Item] AS s
    INNER JOIN RowsToCloseOff AS rtco
    ON s.[WWI Stock Item ID] = rtco.[WWI Stock Item ID]
    WHERE s.[Valid To] = @EndOfTime;

    INSERT Dimension.[Stock Item]
        ([WWI Stock Item ID], [Stock Item], Color, [Selling Package], [Buying Package],
         Brand, Size, [Lead Time Days], [Quantity Per Outer], [Is Chiller Stock],
         Barcode, [Tax Rate], [Unit Price], [Recommended Retail Price], [Typical Weight Per Unit],
         Photo, [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Stock Item ID], [Stock Item], Color, [Selling Package], [Buying Package],
           Brand, Size, [Lead Time Days], [Quantity Per Outer], [Is Chiller Stock],
           Barcode, [Tax Rate], [Unit Price], [Recommended Retail Price], [Typical Weight Per Unit],
           Photo, [Valid From], [Valid To],
           @LineageKey
    FROM Integration.StockItem_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Stock Item'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Stock Item';
    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedSupplierData]    Script Date: 6/25/2020 1:20:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedSupplierData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Supplier'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

   WITH RowsToCloseOff
    AS
    (
        SELECT s.[WWI Supplier ID], MIN(s.[Valid From]) AS [Valid From]
        FROM Integration.Supplier_Staging AS s
        GROUP BY s.[WWI Supplier ID]
    )
    UPDATE s
        SET s.[Valid To] = rtco.[Valid From]
    FROM Dimension.[Supplier] AS s
    INNER JOIN RowsToCloseOff AS rtco
    ON s.[WWI Supplier ID] = rtco.[WWI Supplier ID]
    WHERE s.[Valid To] = @EndOfTime;

    INSERT Dimension.[Supplier]
        ([WWI Supplier ID], Supplier, Category, [Primary Contact], [Supplier Reference],
         [Payment Days], [Postal Code], [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Supplier ID], Supplier, Category, [Primary Contact], [Supplier Reference],
           [Payment Days], [Postal Code], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.Supplier_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Supplier'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Supplier';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedTransactionData]    Script Date: 6/25/2020 4:24:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedTransactionData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Transaction'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

     UPDATE t
        SET t.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                         FROM Dimension.Customer AS c
                                         WHERE c.[WWI Customer ID] = t.[WWI Customer ID]
                                         AND t.[Last Modified When] > c.[Valid From]
                                         AND t.[Last Modified When] <= c.[Valid To]
									     ORDER BY c.[Valid From]), 0),
            t.[Bill To Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                                 FROM Dimension.Customer AS c
                                                 WHERE c.[WWI Customer ID] = t.[WWI Bill To Customer ID]
                                                 AND t.[Last Modified When] > c.[Valid From]
                                                 AND t.[Last Modified When] <= c.[Valid To]
									             ORDER BY c.[Valid From]), 0),
            t.[Supplier Key] = COALESCE((SELECT TOP(1) s.[Supplier Key]
                                         FROM Dimension.Supplier AS s
                                         WHERE s.[WWI Supplier ID] = t.[WWI Supplier ID]
                                         AND t.[Last Modified When] > s.[Valid From]
                                         AND t.[Last Modified When] <= s.[Valid To]
									     ORDER BY s.[Valid From]), 0),
            t.[Transaction Type Key] = COALESCE((SELECT TOP(1) tt.[Transaction Type Key]
                                                 FROM Dimension.[Transaction Type] AS tt
                                                 WHERE tt.[WWI Transaction Type ID] = t.[WWI Transaction Type ID]
                                                 AND t.[Last Modified When] > tt.[Valid From]
                                                 AND t.[Last Modified When] <= tt.[Valid To]
									             ORDER BY tt.[Valid From]), 0),
            t.[Payment Method Key] = COALESCE((SELECT TOP(1) pm.[Payment Method Key]
                                                 FROM Dimension.[Payment Method] AS pm
                                                 WHERE pm.[WWI Payment Method ID] = t.[WWI Payment Method ID]
                                                 AND t.[Last Modified When] > pm.[Valid From]
                                                 AND t.[Last Modified When] <= pm.[Valid To]
									             ORDER BY pm.[Valid From]), 0)
    FROM Integration.Transaction_Staging AS t;

    -- Insert all the transactions

    INSERT Fact.[Transaction]
        ([Date Key], [Customer Key], [Bill To Customer Key], [Supplier Key], [Transaction Type Key],
         [Payment Method Key], [WWI Customer Transaction ID], [WWI Supplier Transaction ID],
         [WWI Invoice ID], [WWI Purchase Order ID], [Supplier Invoice Number], [Total Excluding Tax],
         [Tax Amount], [Total Including Tax], [Outstanding Balance], [Is Finalized], [Lineage Key], [WWI Transaction ID])
    SELECT [Date Key], [Customer Key], [Bill To Customer Key], [Supplier Key], [Transaction Type Key],
         [Payment Method Key], [WWI Customer Transaction ID], [WWI Supplier Transaction ID],
         [WWI Invoice ID], [WWI Purchase Order ID], [Supplier Invoice Number], [Total Excluding Tax],
         [Tax Amount], [Total Including Tax], [Outstanding Balance], [Is Finalized], @LineageKey, case when [WWI Customer Transaction ID] IS NULL THEN [WWI Supplier Transaction ID]
	  else [WWI Customer Transaction ID] END as [WWI Transaction ID]
    FROM Integration.Transaction_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Transaction'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Transaction';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedTransactionTypeData]    Script Date: 6/25/2020 1:21:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[MigrateStagedTransactionTypeData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Transaction Type'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

 WITH RowsToCloseOff
    AS
    (
        SELECT pm.[WWI Transaction Type ID], MIN(pm.[Valid From]) AS [Valid From]
        FROM Integration.TransactionType_Staging AS pm
        GROUP BY pm.[WWI Transaction Type ID]
    )
    UPDATE pm
        SET pm.[Valid To] = rtco.[Valid From]
    FROM Dimension.[Transaction Type] AS pm
    INNER JOIN RowsToCloseOff AS rtco
    ON pm.[WWI Transaction Type ID] = rtco.[WWI Transaction Type ID]
    WHERE pm.[Valid To] = @EndOfTime;

    INSERT Dimension.[Transaction Type]
        ([WWI Transaction Type ID], [Transaction Type], [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Transaction Type ID], [Transaction Type], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.TransactionType_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Transaction Type'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Transaction Type';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[PopulateDateDimensionForYear]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[PopulateDateDimensionForYear] @YearNumber [int] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @DateCounter date = DATEFROMPARTS(@YearNumber, 1, 1);

    BEGIN TRY;

        BEGIN TRAN;

        WHILE YEAR(@DateCounter) = @YearNumber
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Dimension.[Date] WHERE [Date] = @DateCounter)
            BEGIN
                INSERT Dimension.[Date]
                    ([Date], [Day Number], [Day], [Month], [Short Month],
                     [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label],
                     [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label],
                     [ISO Week Number])
				  SELECT @DateCounter AS [Date],
							  DAY(@DateCounter) AS [Day Number],
							  CAST(DATENAME(day, @DateCounter) AS nvarchar(10)) AS [Day],
							  CAST(DATENAME(month, @DateCounter) AS nvarchar(10)) AS [Month],
							  CAST(SUBSTRING(DATENAME(month, @DateCounter), 1, 3) AS nvarchar(3)) AS [Short Month],
							  MONTH(@DateCounter) AS [Calendar Month Number],
							  CAST(N'CY' + CAST(YEAR(@DateCounter) AS nvarchar(4)) + N'-' + SUBSTRING(DATENAME(month, @DateCounter), 1, 3) AS nvarchar(10)) AS [Calendar Month Label],
							  YEAR(@DateCounter) AS [Calendar Year],
							  CAST(N'CY' + CAST(YEAR(@DateCounter) AS nvarchar(4)) AS nvarchar(10)) AS [Calendar Year Label],
							  CASE WHEN MONTH(@DateCounter) IN (11, 12)
								   THEN MONTH(@DateCounter) - 10
								   ELSE MONTH(@DateCounter) + 2
							  END AS [Fiscal Month Number],
							  CAST(N'FY' + CAST(CASE WHEN MONTH(@DateCounter) IN (11, 12)
													 THEN YEAR(@DateCounter) + 1
													 ELSE YEAR(@DateCounter)
												END AS nvarchar(4)) + N'-' + SUBSTRING(DATENAME(month, @DateCounter), 1, 3) AS nvarchar(20)) AS [Fiscal Month Label],
							  CASE WHEN MONTH(@DateCounter) IN (11, 12)
								   THEN YEAR(@DateCounter) + 1
								   ELSE YEAR(@DateCounter)
							  END AS [Fiscal Year],
							  CAST(N'FY' + CAST(CASE WHEN MONTH(@DateCounter) IN (11, 12)
													 THEN YEAR(@DateCounter) + 1
													 ELSE YEAR(@DateCounter)
												END AS nvarchar(4)) AS nvarchar(10)) AS [Fiscal Year Label],
							  DATEPART(ISO_WEEK, @DateCounter) AS [ISO Week Number]
							END;
							SET @DateCounter = DATEADD(day, 1, @DateCounter);
        END;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT N'Unable to populate dates for the year';
        THROW;
        --RETURN -1;
    END CATCH;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[Configuration_ReseedETL]    Script Date: 6/03/2020 5:08:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[Configuration_ReseedETL] AS

BEGIN

	SET NOCOUNT ON;



	DECLARE @StartingETLCutoffTime datetime2(7) = '20121231';

	DECLARE @EndingETLCutoffTime datetime2(7) = '20200101';

	DECLARE @StartOfTime datetime2(7) = '20130101';

	DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';



IF EXISTS(select * from [Integration].[Load_Control])
   update Integration.[Load_Control] 
		SET [Load_Date] = @EndingETLCutoffTime
ELSE
   insert into Integration.[Load_Control] values(@EndingETLCutoffTime);


	UPDATE Integration.[ETL Cutoff]

		SET [Cutoff Time] = @StartingETLCutoffTime;


	TRUNCATE TABLE Fact.Movement;

	TRUNCATE TABLE Fact.[Order];

	TRUNCATE TABLE Fact.Purchase;

	TRUNCATE TABLE Fact.Sale;

	TRUNCATE TABLE Fact.[Stock Holding];

	TRUNCATE TABLE Fact.[Transaction];

	TRUNCATE TABLE INtegration.City_Staging;

	TRUNCATE TABLE INtegration.Customer_Staging;

	TRUNCATE TABLE INtegration.Employee_Staging;

	TRUNCATE TABLE INtegration.Movement_Staging;

	TRUNCATE TABLE INtegration.Order_Staging;

	TRUNCATE TABLE INtegration.PaymentMethod_Staging;

	TRUNCATE TABLE INtegration.Purchase_Staging;

	TRUNCATE TABLE INtegration.Sale_Staging;

	TRUNCATE TABLE INtegration.StockHolding_Staging;

	TRUNCATE TABLE INtegration.StockItem_Staging;

	TRUNCATE TABLE INtegration.Supplier_Staging;

	TRUNCATE TABLE INtegration.Transaction_Staging;

	TRUNCATE TABLE Integration.TransactionType_Staging;

	DELETE Dimension.City;

	DELETE Dimension.Customer;

	DELETE Dimension.Employee;

	DELETE Dimension.[Payment Method];

	DELETE Dimension.[Stock Item];

	DELETE Dimension.Supplier;

	DELETE Dimension.[Transaction Type];


	SET IDENTITY_INSERT Dimension.City ON;
    INSERT Dimension.City

        ([City Key], [WWI City ID], City, [State Province], Country, Continent, [Sales Territory], Region, Subregion,

         [Latest Recorded Population], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A', N'N/A', N'N/A', N'N/A', N'N/A', N'N/A',

         0, @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.City OFF;

	SET IDENTITY_INSERT Dimension.Customer ON;
    INSERT Dimension.Customer

        ([Customer Key], [WWI Customer ID], [Customer], [Bill To Customer], Category, [Buying Group],

         [Primary Contact], [Postal Code], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A', N'N/A', N'N/A',

         N'N/A', N'N/A', @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.Customer OFF;

	SET IDENTITY_INSERT Dimension.Employee ON;
    INSERT Dimension.Employee

        ([Employee Key], [WWI Employee ID], Employee, [Preferred Name],

         [Is Salesperson], Photo, [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A',
         0, NULL, @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.Employee OFF;

	SET IDENTITY_INSERT Dimension.[Payment Method] ON;
    INSERT Dimension.[Payment Method]

        ([Payment Method Key], [WWI Payment Method ID], [Payment Method], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.[Payment Method] OFF;

	SET IDENTITY_INSERT Dimension.[Stock Item] ON;
    INSERT Dimension.[Stock Item]

        ([Stock Item Key], [WWI Stock Item ID], [Stock Item], Color, [Selling Package], [Buying Package],

         Brand, Size, [Lead Time Days], [Quantity Per Outer], [Is Chiller Stock],

         Barcode, [Tax Rate], [Unit Price], [Recommended Retail Price], [Typical Weight Per Unit],

         Photo, [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A', N'N/A', N'N/A',

         N'N/A', N'N/A', 0, 0, 0,

         N'N/A', 0, 0, 0, 0,

         NULL, @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.[Stock Item] OFF

	SET IDENTITY_INSERT Dimension.[Supplier] ON;
    INSERT Dimension.[Supplier]

        ([Supplier Key], [WWI Supplier ID], Supplier, Category, [Primary Contact], [Supplier Reference],

         [Payment Days], [Postal Code], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A', N'N/A', N'N/A',

         0, N'N/A', @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.[Supplier] OFF

	SET IDENTITY_INSERT Dimension.[Transaction Type] ON;
    INSERT Dimension.[Transaction Type]

        ([Transaction Type Key], [WWI Transaction Type ID], [Transaction Type], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.[Transaction Type] OFF;

END;
GO

--Preload tables.
TRUNCATE TABLE [Integration].[Load_Control]
INSERT INTO [Integration].[Load_Control]([Load_Date]) VALUES('2020-01-01 23:59:59.0000000')

TRUNCATE TABLE [Integration].[ETL Cutoff] 
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('City','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Customer','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Date','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Employee','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Movement','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Order','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Payment Method','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Purchase','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Sale','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Stock Holding','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Stock Item','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Supplier','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Transaction','2012-12-31 00:00:00.0000000')
INSERT INTO [Integration].[ETL Cutoff]([Table Name],[Cutoff Time]) VALUES ('Transaction Type','2012-12-31 00:00:00.0000000')

TRUNCATE TABLE Integration.Lineage
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:36:16.5814702','City','2016-06-06 12:36:49.0592140',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:36:49.0748362','Customer','2016-06-06 12:36:49.7154516',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:36:49.7310770','Employee','2016-06-06 12:36:49.9654784',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:36:49.9810784','Payment Method','2016-06-06 12:36:50.0748072',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:36:50.0748072','Stock Item','2016-06-06 12:36:50.4342030',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:36:50.4498392','Supplier','2016-06-06 12:36:50.5904519',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:36:50.5904519','Transaction Type','2016-06-06 12:36:50.6842030',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:36:50.6998369','Movement','2016-06-06 12:37:00.9810989',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:37:00.9967252','Order','2016-06-06 12:37:12.4655543',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:37:12.4811498','Purchase','2016-06-06 12:37:13.2624167',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:37:13.2624167','Sale','2016-06-06 12:37:24.6856386',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:37:24.7012613','Stock Holding','2016-06-06 12:37:24.8106071',1,'2016-06-06 12:31:17.0000000')
INSERT INTO [Integration].[Lineage]([Data Load Started],[Table Name],[Data Load Completed],[Was Successful],[Source System Cutoff Time]) VALUES('2016-06-06 12:37:24.8106071','Transaction','2016-06-06 12:37:28.4200431',1,'2016-06-06 12:31:17.0000000')

TRUNCATE TABLE [Dimension].[Date]
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-01', 1, N'1', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-02', 2, N'2', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-03', 3, N'3', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-04', 4, N'4', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-05', 5, N'5', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-06', 6, N'6', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-07', 7, N'7', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-08', 8, N'8', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-09', 9, N'9', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-10', 10, N'10', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-11', 11, N'11', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-12', 12, N'12', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-13', 13, N'13', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-14', 14, N'14', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-15', 15, N'15', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-16', 16, N'16', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-17', 17, N'17', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-18', 18, N'18', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-19', 19, N'19', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-20', 20, N'20', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-21', 21, N'21', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-22', 22, N'22', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-23', 23, N'23', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-24', 24, N'24', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-25', 25, N'25', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-26', 26, N'26', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-27', 27, N'27', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-28', 28, N'28', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-29', 29, N'29', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-30', 30, N'30', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-01-31', 31, N'31', N'January', N'Jan', 1, N'CY2013-Jan', 2013, N'CY2013', 3, N'FY2013-Jan', 2013, N'FY2013', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-01', 1, N'1', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-02', 2, N'2', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-03', 3, N'3', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-04', 4, N'4', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-05', 5, N'5', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-06', 6, N'6', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-07', 7, N'7', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-08', 8, N'8', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-09', 9, N'9', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-10', 10, N'10', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-11', 11, N'11', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-12', 12, N'12', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-13', 13, N'13', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-14', 14, N'14', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-15', 15, N'15', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-16', 16, N'16', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-17', 17, N'17', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-18', 18, N'18', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-19', 19, N'19', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-20', 20, N'20', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-21', 21, N'21', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-22', 22, N'22', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-23', 23, N'23', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-24', 24, N'24', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-25', 25, N'25', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-26', 26, N'26', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-27', 27, N'27', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-02-28', 28, N'28', N'February', N'Feb', 2, N'CY2013-Feb', 2013, N'CY2013', 4, N'FY2013-Feb', 2013, N'FY2013', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-01', 1, N'1', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-02', 2, N'2', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-03', 3, N'3', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-04', 4, N'4', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-05', 5, N'5', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-06', 6, N'6', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-07', 7, N'7', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-08', 8, N'8', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-09', 9, N'9', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-10', 10, N'10', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-11', 11, N'11', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-12', 12, N'12', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-13', 13, N'13', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-14', 14, N'14', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-15', 15, N'15', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-16', 16, N'16', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-17', 17, N'17', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-18', 18, N'18', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-19', 19, N'19', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-20', 20, N'20', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-21', 21, N'21', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-22', 22, N'22', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-23', 23, N'23', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-24', 24, N'24', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-25', 25, N'25', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-26', 26, N'26', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-27', 27, N'27', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-28', 28, N'28', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-29', 29, N'29', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-30', 30, N'30', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-03-31', 31, N'31', N'March', N'Mar', 3, N'CY2013-Mar', 2013, N'CY2013', 5, N'FY2013-Mar', 2013, N'FY2013', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-01', 1, N'1', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-02', 2, N'2', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-03', 3, N'3', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-04', 4, N'4', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-05', 5, N'5', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-06', 6, N'6', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-07', 7, N'7', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-08', 8, N'8', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-09', 9, N'9', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-10', 10, N'10', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-11', 11, N'11', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-12', 12, N'12', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-13', 13, N'13', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-14', 14, N'14', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-15', 15, N'15', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-16', 16, N'16', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-17', 17, N'17', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-18', 18, N'18', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-19', 19, N'19', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-20', 20, N'20', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-21', 21, N'21', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-22', 22, N'22', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-23', 23, N'23', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-24', 24, N'24', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-25', 25, N'25', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-26', 26, N'26', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-27', 27, N'27', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-28', 28, N'28', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-29', 29, N'29', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-04-30', 30, N'30', N'April', N'Apr', 4, N'CY2013-Apr', 2013, N'CY2013', 6, N'FY2013-Apr', 2013, N'FY2013', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-01', 1, N'1', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-02', 2, N'2', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-03', 3, N'3', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-04', 4, N'4', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-05', 5, N'5', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-06', 6, N'6', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-07', 7, N'7', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-08', 8, N'8', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-09', 9, N'9', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-10', 10, N'10', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-11', 11, N'11', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-12', 12, N'12', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-13', 13, N'13', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-14', 14, N'14', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-15', 15, N'15', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-16', 16, N'16', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-17', 17, N'17', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-18', 18, N'18', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-19', 19, N'19', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-20', 20, N'20', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-21', 21, N'21', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-22', 22, N'22', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-23', 23, N'23', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-24', 24, N'24', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-25', 25, N'25', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-26', 26, N'26', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-27', 27, N'27', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-28', 28, N'28', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-29', 29, N'29', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-30', 30, N'30', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-05-31', 31, N'31', N'May', N'May', 5, N'CY2013-May', 2013, N'CY2013', 7, N'FY2013-May', 2013, N'FY2013', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-01', 1, N'1', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-02', 2, N'2', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-03', 3, N'3', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-04', 4, N'4', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-05', 5, N'5', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-06', 6, N'6', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-07', 7, N'7', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-08', 8, N'8', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-09', 9, N'9', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-10', 10, N'10', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-11', 11, N'11', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-12', 12, N'12', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-13', 13, N'13', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-14', 14, N'14', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-15', 15, N'15', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-16', 16, N'16', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-17', 17, N'17', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-18', 18, N'18', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-19', 19, N'19', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-20', 20, N'20', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-21', 21, N'21', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-22', 22, N'22', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-23', 23, N'23', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-24', 24, N'24', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-25', 25, N'25', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-26', 26, N'26', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-27', 27, N'27', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-28', 28, N'28', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-29', 29, N'29', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-06-30', 30, N'30', N'June', N'Jun', 6, N'CY2013-Jun', 2013, N'CY2013', 8, N'FY2013-Jun', 2013, N'FY2013', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-01', 1, N'1', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-02', 2, N'2', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-03', 3, N'3', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-04', 4, N'4', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-05', 5, N'5', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-06', 6, N'6', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-07', 7, N'7', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-08', 8, N'8', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-09', 9, N'9', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-10', 10, N'10', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-11', 11, N'11', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-12', 12, N'12', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-13', 13, N'13', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-14', 14, N'14', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-15', 15, N'15', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-16', 16, N'16', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-17', 17, N'17', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-18', 18, N'18', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-19', 19, N'19', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-20', 20, N'20', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-21', 21, N'21', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-22', 22, N'22', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-23', 23, N'23', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-24', 24, N'24', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-25', 25, N'25', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-26', 26, N'26', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-27', 27, N'27', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-28', 28, N'28', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-29', 29, N'29', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-30', 30, N'30', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-07-31', 31, N'31', N'July', N'Jul', 7, N'CY2013-Jul', 2013, N'CY2013', 9, N'FY2013-Jul', 2013, N'FY2013', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-01', 1, N'1', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-02', 2, N'2', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-03', 3, N'3', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-04', 4, N'4', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-05', 5, N'5', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-06', 6, N'6', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-07', 7, N'7', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-08', 8, N'8', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-09', 9, N'9', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-10', 10, N'10', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-11', 11, N'11', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-12', 12, N'12', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-13', 13, N'13', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-14', 14, N'14', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-15', 15, N'15', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-16', 16, N'16', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-17', 17, N'17', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-18', 18, N'18', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-19', 19, N'19', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-20', 20, N'20', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-21', 21, N'21', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-22', 22, N'22', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-23', 23, N'23', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-24', 24, N'24', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-25', 25, N'25', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-26', 26, N'26', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-27', 27, N'27', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-28', 28, N'28', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-29', 29, N'29', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-30', 30, N'30', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-08-31', 31, N'31', N'August', N'Aug', 8, N'CY2013-Aug', 2013, N'CY2013', 10, N'FY2013-Aug', 2013, N'FY2013', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-01', 1, N'1', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-02', 2, N'2', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-03', 3, N'3', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-04', 4, N'4', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-05', 5, N'5', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-06', 6, N'6', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-07', 7, N'7', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-08', 8, N'8', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-09', 9, N'9', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-10', 10, N'10', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-11', 11, N'11', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-12', 12, N'12', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-13', 13, N'13', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-14', 14, N'14', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-15', 15, N'15', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-16', 16, N'16', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-17', 17, N'17', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-18', 18, N'18', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-19', 19, N'19', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-20', 20, N'20', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-21', 21, N'21', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-22', 22, N'22', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-23', 23, N'23', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-24', 24, N'24', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-25', 25, N'25', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-26', 26, N'26', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-27', 27, N'27', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-28', 28, N'28', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-29', 29, N'29', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-09-30', 30, N'30', N'September', N'Sep', 9, N'CY2013-Sep', 2013, N'CY2013', 11, N'FY2013-Sep', 2013, N'FY2013', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-01', 1, N'1', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-02', 2, N'2', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-03', 3, N'3', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-04', 4, N'4', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-05', 5, N'5', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-06', 6, N'6', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-07', 7, N'7', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-08', 8, N'8', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-09', 9, N'9', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-10', 10, N'10', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-11', 11, N'11', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-12', 12, N'12', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-13', 13, N'13', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-14', 14, N'14', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-15', 15, N'15', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-16', 16, N'16', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-17', 17, N'17', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-18', 18, N'18', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-19', 19, N'19', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-20', 20, N'20', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-21', 21, N'21', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-22', 22, N'22', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-23', 23, N'23', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-24', 24, N'24', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-25', 25, N'25', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-26', 26, N'26', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-27', 27, N'27', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-28', 28, N'28', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-29', 29, N'29', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-30', 30, N'30', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-10-31', 31, N'31', N'October', N'Oct', 10, N'CY2013-Oct', 2013, N'CY2013', 12, N'FY2013-Oct', 2013, N'FY2013', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-01', 1, N'1', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-02', 2, N'2', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-03', 3, N'3', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-04', 4, N'4', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-05', 5, N'5', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-06', 6, N'6', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-07', 7, N'7', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-08', 8, N'8', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-09', 9, N'9', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-10', 10, N'10', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-11', 11, N'11', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-12', 12, N'12', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-13', 13, N'13', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-14', 14, N'14', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-15', 15, N'15', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-16', 16, N'16', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-17', 17, N'17', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-18', 18, N'18', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-19', 19, N'19', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-20', 20, N'20', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-21', 21, N'21', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-22', 22, N'22', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-23', 23, N'23', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-24', 24, N'24', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-25', 25, N'25', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-26', 26, N'26', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-27', 27, N'27', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-28', 28, N'28', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-29', 29, N'29', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-11-30', 30, N'30', N'November', N'Nov', 11, N'CY2013-Nov', 2013, N'CY2013', 1, N'FY2014-Nov', 2014, N'FY2014', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-01', 1, N'1', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-02', 2, N'2', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-03', 3, N'3', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-04', 4, N'4', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-05', 5, N'5', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-06', 6, N'6', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-07', 7, N'7', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-08', 8, N'8', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-09', 9, N'9', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-10', 10, N'10', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-11', 11, N'11', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-12', 12, N'12', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-13', 13, N'13', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-14', 14, N'14', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-15', 15, N'15', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-16', 16, N'16', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-17', 17, N'17', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-18', 18, N'18', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-19', 19, N'19', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-20', 20, N'20', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-21', 21, N'21', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-22', 22, N'22', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-23', 23, N'23', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-24', 24, N'24', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-25', 25, N'25', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-26', 26, N'26', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-27', 27, N'27', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-28', 28, N'28', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-29', 29, N'29', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-30', 30, N'30', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2013-12-31', 31, N'31', N'December', N'Dec', 12, N'CY2013-Dec', 2013, N'CY2013', 2, N'FY2014-Dec', 2014, N'FY2014', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-01', 1, N'1', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-02', 2, N'2', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-03', 3, N'3', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-04', 4, N'4', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-05', 5, N'5', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-06', 6, N'6', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-07', 7, N'7', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-08', 8, N'8', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-09', 9, N'9', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-10', 10, N'10', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-11', 11, N'11', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-12', 12, N'12', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-13', 13, N'13', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-14', 14, N'14', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-15', 15, N'15', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-16', 16, N'16', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-17', 17, N'17', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-18', 18, N'18', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-19', 19, N'19', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-20', 20, N'20', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-21', 21, N'21', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-22', 22, N'22', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-23', 23, N'23', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-24', 24, N'24', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-25', 25, N'25', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-26', 26, N'26', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-27', 27, N'27', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-28', 28, N'28', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-29', 29, N'29', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-30', 30, N'30', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-01-31', 31, N'31', N'January', N'Jan', 1, N'CY2014-Jan', 2014, N'CY2014', 3, N'FY2014-Jan', 2014, N'FY2014', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-01', 1, N'1', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-02', 2, N'2', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-03', 3, N'3', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-04', 4, N'4', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-05', 5, N'5', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-06', 6, N'6', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-07', 7, N'7', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-08', 8, N'8', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-09', 9, N'9', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-10', 10, N'10', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-11', 11, N'11', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-12', 12, N'12', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-13', 13, N'13', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-14', 14, N'14', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-15', 15, N'15', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-16', 16, N'16', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-17', 17, N'17', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-18', 18, N'18', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-19', 19, N'19', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-20', 20, N'20', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-21', 21, N'21', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-22', 22, N'22', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-23', 23, N'23', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-24', 24, N'24', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-25', 25, N'25', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-26', 26, N'26', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-27', 27, N'27', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-02-28', 28, N'28', N'February', N'Feb', 2, N'CY2014-Feb', 2014, N'CY2014', 4, N'FY2014-Feb', 2014, N'FY2014', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-01', 1, N'1', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-02', 2, N'2', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-03', 3, N'3', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-04', 4, N'4', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-05', 5, N'5', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-06', 6, N'6', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-07', 7, N'7', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-08', 8, N'8', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-09', 9, N'9', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-10', 10, N'10', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-11', 11, N'11', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-12', 12, N'12', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-13', 13, N'13', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-14', 14, N'14', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-15', 15, N'15', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-16', 16, N'16', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-17', 17, N'17', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-18', 18, N'18', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-19', 19, N'19', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-20', 20, N'20', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-21', 21, N'21', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-22', 22, N'22', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-23', 23, N'23', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-24', 24, N'24', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-25', 25, N'25', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-26', 26, N'26', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-27', 27, N'27', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-28', 28, N'28', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-29', 29, N'29', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-30', 30, N'30', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-03-31', 31, N'31', N'March', N'Mar', 3, N'CY2014-Mar', 2014, N'CY2014', 5, N'FY2014-Mar', 2014, N'FY2014', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-01', 1, N'1', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-02', 2, N'2', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-03', 3, N'3', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-04', 4, N'4', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-05', 5, N'5', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-06', 6, N'6', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-07', 7, N'7', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-08', 8, N'8', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-09', 9, N'9', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-10', 10, N'10', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-11', 11, N'11', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-12', 12, N'12', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-13', 13, N'13', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-14', 14, N'14', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-15', 15, N'15', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-16', 16, N'16', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-17', 17, N'17', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-18', 18, N'18', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-19', 19, N'19', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-20', 20, N'20', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-21', 21, N'21', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-22', 22, N'22', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-23', 23, N'23', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-24', 24, N'24', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-25', 25, N'25', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-26', 26, N'26', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-27', 27, N'27', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-28', 28, N'28', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-29', 29, N'29', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-04-30', 30, N'30', N'April', N'Apr', 4, N'CY2014-Apr', 2014, N'CY2014', 6, N'FY2014-Apr', 2014, N'FY2014', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-01', 1, N'1', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-02', 2, N'2', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-03', 3, N'3', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-04', 4, N'4', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-05', 5, N'5', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-06', 6, N'6', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-07', 7, N'7', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-08', 8, N'8', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-09', 9, N'9', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-10', 10, N'10', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-11', 11, N'11', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-12', 12, N'12', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-13', 13, N'13', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-14', 14, N'14', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-15', 15, N'15', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-16', 16, N'16', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-17', 17, N'17', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-18', 18, N'18', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-19', 19, N'19', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-20', 20, N'20', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-21', 21, N'21', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-22', 22, N'22', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-23', 23, N'23', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-24', 24, N'24', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-25', 25, N'25', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-26', 26, N'26', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-27', 27, N'27', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-28', 28, N'28', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-29', 29, N'29', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-30', 30, N'30', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-05-31', 31, N'31', N'May', N'May', 5, N'CY2014-May', 2014, N'CY2014', 7, N'FY2014-May', 2014, N'FY2014', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-01', 1, N'1', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-02', 2, N'2', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-03', 3, N'3', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-04', 4, N'4', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-05', 5, N'5', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-06', 6, N'6', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-07', 7, N'7', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-08', 8, N'8', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-09', 9, N'9', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-10', 10, N'10', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-11', 11, N'11', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-12', 12, N'12', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-13', 13, N'13', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-14', 14, N'14', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-15', 15, N'15', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-16', 16, N'16', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-17', 17, N'17', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-18', 18, N'18', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-19', 19, N'19', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-20', 20, N'20', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-21', 21, N'21', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-22', 22, N'22', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-23', 23, N'23', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-24', 24, N'24', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-25', 25, N'25', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-26', 26, N'26', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-27', 27, N'27', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-28', 28, N'28', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-29', 29, N'29', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-06-30', 30, N'30', N'June', N'Jun', 6, N'CY2014-Jun', 2014, N'CY2014', 8, N'FY2014-Jun', 2014, N'FY2014', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-01', 1, N'1', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-02', 2, N'2', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-03', 3, N'3', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-04', 4, N'4', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-05', 5, N'5', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-06', 6, N'6', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-07', 7, N'7', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-08', 8, N'8', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-09', 9, N'9', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-10', 10, N'10', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-11', 11, N'11', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-12', 12, N'12', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-13', 13, N'13', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-14', 14, N'14', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-15', 15, N'15', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-16', 16, N'16', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-17', 17, N'17', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-18', 18, N'18', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-19', 19, N'19', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-20', 20, N'20', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-21', 21, N'21', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-22', 22, N'22', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-23', 23, N'23', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-24', 24, N'24', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-25', 25, N'25', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-26', 26, N'26', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-27', 27, N'27', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-28', 28, N'28', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-29', 29, N'29', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-30', 30, N'30', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-07-31', 31, N'31', N'July', N'Jul', 7, N'CY2014-Jul', 2014, N'CY2014', 9, N'FY2014-Jul', 2014, N'FY2014', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-01', 1, N'1', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-02', 2, N'2', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-03', 3, N'3', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-04', 4, N'4', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-05', 5, N'5', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-06', 6, N'6', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-07', 7, N'7', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-08', 8, N'8', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-09', 9, N'9', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-10', 10, N'10', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-11', 11, N'11', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-12', 12, N'12', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-13', 13, N'13', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-14', 14, N'14', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-15', 15, N'15', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-16', 16, N'16', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-17', 17, N'17', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-18', 18, N'18', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-19', 19, N'19', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-20', 20, N'20', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-21', 21, N'21', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-22', 22, N'22', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-23', 23, N'23', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-24', 24, N'24', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-25', 25, N'25', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-26', 26, N'26', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-27', 27, N'27', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-28', 28, N'28', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-29', 29, N'29', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-30', 30, N'30', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-08-31', 31, N'31', N'August', N'Aug', 8, N'CY2014-Aug', 2014, N'CY2014', 10, N'FY2014-Aug', 2014, N'FY2014', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-01', 1, N'1', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-02', 2, N'2', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-03', 3, N'3', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-04', 4, N'4', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-05', 5, N'5', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-06', 6, N'6', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-07', 7, N'7', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-08', 8, N'8', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-09', 9, N'9', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-10', 10, N'10', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-11', 11, N'11', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-12', 12, N'12', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-13', 13, N'13', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-14', 14, N'14', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-15', 15, N'15', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-16', 16, N'16', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-17', 17, N'17', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-18', 18, N'18', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-19', 19, N'19', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-20', 20, N'20', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-21', 21, N'21', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-22', 22, N'22', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-23', 23, N'23', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-24', 24, N'24', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-25', 25, N'25', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-26', 26, N'26', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-27', 27, N'27', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-28', 28, N'28', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-29', 29, N'29', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-09-30', 30, N'30', N'September', N'Sep', 9, N'CY2014-Sep', 2014, N'CY2014', 11, N'FY2014-Sep', 2014, N'FY2014', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-01', 1, N'1', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-02', 2, N'2', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-03', 3, N'3', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-04', 4, N'4', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-05', 5, N'5', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-06', 6, N'6', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-07', 7, N'7', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-08', 8, N'8', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-09', 9, N'9', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-10', 10, N'10', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-11', 11, N'11', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-12', 12, N'12', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-13', 13, N'13', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-14', 14, N'14', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-15', 15, N'15', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-16', 16, N'16', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-17', 17, N'17', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-18', 18, N'18', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-19', 19, N'19', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-20', 20, N'20', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-21', 21, N'21', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-22', 22, N'22', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-23', 23, N'23', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-24', 24, N'24', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-25', 25, N'25', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-26', 26, N'26', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-27', 27, N'27', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-28', 28, N'28', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-29', 29, N'29', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-30', 30, N'30', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-10-31', 31, N'31', N'October', N'Oct', 10, N'CY2014-Oct', 2014, N'CY2014', 12, N'FY2014-Oct', 2014, N'FY2014', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-01', 1, N'1', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-02', 2, N'2', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-03', 3, N'3', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-04', 4, N'4', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-05', 5, N'5', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-06', 6, N'6', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-07', 7, N'7', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-08', 8, N'8', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-09', 9, N'9', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-10', 10, N'10', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-11', 11, N'11', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-12', 12, N'12', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-13', 13, N'13', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-14', 14, N'14', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-15', 15, N'15', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-16', 16, N'16', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-17', 17, N'17', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-18', 18, N'18', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-19', 19, N'19', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-20', 20, N'20', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-21', 21, N'21', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-22', 22, N'22', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-23', 23, N'23', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-24', 24, N'24', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-25', 25, N'25', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-26', 26, N'26', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-27', 27, N'27', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-28', 28, N'28', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-29', 29, N'29', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-11-30', 30, N'30', N'November', N'Nov', 11, N'CY2014-Nov', 2014, N'CY2014', 1, N'FY2015-Nov', 2015, N'FY2015', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-01', 1, N'1', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-02', 2, N'2', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-03', 3, N'3', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-04', 4, N'4', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-05', 5, N'5', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-06', 6, N'6', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-07', 7, N'7', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-08', 8, N'8', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-09', 9, N'9', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-10', 10, N'10', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-11', 11, N'11', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-12', 12, N'12', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-13', 13, N'13', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-14', 14, N'14', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-15', 15, N'15', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-16', 16, N'16', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-17', 17, N'17', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-18', 18, N'18', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-19', 19, N'19', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-20', 20, N'20', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-21', 21, N'21', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-22', 22, N'22', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-23', 23, N'23', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-24', 24, N'24', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-25', 25, N'25', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-26', 26, N'26', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-27', 27, N'27', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-28', 28, N'28', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-29', 29, N'29', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-30', 30, N'30', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2014-12-31', 31, N'31', N'December', N'Dec', 12, N'CY2014-Dec', 2014, N'CY2014', 2, N'FY2015-Dec', 2015, N'FY2015', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-01', 1, N'1', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-02', 2, N'2', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-03', 3, N'3', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-04', 4, N'4', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-05', 5, N'5', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-06', 6, N'6', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-07', 7, N'7', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-08', 8, N'8', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-09', 9, N'9', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-10', 10, N'10', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-11', 11, N'11', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-12', 12, N'12', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-13', 13, N'13', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-14', 14, N'14', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-15', 15, N'15', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-16', 16, N'16', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-17', 17, N'17', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-18', 18, N'18', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-19', 19, N'19', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-20', 20, N'20', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-21', 21, N'21', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-22', 22, N'22', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-23', 23, N'23', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-24', 24, N'24', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-25', 25, N'25', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-26', 26, N'26', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-27', 27, N'27', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-28', 28, N'28', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-29', 29, N'29', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-30', 30, N'30', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-01-31', 31, N'31', N'January', N'Jan', 1, N'CY2015-Jan', 2015, N'CY2015', 3, N'FY2015-Jan', 2015, N'FY2015', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-01', 1, N'1', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-02', 2, N'2', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-03', 3, N'3', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-04', 4, N'4', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-05', 5, N'5', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-06', 6, N'6', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-07', 7, N'7', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-08', 8, N'8', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-09', 9, N'9', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-10', 10, N'10', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-11', 11, N'11', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-12', 12, N'12', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-13', 13, N'13', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-14', 14, N'14', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-15', 15, N'15', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-16', 16, N'16', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-17', 17, N'17', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-18', 18, N'18', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-19', 19, N'19', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-20', 20, N'20', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-21', 21, N'21', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-22', 22, N'22', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-23', 23, N'23', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-24', 24, N'24', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-25', 25, N'25', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-26', 26, N'26', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-27', 27, N'27', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-02-28', 28, N'28', N'February', N'Feb', 2, N'CY2015-Feb', 2015, N'CY2015', 4, N'FY2015-Feb', 2015, N'FY2015', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-01', 1, N'1', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-02', 2, N'2', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-03', 3, N'3', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-04', 4, N'4', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-05', 5, N'5', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-06', 6, N'6', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-07', 7, N'7', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-08', 8, N'8', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-09', 9, N'9', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-10', 10, N'10', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-11', 11, N'11', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-12', 12, N'12', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-13', 13, N'13', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-14', 14, N'14', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-15', 15, N'15', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-16', 16, N'16', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-17', 17, N'17', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-18', 18, N'18', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-19', 19, N'19', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-20', 20, N'20', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-21', 21, N'21', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-22', 22, N'22', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-23', 23, N'23', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-24', 24, N'24', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-25', 25, N'25', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-26', 26, N'26', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-27', 27, N'27', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-28', 28, N'28', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-29', 29, N'29', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-30', 30, N'30', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-03-31', 31, N'31', N'March', N'Mar', 3, N'CY2015-Mar', 2015, N'CY2015', 5, N'FY2015-Mar', 2015, N'FY2015', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-01', 1, N'1', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-02', 2, N'2', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-03', 3, N'3', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-04', 4, N'4', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-05', 5, N'5', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-06', 6, N'6', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-07', 7, N'7', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-08', 8, N'8', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-09', 9, N'9', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-10', 10, N'10', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-11', 11, N'11', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-12', 12, N'12', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-13', 13, N'13', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-14', 14, N'14', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-15', 15, N'15', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-16', 16, N'16', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-17', 17, N'17', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-18', 18, N'18', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-19', 19, N'19', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-20', 20, N'20', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-21', 21, N'21', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-22', 22, N'22', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-23', 23, N'23', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-24', 24, N'24', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-25', 25, N'25', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-26', 26, N'26', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-27', 27, N'27', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-28', 28, N'28', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-29', 29, N'29', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-04-30', 30, N'30', N'April', N'Apr', 4, N'CY2015-Apr', 2015, N'CY2015', 6, N'FY2015-Apr', 2015, N'FY2015', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-01', 1, N'1', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-02', 2, N'2', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-03', 3, N'3', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-04', 4, N'4', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-05', 5, N'5', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-06', 6, N'6', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-07', 7, N'7', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-08', 8, N'8', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-09', 9, N'9', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-10', 10, N'10', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-11', 11, N'11', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-12', 12, N'12', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-13', 13, N'13', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-14', 14, N'14', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-15', 15, N'15', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-16', 16, N'16', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-17', 17, N'17', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-18', 18, N'18', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-19', 19, N'19', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-20', 20, N'20', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-21', 21, N'21', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-22', 22, N'22', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-23', 23, N'23', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-24', 24, N'24', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-25', 25, N'25', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-26', 26, N'26', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-27', 27, N'27', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-28', 28, N'28', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-29', 29, N'29', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-30', 30, N'30', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-05-31', 31, N'31', N'May', N'May', 5, N'CY2015-May', 2015, N'CY2015', 7, N'FY2015-May', 2015, N'FY2015', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-01', 1, N'1', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-02', 2, N'2', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-03', 3, N'3', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-04', 4, N'4', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-05', 5, N'5', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-06', 6, N'6', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-07', 7, N'7', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-08', 8, N'8', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-09', 9, N'9', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-10', 10, N'10', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-11', 11, N'11', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-12', 12, N'12', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-13', 13, N'13', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-14', 14, N'14', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-15', 15, N'15', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-16', 16, N'16', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-17', 17, N'17', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-18', 18, N'18', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-19', 19, N'19', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-20', 20, N'20', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-21', 21, N'21', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-22', 22, N'22', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-23', 23, N'23', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-24', 24, N'24', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-25', 25, N'25', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-26', 26, N'26', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-27', 27, N'27', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-28', 28, N'28', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-29', 29, N'29', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-06-30', 30, N'30', N'June', N'Jun', 6, N'CY2015-Jun', 2015, N'CY2015', 8, N'FY2015-Jun', 2015, N'FY2015', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-01', 1, N'1', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-02', 2, N'2', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-03', 3, N'3', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-04', 4, N'4', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-05', 5, N'5', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-06', 6, N'6', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-07', 7, N'7', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-08', 8, N'8', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-09', 9, N'9', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-10', 10, N'10', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-11', 11, N'11', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-12', 12, N'12', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-13', 13, N'13', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-14', 14, N'14', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-15', 15, N'15', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-16', 16, N'16', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-17', 17, N'17', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-18', 18, N'18', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-19', 19, N'19', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-20', 20, N'20', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-21', 21, N'21', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-22', 22, N'22', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-23', 23, N'23', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-24', 24, N'24', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-25', 25, N'25', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-26', 26, N'26', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-27', 27, N'27', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-28', 28, N'28', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-29', 29, N'29', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-30', 30, N'30', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-07-31', 31, N'31', N'July', N'Jul', 7, N'CY2015-Jul', 2015, N'CY2015', 9, N'FY2015-Jul', 2015, N'FY2015', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-01', 1, N'1', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-02', 2, N'2', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-03', 3, N'3', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-04', 4, N'4', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-05', 5, N'5', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-06', 6, N'6', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-07', 7, N'7', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-08', 8, N'8', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-09', 9, N'9', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-10', 10, N'10', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-11', 11, N'11', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-12', 12, N'12', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-13', 13, N'13', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-14', 14, N'14', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-15', 15, N'15', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-16', 16, N'16', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-17', 17, N'17', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-18', 18, N'18', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-19', 19, N'19', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-20', 20, N'20', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-21', 21, N'21', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-22', 22, N'22', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-23', 23, N'23', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-24', 24, N'24', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-25', 25, N'25', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-26', 26, N'26', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-27', 27, N'27', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-28', 28, N'28', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-29', 29, N'29', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-30', 30, N'30', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-08-31', 31, N'31', N'August', N'Aug', 8, N'CY2015-Aug', 2015, N'CY2015', 10, N'FY2015-Aug', 2015, N'FY2015', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-01', 1, N'1', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-02', 2, N'2', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-03', 3, N'3', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-04', 4, N'4', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-05', 5, N'5', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-06', 6, N'6', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-07', 7, N'7', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-08', 8, N'8', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-09', 9, N'9', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-10', 10, N'10', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-11', 11, N'11', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-12', 12, N'12', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-13', 13, N'13', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-14', 14, N'14', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-15', 15, N'15', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-16', 16, N'16', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-17', 17, N'17', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-18', 18, N'18', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-19', 19, N'19', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-20', 20, N'20', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-21', 21, N'21', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-22', 22, N'22', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-23', 23, N'23', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-24', 24, N'24', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-25', 25, N'25', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-26', 26, N'26', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-27', 27, N'27', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-28', 28, N'28', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-29', 29, N'29', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-09-30', 30, N'30', N'September', N'Sep', 9, N'CY2015-Sep', 2015, N'CY2015', 11, N'FY2015-Sep', 2015, N'FY2015', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-01', 1, N'1', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-02', 2, N'2', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-03', 3, N'3', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-04', 4, N'4', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-05', 5, N'5', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-06', 6, N'6', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-07', 7, N'7', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-08', 8, N'8', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-09', 9, N'9', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-10', 10, N'10', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-11', 11, N'11', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-12', 12, N'12', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-13', 13, N'13', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-14', 14, N'14', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-15', 15, N'15', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-16', 16, N'16', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-17', 17, N'17', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-18', 18, N'18', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-19', 19, N'19', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-20', 20, N'20', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-21', 21, N'21', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-22', 22, N'22', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-23', 23, N'23', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-24', 24, N'24', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-25', 25, N'25', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-26', 26, N'26', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-27', 27, N'27', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-28', 28, N'28', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-29', 29, N'29', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-30', 30, N'30', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-10-31', 31, N'31', N'October', N'Oct', 10, N'CY2015-Oct', 2015, N'CY2015', 12, N'FY2015-Oct', 2015, N'FY2015', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-01', 1, N'1', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-02', 2, N'2', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-03', 3, N'3', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-04', 4, N'4', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-05', 5, N'5', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-06', 6, N'6', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-07', 7, N'7', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-08', 8, N'8', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-09', 9, N'9', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-10', 10, N'10', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-11', 11, N'11', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-12', 12, N'12', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-13', 13, N'13', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-14', 14, N'14', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-15', 15, N'15', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-16', 16, N'16', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-17', 17, N'17', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-18', 18, N'18', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-19', 19, N'19', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-20', 20, N'20', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-21', 21, N'21', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-22', 22, N'22', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-23', 23, N'23', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-24', 24, N'24', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-25', 25, N'25', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-26', 26, N'26', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-27', 27, N'27', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-28', 28, N'28', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-29', 29, N'29', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-11-30', 30, N'30', N'November', N'Nov', 11, N'CY2015-Nov', 2015, N'CY2015', 1, N'FY2016-Nov', 2016, N'FY2016', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-01', 1, N'1', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-02', 2, N'2', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-03', 3, N'3', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-04', 4, N'4', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-05', 5, N'5', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-06', 6, N'6', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-07', 7, N'7', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-08', 8, N'8', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-09', 9, N'9', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-10', 10, N'10', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-11', 11, N'11', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-12', 12, N'12', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-13', 13, N'13', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-14', 14, N'14', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-15', 15, N'15', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-16', 16, N'16', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-17', 17, N'17', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-18', 18, N'18', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-19', 19, N'19', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-20', 20, N'20', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-21', 21, N'21', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-22', 22, N'22', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-23', 23, N'23', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-24', 24, N'24', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-25', 25, N'25', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-26', 26, N'26', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-27', 27, N'27', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-28', 28, N'28', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 53)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-29', 29, N'29', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 53)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-30', 30, N'30', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 53)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2015-12-31', 31, N'31', N'December', N'Dec', 12, N'CY2015-Dec', 2015, N'CY2015', 2, N'FY2016-Dec', 2016, N'FY2016', 53)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-01', 1, N'1', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 53)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-02', 2, N'2', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 53)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-03', 3, N'3', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 53)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-04', 4, N'4', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-05', 5, N'5', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-06', 6, N'6', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-07', 7, N'7', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-08', 8, N'8', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-09', 9, N'9', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-10', 10, N'10', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 1)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-11', 11, N'11', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-12', 12, N'12', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-13', 13, N'13', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-14', 14, N'14', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-15', 15, N'15', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-16', 16, N'16', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-17', 17, N'17', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 2)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-18', 18, N'18', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-19', 19, N'19', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-20', 20, N'20', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-21', 21, N'21', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-22', 22, N'22', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-23', 23, N'23', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-24', 24, N'24', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 3)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-25', 25, N'25', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-26', 26, N'26', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-27', 27, N'27', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-28', 28, N'28', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-29', 29, N'29', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-30', 30, N'30', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-01-31', 31, N'31', N'January', N'Jan', 1, N'CY2016-Jan', 2016, N'CY2016', 3, N'FY2016-Jan', 2016, N'FY2016', 4)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-01', 1, N'1', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-02', 2, N'2', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-03', 3, N'3', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-04', 4, N'4', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-05', 5, N'5', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-06', 6, N'6', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-07', 7, N'7', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 5)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-08', 8, N'8', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-09', 9, N'9', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-10', 10, N'10', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-11', 11, N'11', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-12', 12, N'12', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-13', 13, N'13', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-14', 14, N'14', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 6)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-15', 15, N'15', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-16', 16, N'16', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-17', 17, N'17', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-18', 18, N'18', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-19', 19, N'19', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-20', 20, N'20', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-21', 21, N'21', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 7)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-22', 22, N'22', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-23', 23, N'23', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-24', 24, N'24', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-25', 25, N'25', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-26', 26, N'26', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-27', 27, N'27', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-28', 28, N'28', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 8)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-02-29', 29, N'29', N'February', N'Feb', 2, N'CY2016-Feb', 2016, N'CY2016', 4, N'FY2016-Feb', 2016, N'FY2016', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-01', 1, N'1', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-02', 2, N'2', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-03', 3, N'3', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-04', 4, N'4', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-05', 5, N'5', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-06', 6, N'6', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 9)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-07', 7, N'7', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-08', 8, N'8', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-09', 9, N'9', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-10', 10, N'10', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-11', 11, N'11', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-12', 12, N'12', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-13', 13, N'13', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 10)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-14', 14, N'14', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-15', 15, N'15', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-16', 16, N'16', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-17', 17, N'17', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-18', 18, N'18', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-19', 19, N'19', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-20', 20, N'20', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 11)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-21', 21, N'21', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-22', 22, N'22', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-23', 23, N'23', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-24', 24, N'24', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-25', 25, N'25', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-26', 26, N'26', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-27', 27, N'27', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 12)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-28', 28, N'28', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-29', 29, N'29', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-30', 30, N'30', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-03-31', 31, N'31', N'March', N'Mar', 3, N'CY2016-Mar', 2016, N'CY2016', 5, N'FY2016-Mar', 2016, N'FY2016', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-01', 1, N'1', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-02', 2, N'2', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-03', 3, N'3', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 13)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-04', 4, N'4', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-05', 5, N'5', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-06', 6, N'6', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-07', 7, N'7', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-08', 8, N'8', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-09', 9, N'9', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-10', 10, N'10', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 14)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-11', 11, N'11', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-12', 12, N'12', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-13', 13, N'13', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-14', 14, N'14', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-15', 15, N'15', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-16', 16, N'16', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-17', 17, N'17', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 15)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-18', 18, N'18', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-19', 19, N'19', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-20', 20, N'20', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-21', 21, N'21', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-22', 22, N'22', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-23', 23, N'23', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-24', 24, N'24', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 16)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-25', 25, N'25', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-26', 26, N'26', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-27', 27, N'27', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-28', 28, N'28', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-29', 29, N'29', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-04-30', 30, N'30', N'April', N'Apr', 4, N'CY2016-Apr', 2016, N'CY2016', 6, N'FY2016-Apr', 2016, N'FY2016', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-01', 1, N'1', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 17)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-02', 2, N'2', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-03', 3, N'3', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-04', 4, N'4', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-05', 5, N'5', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-06', 6, N'6', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-07', 7, N'7', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-08', 8, N'8', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 18)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-09', 9, N'9', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-10', 10, N'10', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-11', 11, N'11', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-12', 12, N'12', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-13', 13, N'13', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-14', 14, N'14', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-15', 15, N'15', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 19)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-16', 16, N'16', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-17', 17, N'17', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-18', 18, N'18', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-19', 19, N'19', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-20', 20, N'20', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-21', 21, N'21', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-22', 22, N'22', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 20)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-23', 23, N'23', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-24', 24, N'24', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-25', 25, N'25', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-26', 26, N'26', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-27', 27, N'27', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-28', 28, N'28', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-29', 29, N'29', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 21)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-30', 30, N'30', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-05-31', 31, N'31', N'May', N'May', 5, N'CY2016-May', 2016, N'CY2016', 7, N'FY2016-May', 2016, N'FY2016', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-01', 1, N'1', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-02', 2, N'2', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-03', 3, N'3', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-04', 4, N'4', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-05', 5, N'5', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 22)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-06', 6, N'6', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-07', 7, N'7', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-08', 8, N'8', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-09', 9, N'9', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-10', 10, N'10', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-11', 11, N'11', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-12', 12, N'12', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 23)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-13', 13, N'13', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-14', 14, N'14', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-15', 15, N'15', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-16', 16, N'16', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-17', 17, N'17', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-18', 18, N'18', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-19', 19, N'19', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 24)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-20', 20, N'20', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-21', 21, N'21', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-22', 22, N'22', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-23', 23, N'23', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-24', 24, N'24', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-25', 25, N'25', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-26', 26, N'26', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 25)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-27', 27, N'27', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-28', 28, N'28', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-29', 29, N'29', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-06-30', 30, N'30', N'June', N'Jun', 6, N'CY2016-Jun', 2016, N'CY2016', 8, N'FY2016-Jun', 2016, N'FY2016', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-01', 1, N'1', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-02', 2, N'2', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-03', 3, N'3', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 26)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-04', 4, N'4', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-05', 5, N'5', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-06', 6, N'6', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-07', 7, N'7', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-08', 8, N'8', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-09', 9, N'9', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-10', 10, N'10', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 27)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-11', 11, N'11', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-12', 12, N'12', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-13', 13, N'13', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-14', 14, N'14', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-15', 15, N'15', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-16', 16, N'16', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-17', 17, N'17', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 28)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-18', 18, N'18', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-19', 19, N'19', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-20', 20, N'20', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-21', 21, N'21', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-22', 22, N'22', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-23', 23, N'23', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-24', 24, N'24', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 29)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-25', 25, N'25', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-26', 26, N'26', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-27', 27, N'27', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-28', 28, N'28', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-29', 29, N'29', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-30', 30, N'30', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-07-31', 31, N'31', N'July', N'Jul', 7, N'CY2016-Jul', 2016, N'CY2016', 9, N'FY2016-Jul', 2016, N'FY2016', 30)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-01', 1, N'1', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-02', 2, N'2', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-03', 3, N'3', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-04', 4, N'4', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-05', 5, N'5', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-06', 6, N'6', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-07', 7, N'7', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 31)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-08', 8, N'8', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-09', 9, N'9', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-10', 10, N'10', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-11', 11, N'11', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-12', 12, N'12', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-13', 13, N'13', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-14', 14, N'14', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 32)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-15', 15, N'15', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-16', 16, N'16', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-17', 17, N'17', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-18', 18, N'18', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-19', 19, N'19', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-20', 20, N'20', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-21', 21, N'21', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 33)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-22', 22, N'22', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-23', 23, N'23', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-24', 24, N'24', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-25', 25, N'25', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-26', 26, N'26', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-27', 27, N'27', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-28', 28, N'28', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 34)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-29', 29, N'29', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-30', 30, N'30', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-08-31', 31, N'31', N'August', N'Aug', 8, N'CY2016-Aug', 2016, N'CY2016', 10, N'FY2016-Aug', 2016, N'FY2016', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-01', 1, N'1', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-02', 2, N'2', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-03', 3, N'3', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-04', 4, N'4', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 35)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-05', 5, N'5', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-06', 6, N'6', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-07', 7, N'7', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-08', 8, N'8', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-09', 9, N'9', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-10', 10, N'10', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-11', 11, N'11', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 36)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-12', 12, N'12', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-13', 13, N'13', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-14', 14, N'14', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-15', 15, N'15', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-16', 16, N'16', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-17', 17, N'17', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-18', 18, N'18', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 37)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-19', 19, N'19', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-20', 20, N'20', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-21', 21, N'21', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-22', 22, N'22', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-23', 23, N'23', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-24', 24, N'24', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-25', 25, N'25', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 38)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-26', 26, N'26', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-27', 27, N'27', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-28', 28, N'28', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-29', 29, N'29', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-09-30', 30, N'30', N'September', N'Sep', 9, N'CY2016-Sep', 2016, N'CY2016', 11, N'FY2016-Sep', 2016, N'FY2016', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-01', 1, N'1', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-02', 2, N'2', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 39)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-03', 3, N'3', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-04', 4, N'4', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-05', 5, N'5', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-06', 6, N'6', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-07', 7, N'7', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-08', 8, N'8', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-09', 9, N'9', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 40)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-10', 10, N'10', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-11', 11, N'11', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-12', 12, N'12', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-13', 13, N'13', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-14', 14, N'14', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-15', 15, N'15', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-16', 16, N'16', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 41)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-17', 17, N'17', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-18', 18, N'18', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-19', 19, N'19', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-20', 20, N'20', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-21', 21, N'21', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-22', 22, N'22', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-23', 23, N'23', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 42)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-24', 24, N'24', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-25', 25, N'25', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-26', 26, N'26', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-27', 27, N'27', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-28', 28, N'28', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-29', 29, N'29', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-30', 30, N'30', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 43)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-10-31', 31, N'31', N'October', N'Oct', 10, N'CY2016-Oct', 2016, N'CY2016', 12, N'FY2016-Oct', 2016, N'FY2016', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-01', 1, N'1', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-02', 2, N'2', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-03', 3, N'3', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-04', 4, N'4', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-05', 5, N'5', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-06', 6, N'6', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 44)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-07', 7, N'7', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-08', 8, N'8', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-09', 9, N'9', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-10', 10, N'10', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-11', 11, N'11', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-12', 12, N'12', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-13', 13, N'13', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 45)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-14', 14, N'14', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-15', 15, N'15', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-16', 16, N'16', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-17', 17, N'17', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-18', 18, N'18', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-19', 19, N'19', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-20', 20, N'20', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 46)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-21', 21, N'21', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-22', 22, N'22', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-23', 23, N'23', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-24', 24, N'24', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-25', 25, N'25', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-26', 26, N'26', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-27', 27, N'27', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 47)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-28', 28, N'28', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-29', 29, N'29', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-11-30', 30, N'30', N'November', N'Nov', 11, N'CY2016-Nov', 2016, N'CY2016', 1, N'FY2017-Nov', 2017, N'FY2017', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-01', 1, N'1', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-02', 2, N'2', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-03', 3, N'3', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-04', 4, N'4', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 48)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-05', 5, N'5', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-06', 6, N'6', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-07', 7, N'7', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-08', 8, N'8', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-09', 9, N'9', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-10', 10, N'10', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-11', 11, N'11', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 49)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-12', 12, N'12', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-13', 13, N'13', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-14', 14, N'14', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-15', 15, N'15', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-16', 16, N'16', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-17', 17, N'17', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-18', 18, N'18', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 50)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-19', 19, N'19', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-20', 20, N'20', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-21', 21, N'21', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-22', 22, N'22', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-23', 23, N'23', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-24', 24, N'24', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-25', 25, N'25', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 51)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-26', 26, N'26', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-27', 27, N'27', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-28', 28, N'28', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-29', 29, N'29', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-30', 30, N'30', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 52)
INSERT [Dimension].[Date] ([Date], [Day Number], [Day], [Month], [Short Month], [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label], [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label], [ISO Week Number]) VALUES ('2016-12-31', 31, N'31', N'December', N'Dec', 12, N'CY2016-Dec', 2016, N'CY2016', 2, N'FY2017-Dec', 2017, N'FY2017', 52)
GO

--Execute the Reseed to prepare for ETL loading
EXEC [Integration].[Configuration_ReseedETL]
GO