--https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-generate-data?view=sql-server-2017
--Scripts to bring data to current date and increase DB Size

--Script to generate sample data to today's date
USE WideWorldImporters
Go;
EXECUTE DataLoadSimulation.PopulateDataToCurrentDate
        @AverageNumberOfCustomerOrdersPerDay = 60,
        @SaturdayPercentageOfNormalWorkDay = 50,
        @SundayPercentageOfNormalWorkDay = 0,
        @IsSilentMode = 1,
        @AreDatesPrinted = 1;

USE WideWorldImportersDW
GO;

--Script to update Data Warehouse tables with current data
EXECUTE Application.Configuration_ReseedETL;

USE WideWorldImportersDW
GO;
--Script to increase database sizes and populate data for 2012
EXECUTE [Application].Configuration_PopulateLargeSaleTable;