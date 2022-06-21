/****************************************************************************************
--How can you import Parquet/Csv files from blob storage ?
--Could you import all the data into your Datawarehouse ?

--Tips:
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/develop-tables-overview
https://docs.microsoft.com/it-it/azure/synapse-analytics/sql/load-data-overview#4-load-the-data-into-dedicated-sql-pool-staging-tables-using-polybase
https://docs.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=azure-sqldw-latest&preserve-view=true
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/data-loading-best-practices#load-to-a-staging-table
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-distribute
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-azure-sql-data-warehouse?view=aps-pdw-2016-au7
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/cheat-sheet
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-bulk-load-copy-tsql-examples
https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-bulk-load-copy-tsql-examples#c-managed-identity

****************************************************************************************/


/****************************************************************************************
STEP 1 - Choose the proper distribution method and Storage type for staging area 
considering you have to  ingest data at maximum speed and no overhead
****************************************************************************************/

CREATE SCHEMA Staging
GO

CREATE TABLE [Staging].[DimAccount]
(	
	[AccountKey] [int] NOT NULL,
	[ParentAccountKey] [int] NULL,
	[AccountCodeAlternateKey] [int] NULL,
	[ParentAccountCodeAlternateKey] [int] NULL,
	[AccountDescription] [nvarchar](50) NULL,
	[AccountType] [nvarchar](50) NULL,
	[Operator] [nvarchar](50) NULL,
	[CustomMembers] [nvarchar](300) NULL,
	[ValueType] [nvarchar](50) NULL,
	[CustomMemberOptions] [nvarchar](200) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimCurrency]
(
	[CurrencyKey] [int] NOT NULL,
	[CurrencyAlternateKey] [nchar](3) NOT NULL,
	[CurrencyName] [nvarchar](50) NOT NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimCustomer]
(
	[CustomerKey] [int] NOT NULL,
	[GeographyKey] [int] NULL,
	[CustomerAlternateKey] [nvarchar](15) NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[NameStyle] [bit] NULL,
	[BirthDate] [date] NULL,
	[MaritalStatus] [nchar](1) NULL,
	[Suffix] [nvarchar](10) NULL,
	[Gender] [nvarchar](1) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[YearlyIncome] [money] NULL,
	[TotalChildren] [tinyint] NULL,
	[NumberChildrenAtHome] [tinyint] NULL,
	[EnglishEducation] [nvarchar](40) NULL,
	[SpanishEducation] [nvarchar](40) NULL,
	[FrenchEducation] [nvarchar](40) NULL,
	[EnglishOccupation] [nvarchar](100) NULL,
	[SpanishOccupation] [nvarchar](100) NULL,
	[FrenchOccupation] [nvarchar](100) NULL,
	[HouseOwnerFlag] [nchar](1) NULL,
	[NumberCarsOwned] [tinyint] NULL,
	[AddressLine1] [nvarchar](120) NULL,
	[AddressLine2] [nvarchar](120) NULL,
	[Phone] [nvarchar](20) NULL,
	[DateFirstPurchase] [date] NULL,
	[CommuteDistance] [nvarchar](15) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimDate]
(
	[DateKey] [int] NOT NULL,
	[FullDateAlternateKey] [date] NOT NULL,
	[DayNumberOfWeek] [tinyint] NOT NULL,
	[EnglishDayNameOfWeek] [nvarchar](10) NOT NULL,
	[SpanishDayNameOfWeek] [nvarchar](10) NOT NULL,
	[FrenchDayNameOfWeek] [nvarchar](10) NOT NULL,
	[DayNumberOfMonth] [tinyint] NOT NULL,
	[DayNumberOfYear] [smallint] NOT NULL,
	[WeekNumberOfYear] [tinyint] NOT NULL,
	[EnglishMonthName] [nvarchar](10) NOT NULL,
	[SpanishMonthName] [nvarchar](10) NOT NULL,
	[FrenchMonthName] [nvarchar](10) NOT NULL,
	[MonthNumberOfYear] [tinyint] NOT NULL,
	[CalendarQuarter] [tinyint] NOT NULL,
	[CalendarYear] [smallint] NOT NULL,
	[CalendarSemester] [tinyint] NOT NULL,
	[FiscalQuarter] [tinyint] NOT NULL,
	[FiscalYear] [smallint] NOT NULL,
	[FiscalSemester] [tinyint] NOT NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimDepartmentGroup]
(
	[DepartmentGroupKey] [int] NOT NULL,
	[ParentDepartmentGroupKey] [int] NULL,
	[DepartmentGroupName] [nvarchar](50) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimEmployee]
