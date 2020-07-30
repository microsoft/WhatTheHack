IF OBJECT_ID('[dbo].[Flights]', 'U') IS NOT NULL
DROP TABLE [dbo].[Flights]
GO
CREATE TABLE [dbo].[Flights]
(
    [Id] int NOT NULL,
    [DepartingFrom] [CHAR](3) NOT NULL,
    [ArrivingAt] [CHAR](3) NOT NULL,
    [DepartureTime] [DATETIMEOFFSET] NOT NULL,
    [ArrivalTime] [DATETIMEOFFSET] NOT NULL,
    [Duration] [TIME] NOT NULL,
    [Cost] [FLOAT] NOT NULL,
    CONSTRAINT [PK_Flights] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Flights_DepartingFrom] FOREIGN KEY (DepartingFrom) REFERENCES [dbo].[Airports] (AirportCode),
    CONSTRAINT [FK_Flights_ArrivingAt] FOREIGN KEY (ArrivingAt) REFERENCES [dbo].[Airports] (AirportCode)
);
GO


IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'CreateFlight'
)
    DROP PROCEDURE dbo.CreateFlight
GO

CREATE PROCEDURE dbo.CreateFlight
    @Id int,
    @DepartingFrom [CHAR](3),
    @ArrivingAt [CHAR](3),
    @DepartureTime [DATETIMEOFFSET],
    @ArrivalTime [DATETIMEOFFSET],
    @Duration [TIME],
    @Cost [FLOAT]
AS
    INSERT INTO FLIGHTS ([Id], [DepartingFrom], [ArrivingAt], [DepartureTime], [ArrivalTime], [Duration], [Cost])
                VALUES (@Id, @DepartingFrom, @ArrivingAt, @DepartureTime, @ArrivalTime, @Duration, @Cost)
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'FindFlightById'
)
    DROP PROCEDURE dbo.FindFlightById
GO
CREATE PROCEDURE dbo.FindFlightById
    @Id int
AS
    SET NOCOUNT ON
    SELECT [Id], [DepartingFrom], [ArrivingAt], [DepartureTime], [ArrivalTime], [Duration], [Cost] FROM FLIGHTS
    WHERE Id = @Id
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'FindFlights'
)
    DROP PROCEDURE dbo.FindFlights
GO
CREATE PROCEDURE dbo.FindFlights
    @DepartingFrom [CHAR](3),
    @ArrivingAt [CHAR](3),
    @DesiredTime [DATETIMEOFFSET],
    @SecondsOffset int
AS
    SET NOCOUNT ON
    SELECT [Id], [DepartingFrom], [ArrivingAt], [DepartureTime], [ArrivalTime], [Duration], [Cost] FROM FLIGHTS
    WHERE [DepartingFrom] = @DepartingFrom AND ArrivingAt = @ArrivingAt AND 
    DepartureTime between DateAdd(s, -1 * @SecondsOffset, @DesiredTime) AND DateAdd(s, @SecondsOffset, @DesiredTime)
GO