/****** Object:  Schema [Integration]    Script Date: 4/9/2020 9:00:54 AM ******/
CREATE SCHEMA [Integration]
GO

/****** Object:  Schema [sysdiag]    Script Date: 4/9/2020 9:00:54 AM ******/
CREATE SCHEMA [sysdiag]
GO

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

/****** Object:  View [Integration].[v_City_Stage]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Integration].[v_City_Stage]
AS SELECT c.[WWI City ID], MIN(c.[Valid From]) AS [Valid From]
        FROM Integration.City_Staging AS c
        GROUP BY c.[WWI City ID];
GO

/****** Object:  View [Integration].[v_Customer_Stage]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Integration].[v_Customer_Stage]
AS SELECT c.[WWI Customer ID], MIN(c.[Valid From]) AS [Valid From]
        FROM Integration.Customer_Staging AS c
        GROUP BY c.[WWI Customer ID];
GO

/****** Object:  View [Integration].[v_Employee_Stage]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Integration].[v_Employee_Stage]
AS SELECT e.[WWI Employee ID], MIN(e.[Valid From]) AS [Valid From]
        FROM Integration.Employee_Staging AS e
        GROUP BY e.[WWI Employee ID];
GO


/****** Object:  View [Integration].[v_PaymentMethod_Stage]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Integration].[v_PaymentMethod_Stage]
AS SELECT pm.[WWI Payment Method ID], MIN(pm.[Valid From]) AS [Valid From]
        FROM Integration.PaymentMethod_Staging AS pm
        GROUP BY pm.[WWI Payment Method ID];
GO

/****** Object:  View [Integration].[v_StockItem_Stage]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Integration].[v_StockItem_Stage]
AS SELECT s.[WWI Stock Item ID], MIN(s.[Valid From]) AS [Valid From]
        FROM Integration.StockItem_Staging AS s
        GROUP BY s.[WWI Stock Item ID];
GO

/****** Object:  View [Integration].[v_Supplier_Stage]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Integration].[v_Supplier_Stage]
AS SELECT s.[WWI Supplier ID], MIN(s.[Valid From]) AS [Valid From]
        FROM Integration.Supplier_Staging AS s
        GROUP BY s.[WWI Supplier ID];
GO

/****** Object:  View [Integration].[v_TransactionType_Stage]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Integration].[v_TransactionType_Stage]
AS SELECT pm.[WWI Transaction Type ID], MIN(pm.[Valid From]) AS [Valid From]
        FROM Integration.TransactionType_Staging AS pm
        GROUP BY pm.[WWI Transaction Type ID];
GO

/****** Object:  Table [Integration].[Load_Control]    Script Date: 4/8/2020 7:12:55 PM ******/
DROP TABLE [Integration].[Load_Control]
GO

/****** Object:  Table [Integration].[Load_Control]    Script Date: 4/8/2020 7:12:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Integration].[Load_Control](
	[Load_Date] [datetime2](7) NOT NULL
)
GO

INSERT INTO [Integration].[Load_Control]
           ([Load_Date])
     VALUES
           ('2020-01-01 01:00:00.0000000')
GO


