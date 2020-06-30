/****** Object:  Schema [Fact]    Script Date: 4/9/2020 9:00:54 AM ******/
CREATE SCHEMA [Fact]
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
	DISTRIBUTION = HASH ( [WWI Invoice ID] ),
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


