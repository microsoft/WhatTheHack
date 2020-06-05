/******* EXECUTE IN WIDE WORLD IMPORTERS OLTP DATABASE ***********/

--Update 10 existing records
UPDATE T
SET [LatestRecordedPopulation] = LatestRecordedPopulation + 1000
FROM (SELECT TOP 10 * from [Application].[Cities]) T

--Insert New Test record
INSERT INTO [Application].[Cities]
	(
        [CityName]
        ,[StateProvinceID]
        ,[Location]
        ,[LatestRecordedPopulation]
        ,[LastEditedBy]
	)
    VALUES
    (
		'NewCity' + CONVERT(char(19), getdate(), 121)
        ,1
        ,NULL
        , 1000
        ,1
	)
;


/***** DON'T FORGET TO UPDATE LOAD_CONFIG TABLE **********/