(
	[EmployeeKey] [int] NOT NULL,
	[ParentEmployeeKey] [int] NULL,
	[EmployeeNationalIDAlternateKey] [nvarchar](15) NULL,
	[ParentEmployeeNationalIDAlternateKey] [nvarchar](15) NULL,
	[SalesTerritoryKey] [int] NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[NameStyle] [bit] NOT NULL,
	[Title] [nvarchar](50) NULL,
	[HireDate] [date] NULL,
	[BirthDate] [date] NULL,
	[LoginID] [nvarchar](256) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[Phone] [nvarchar](25) NULL,
	[MaritalStatus] [nchar](1) NULL,
	[EmergencyContactName] [nvarchar](50) NULL,
	[EmergencyContactPhone] [nvarchar](25) NULL,
	[SalariedFlag] [bit] NULL,
	[Gender] [nchar](1) NULL,
	[PayFrequency] [tinyint] NULL,
	[BaseRate] [money] NULL,
	[VacationHours] [smallint] NULL,
	[SickLeaveHours] [smallint] NULL,
	[CurrentFlag] [bit] NOT NULL,
	[SalesPersonFlag] [bit] NOT NULL,
	[DepartmentName] [nvarchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[Status] [nvarchar](50) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimGeography]
(
	[GeographyKey] [int] NOT NULL,
	[City] [nvarchar](30) NULL,
	[StateProvinceCode] [nvarchar](3) NULL,
	[StateProvinceName] [nvarchar](50) NULL,
	[CountryRegionCode] [nvarchar](3) NULL,
	[EnglishCountryRegionName] [nvarchar](50) NULL,
	[SpanishCountryRegionName] [nvarchar](50) NULL,
	[FrenchCountryRegionName] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[SalesTerritoryKey] [int] NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimOrganization]
(
	[OrganizationKey] [int] NOT NULL,
	[ParentOrganizationKey] [int] NULL,
	[PercentageOfOwnership] [nvarchar](16) NULL,
	[OrganizationName] [nvarchar](50) NULL,
	[CurrencyKey] [int] NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimProduct]
(
	[ProductKey] [int] NOT NULL,
	[ProductAlternateKey] [nvarchar](25) NULL,
	[ProductSubcategoryKey] [int] NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[EnglishProductName] [nvarchar](200) NOT NULL,
	[SpanishProductName] [nvarchar](200) NULL,
	[FrenchProductName] [nvarchar](200) NULL,
	[StandardCost] [money] NULL,
	[FinishedGoodsFlag] [bit] NOT NULL,
	[Color] [nvarchar](15) NOT NULL,
	[SafetyStockLevel] [smallint] NULL,
	[ReorderPoint] [smallint] NULL,
	[ListPrice] [money] NULL,
	[Size] [nvarchar](50) NULL,
	[SizeRange] [nvarchar](50) NULL,
	[Weight] [float] NULL,
	[DaysToManufacture] [int] NULL,
	[ProductLine] [nchar](2) NULL,
	[DealerPrice] [money] NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ModelName] [nvarchar](50) NULL,
	[EnglishDescription] [nvarchar](400) NULL,
	[FrenchDescription] [nvarchar](400) NULL,
	[ChineseDescription] [nvarchar](400) NULL,
	[ArabicDescription] [nvarchar](400) NULL,
	[HebrewDescription] [nvarchar](400) NULL,
	[ThaiDescription] [nvarchar](400) NULL,
	[GermanDescription] [nvarchar](400) NULL,
	[JapaneseDescription] [nvarchar](400) NULL,
	[TurkishDescription] [nvarchar](400) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [nvarchar](7) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimProductCategory]
(
	[ProductCategoryKey] [int] NOT NULL,
	[ProductCategoryAlternateKey] [int] NULL,
	[EnglishProductCategoryName] [nvarchar](50) NOT NULL,
	[SpanishProductCategoryName] [nvarchar](50) NOT NULL,
	[FrenchProductCategoryName] [nvarchar](50) NOT NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimProductSubcategory]
(
	[ProductSubcategoryKey] [int] NOT NULL,
	[ProductSubcategoryAlternateKey] [int] NULL,
	[EnglishProductSubcategoryName] [nvarchar](50) NOT NULL,
	[SpanishProductSubcategoryName] [nvarchar](50) NOT NULL,
	[FrenchProductSubcategoryName] [nvarchar](50) NOT NULL,
	[ProductCategoryKey] [int] NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimPromotion]
