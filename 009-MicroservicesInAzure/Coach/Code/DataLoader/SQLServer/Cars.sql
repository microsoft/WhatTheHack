IF OBJECT_ID('[dbo].[Cars]', 'U') IS NOT NULL
DROP TABLE [dbo].[Cars]
GO
CREATE TABLE [dbo].[Cars]
(
    [Id] int NOT NULL,
    [Location] [CHAR](3) NOT NULL,
    [StartingTime] [DATETIMEOFFSET] NOT NULL,
    [EndingTime] [DATETIMEOFFSET] NOT NULL,
    [Cost] [FLOAT] NOT NULL,
    [CarType] [int] NOT NULL,
    CONSTRAINT [PK_Cars] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Cars_Location] FOREIGN KEY (Location) REFERENCES [dbo].[Airports] (AirportCode)
);
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'CreateCar'
)
    DROP PROCEDURE dbo.CreateCar
GO

CREATE PROCEDURE dbo.CreateCar
    @Id int,
    @Location [CHAR](3),
    @StartingTime [DATETIMEOFFSET],
    @EndingTime [DATETIMEOFFSET],
    @Cost [FLOAT],
    @CarType [int]
AS
    INSERT INTO CARS (Id, [Location], StartingTime, EndingTime, Cost, CarType)
                VALUES (@Id, @Location, @StartingTime, @EndingTime, @Cost, @CarType)
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'FindCarById'
)
    DROP PROCEDURE dbo.FindCarById
GO
CREATE PROCEDURE dbo.FindCarById
    @Id int
AS
    SET NOCOUNT ON
    SELECT Id, [Location], StartingTime, EndingTime, Cost, CarType FROM CARS
    WHERE Id = @Id
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'FindCars'
)
    DROP PROCEDURE dbo.FindCars
GO
CREATE PROCEDURE dbo.FindCars
    @Location [CHAR](3),
    @DesiredTime [DATETIMEOFFSET]
AS
    SET NOCOUNT ON
    SELECT Id, [Location], StartingTime, EndingTime, Cost, CarType FROM CARS
    WHERE [Location] = @Location AND @DesiredTime between StartingTime AND EndingTime
GO