IF OBJECT_ID('[dbo].[Hotels]', 'U') IS NOT NULL
DROP TABLE [dbo].[Hotels]
GO

CREATE TABLE [dbo].[Hotels]
(
    [Id] int NOT NULL,
    [Location] [CHAR](3) NOT NULL,
    [StartingTime] [DATETIMEOFFSET] NOT NULL,
    [EndingTime] [DATETIMEOFFSET] NOT NULL,
    [Cost] [FLOAT] NOT NULL,
    [RoomType] [int] NOT NULL,
    CONSTRAINT [PK_Hotels] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hotels_Location] FOREIGN KEY (Location) REFERENCES [dbo].[Airports] (AirportCode)
);
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'CreateHotel'
)
    DROP PROCEDURE dbo.CreateHotel
GO

CREATE PROCEDURE dbo.CreateHotel
    @Id int,
    @Location [CHAR](3),
    @StartingTime [DATETIMEOFFSET],
    @EndingTime [DATETIMEOFFSET],
    @Cost [FLOAT],
    @RoomType [int]
AS
    INSERT INTO HOTELS (Id, [Location], StartingTime, EndingTime, Cost, RoomType)
                VALUES (@Id, @Location, @StartingTime, @EndingTime, @Cost, @RoomType)
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'FindHotelById'
)
    DROP PROCEDURE dbo.FindHotelById
GO
CREATE PROCEDURE dbo.FindHotelById
    @Id int
AS
    SET NOCOUNT ON
    SELECT Id, [Location], StartingTime, EndingTime, Cost, RoomType FROM HOTELS
    WHERE Id = @Id
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'FindHotels'
)
    DROP PROCEDURE dbo.FindHotels
GO
CREATE PROCEDURE dbo.FindHotels
    @Location [CHAR](3),
    @DesiredTime [DATETIMEOFFSET]
AS
    SET NOCOUNT ON
    SELECT Id, [Location], StartingTime, EndingTime, Cost, RoomType FROM HOTELS
    WHERE [Location] = @Location AND @DesiredTime between StartingTime AND EndingTime
GO