(
	[PromotionKey] [int] NOT NULL,
	[PromotionAlternateKey] [int] NULL,
	[EnglishPromotionName] [nvarchar](255) NULL,
	[SpanishPromotionName] [nvarchar](255) NULL,
	[FrenchPromotionName] [nvarchar](255) NULL,
	[DiscountPct] [float] NULL,
	[EnglishPromotionType] [nvarchar](50) NULL,
	[SpanishPromotionType] [nvarchar](50) NULL,
	[FrenchPromotionType] [nvarchar](50) NULL,
	[EnglishPromotionCategory] [nvarchar](50) NULL,
	[SpanishPromotionCategory] [nvarchar](50) NULL,
	[FrenchPromotionCategory] [nvarchar](50) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[MinQty] [int] NULL,
	[MaxQty] [int] NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO



CREATE TABLE [Staging].[DimReseller]
(
	[ResellerKey] [int] NOT NULL,
	[GeographyKey] [int] NULL,
	[ResellerAlternateKey] [nvarchar](15) NULL,
	[Phone] [nvarchar](25) NULL,
	[BusinessType] [varchar](20) NOT NULL,
	[ResellerName] [nvarchar](50) NOT NULL,
	[NumberEmployees] [int] NULL,
	[OrderFrequency] [char](1) NULL,
	[OrderMonth] [smallint] NULL,
	[FirstOrderYear] [int] NULL,
	[LastOrderYear] [int] NULL,
	[ProductLine] [nvarchar](50) NULL,
	[AddressLine1] [nvarchar](60) NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[AnnualSales] [money] NULL,
	[BankName] [nvarchar](50) NULL,
	[MinPaymentType] [tinyint] NULL,
	[MinPaymentAmount] [money] NULL,
	[AnnualRevenue] [money] NULL,
	[YearOpened] [int] NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimSalesReason]
(
	[SalesReasonKey] [int] NOT NULL,
	[SalesReasonAlternateKey] [int] NOT NULL,
	[SalesReasonName] [nvarchar](50) NOT NULL,
	[SalesReasonReasonType] [nvarchar](50) NOT NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO



CREATE TABLE [Staging].[DimSalesTerritory]
(
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesTerritoryAlternateKey] [int] NULL,
	[SalesTerritoryRegion] [nvarchar](50) NOT NULL,
	[SalesTerritoryCountry] [nvarchar](50) NOT NULL,
	[SalesTerritoryGroup] [nvarchar](50) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[DimScenario]
(
	[ScenarioKey] [int] NOT NULL,
	[ScenarioName] [nvarchar](50) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO

CREATE TABLE [Staging].[FactCurrencyRate]
(
	[CurrencyKey] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[AverageRate] [float] NOT NULL,
	[EndOfDayRate] [float] NOT NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO



CREATE TABLE [Staging].[FactFinance]
(
	[FinanceKey] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[OrganizationKey] [int] NOT NULL,
	[DepartmentGroupKey] [int] NOT NULL,
	[ScenarioKey] [int] NOT NULL,
	[AccountKey] [int] NOT NULL,
	[Amount] [float] NOT NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[FactInternetSales]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [smallint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float] NOT NULL,
	[DiscountAmount] [float] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[FactInternetSalesReason]
(
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [smallint] NOT NULL,
	[SalesReasonKey] [int] NOT NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO


CREATE TABLE [Staging].[FactResellerSales]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[ResellerKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[SalesOrderLineNumber] [smallint] NOT NULL,
	[RevisionNumber] [tinyint] NULL,
	[OrderQuantity] [smallint] NULL,
	[UnitPrice] [money] NULL,
	[ExtendedAmount] [money] NULL,
	[UnitPriceDiscountPct] [float] NULL,
	[DiscountAmount] [float] NULL,
	[ProductStandardCost] [money] NULL,
	[TotalProductCost] [money] NULL,
	[SalesAmount] [money] NULL,
	[TaxAmt] [money] NULL,
	[Freight] [money] NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[CustomerPONumber] [nvarchar](25) NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO

CREATE TABLE [Staging].[FactSales]
(
	[OrderDateKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[RevisionNumber] [int] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[SalesAmount] [money] NOT NULL
)
WITH
(
	DISTRIBUTION = 'Choose the proper distribution method for staging table'
	, HEAP or CLUSTERED COLUMNSTORE
)
GO



/****************************************************************************************
STEP 2 - Explore COPY INTO T-SQL command to import from ADLS Gen2 - Blob container
to Dedicated Sql Pool. 
****************************************************************************************/
COPY INTO [schema.]table_name
[(Column_list)] 
FROM '<external_location>' [,...n]
WITH  
 ( 
 [FILE_TYPE = {'CSV' | 'PARQUET' | 'ORC'} ]
 [,FILE_FORMAT = EXTERNAL FILE FORMAT OBJECT ]    
 [,CREDENTIAL = (AZURE CREDENTIAL) ]
 [,ERRORFILE = '[http(s)://storageaccount/container]/errorfile_directory[/]]' 
 [,ERRORFILE_CREDENTIAL = (AZURE CREDENTIAL) ]
 [,MAXERRORS = max_errors ] 
 [,COMPRESSION = { 'Gzip' | 'DefaultCodec'| 'Snappy'}] 
 [,FIELDQUOTE = 'string_delimiter'] 
 [,FIELDTERMINATOR =  'field_terminator']  
 [,ROWTERMINATOR = 'row_terminator']
 [,FIRSTROW = first_row]
 [,DATEFORMAT = 'date_format'] 
 [,ENCODING = {'UTF8'|'UTF16'}] 
 [,IDENTITY_INSERT = {'ON' | 'OFF'}]
 [,AUTO_CREATE_TABLE = {'ON' | 'OFF'} ]
)
