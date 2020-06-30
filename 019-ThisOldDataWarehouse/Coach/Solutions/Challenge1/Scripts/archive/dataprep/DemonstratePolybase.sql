-- Demonstrate WorldWideImporters Polybase connections
-- Requires PolyBase to be installed.

USE WideWorldImportersDW;
GO

-- WideWorldImporters have customers in a variety of cities but feel they are likely missing 
-- other important cities. They have decided to try to find other cities have a growth rate of more 
-- than 20% over the last 3 years, and where they do not have existing customers.
-- They have obtained census data (a CSV file) and have loaded it into an Azure storage account.
-- They want to combine that data with other data in their main OLTP database to work out where
-- they should try to find new customers.

-- First, let's apply Polybase connectivity and set up an external table to point to the data
-- in the Azure storage account.

EXEC [Application].Configuration_ApplyPolybase;
GO

-- In Object Explorer, refresh the WideWorldImporters database, then expand the Tables node.
-- Note that SQL Server 2016 added a new entry here for External Tables. Expand that node.
-- Expand the dbo.CityPopulationStatistics table, expand the list of columns and note the
-- values that are contained. Let's look at the data:

SELECT * FROM dbo.CityPopulationStatistics;
GO

-- How did that work? First the procedure created an external data source like this:
/*

CREATE EXTERNAL DATA SOURCE AzureStorage 
WITH 
(
	TYPE=HADOOP, LOCATION = 'wasbs://data@sqldwdatasets.blob.core.windows.net'
);

*/
-- This shows how to connect to AzureStorage. Next the procedure created an 
-- external file format to describe the layout of the CSV file:
/*

CREATE EXTERNAL FILE FORMAT CommaDelimitedTextFileFormat 
WITH 
(
	FORMAT_TYPE = DELIMITEDTEXT, 
	FORMAT_OPTIONS 
	(
		FIELD_TERMINATOR = ','
	)
);

*/
-- Finally the external table was defined like this:
/*

CREATE EXTERNAL TABLE dbo.CityPopulationStatistics
(
	CityID int NOT NULL,
	StateProvinceCode nvarchar(5) NOT NULL,
	CityName nvarchar(50) NOT NULL,
	YearNumber int NOT NULL,
	LatestRecordedPopulation bigint NULL
)
WITH 
(	
	LOCATION = '/', 
	DATA_SOURCE = AzureStorage,
	FILE_FORMAT = CommaDelimitedTextFileFormat,
	REJECT_TYPE = VALUE,
	REJECT_VALUE = 4 -- skipping 1 header row per file
);

*/
-- From that point onwards, the external table can be used like a local table. Let's run that 
-- query that they wanted to use to find out which cities they should be finding new customers
-- in. We'll start building the query by grouping the cities from the external table
-- and finding those with more than a 20% growth rate for the period:

WITH PotentialCities
AS
(
	SELECT cps.CityName, 
	       cps.StateProvinceCode,
		   MAX(cps.LatestRecordedPopulation) AS PopulationIn2016,
		   (MAX(cps.LatestRecordedPopulation) - MIN(cps.LatestRecordedPopulation)) * 100.0 
		       / MIN(cps.LatestRecordedPopulation) AS GrowthRate
	FROM dbo.CityPopulationStatistics AS cps
	WHERE cps.LatestRecordedPopulation IS NOT NULL
	AND cps.LatestRecordedPopulation <> 0 
	GROUP BY cps.CityName, cps.StateProvinceCode
)
SELECT * 
FROM PotentialCities
WHERE GrowthRate > 2.0;
GO

-- Now let's combine that with our local city and sales data to exclude those where we already
-- have customers. We'll find the 100 most interesting cities based upon population.

WITH PotentialCities
AS
(
	SELECT cps.CityName, 
	       cps.StateProvinceCode,
		   MAX(cps.LatestRecordedPopulation) AS PopulationIn2016,
		   (MAX(cps.LatestRecordedPopulation) - MIN(cps.LatestRecordedPopulation)) * 100.0 
		       / MIN(cps.LatestRecordedPopulation) AS GrowthRate
	FROM dbo.CityPopulationStatistics AS cps
	WHERE cps.LatestRecordedPopulation IS NOT NULL
	AND cps.LatestRecordedPopulation <> 0 
	GROUP BY cps.CityName, cps.StateProvinceCode
),
InterestingCities
AS
(
	SELECT DISTINCT pc.CityName, 
					pc.StateProvinceCode, 
				    pc.PopulationIn2016,
					FLOOR(pc.GrowthRate) AS GrowthRate
	FROM PotentialCities AS pc
	INNER JOIN Dimension.City AS c
	ON pc.CityName = c.City 
	WHERE GrowthRate > 2.0
	AND NOT EXISTS (SELECT 1 FROM Fact.Sale AS s WHERE s.[City Key] = c.[City Key])
)
SELECT TOP(100) *
FROM InterestingCities 
ORDER BY PopulationIn2016 DESC;
GO

-- Clean up if required
/*
DROP EXTERNAL TABLE dbo.CityPopulationStatistics;
GO
DROP EXTERNAL FILE FORMAT CommaDelimitedTextFileFormat;
GO
DROP EXTERNAL DATA SOURCE AzureStorage;
GO
*/