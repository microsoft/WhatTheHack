
IF OBJECT_ID('[dbo].[Airports]', 'U') IS NOT NULL
DROP TABLE [dbo].[Airports]
GO
CREATE TABLE [dbo].[Airports]
(
    [AirportCode] [CHAR](3) NOT NULL, -- Primary Key column
    [State] [CHAR](2) NOT NULL,
    [AirportName] [VARCHAR](255) NOT NULL,
    [CityName] [VARCHAR](50) NOT NULL,
    [TimeZone] [VARCHAR](50) NOT NULL,
    CONSTRAINT [PK_Airports] PRIMARY KEY CLUSTERED ([AirportCode] ASC)
);
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'CreateAirport'
)
    DROP PROCEDURE dbo.CreateAirport
GO


CREATE PROCEDURE dbo.CreateAirport
    @AirportCode [CHAR](3), 
    @State [CHAR](2),
    @AirportName [VARCHAR](255),
    @CityName [VARCHAR](50),
    @TimeZone [VARCHAR](50)
AS
    INSERT INTO Airports (AirportCode, AirportName, [State], CityName, TimeZone)
                VALUES (@AirportCode, @AirportName, @State, @CityName, @TimeZone)
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'GetAllAirports'
)
    DROP PROCEDURE dbo.GetAllAirports
GO
CREATE PROCEDURE dbo.GetAllAirports
AS
    SET NOCOUNT ON
    SELECT AirportCode, AirportName, [State], CityName, TimeZone FROM Airports
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'FindAirportByCode'
)
    DROP PROCEDURE dbo.FindAirportByCode
GO
CREATE PROCEDURE dbo.FindAirportByCode
    @AirportCode [CHAR](3)
AS
    SET NOCOUNT ON
    SELECT AirportCode, AirportName, [State], CityName, TimeZone FROM Airports
    WHERE AirportCode = @AirportCode
GO