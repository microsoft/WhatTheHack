/****** Object:  Schema [Dimension]    Script Date: 4/9/2020 9:00:54 AM ******/
CREATE SCHEMA [Dimension]
GO


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
	DISTRIBUTION = REPLICATE,
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
