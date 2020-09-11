IF OBJECT_ID('[dbo].[Itineraries]', 'U') IS NOT NULL
DROP TABLE [dbo].[Itineraries]
GO
CREATE TABLE [dbo].[Itineraries]
(
    [Id]                        [uniqueidentifier] NOT NULL,
    [DepartingFlight]           [int] NULL,
    [ReturningFlight]           [int] NULL,
    [CarReservation]            [int] NULL,
    [CarReservationDuration]    [FLOAT] NULL,
    [HotelReservation]          [int] NULL,
    [HotelReservationDuration]  [int] NULL,
    [RecordLocator]             [varchar](10) NOT NULL,
    [PurchasedOn]               DateTimeOffset NOT NULL
    CONSTRAINT [PK_Itineraries] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Itineraries_DepartingFlight] FOREIGN KEY (DepartingFlight) REFERENCES [dbo].[Flights] (Id),
    CONSTRAINT [FK_Itineraries_ReturningFlight] FOREIGN KEY (ReturningFlight) REFERENCES [dbo].[Flights] (Id),
    CONSTRAINT [FK_Itineraries_CarReservation] FOREIGN KEY (CarReservation) REFERENCES [dbo].[Cars] (Id),
    CONSTRAINT [FK_Itineraries_HotelReservation] FOREIGN KEY (HotelReservation) REFERENCES [dbo].[Hotels] (Id)
);
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'GetItineraryById'
)
    DROP PROCEDURE dbo.GetItineraryById
GO
CREATE PROCEDURE dbo.GetItineraryById
    @Id UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON
    SELECT Lower(Replace(Convert(varchar(36), [Id]),'-', '')) as Id, [DepartingFlight], [ReturningFlight], [CarReservation], [CarReservationDuration], [HotelReservation], [HotelReservationDuration], [RecordLocator], [PurchasedOn] FROM Itineraries
    WHERE Id = @Id
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'GetItineraryByRecordLocatorId'
)
    DROP PROCEDURE dbo.GetItineraryByRecordLocatorId
GO
CREATE PROCEDURE dbo.GetItineraryByRecordLocatorId
    @RecordLocator [varchar](10)
AS
    SET NOCOUNT ON
    SELECT Lower(Replace(Convert(varchar(36), [Id]),'-', '')) as Id, [DepartingFlight], [ReturningFlight], [CarReservation], [CarReservationDuration], [HotelReservation], [HotelReservationDuration], [RecordLocator], [PurchasedOn] FROM Itineraries
    WHERE RecordLocator = @RecordLocator
GO


IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'UpsertItinerary'
)
    DROP PROCEDURE dbo.UpsertItinerary
GO
CREATE PROCEDURE dbo.UpsertItinerary
    @Id                        [uniqueidentifier],
    @DepartingFlight           [int]  null,
    @ReturningFlight           [int]  null,
    @CarReservation            [int]  null,
    @CarReservationDuration    [FLOAT]  null,
    @HotelReservation          [int]  null,
    @HotelReservationDuration  [int]  null,
    @RecordLocator             [varchar](10),
    @PurchasedOn               DateTimeOffset
AS
    SET NOCOUNT ON
    INSERT INTO Itineraries ([Id], [DepartingFlight], [ReturningFlight], [CarReservation], [CarReservationDuration], [HotelReservation], [HotelReservationDuration], [RecordLocator], [PurchasedOn])
                VALUES (@Id, @DepartingFlight, @ReturningFlight, @CarReservation, @CarReservationDuration, @HotelReservation, @HotelReservationDuration, @RecordLocator, @PurchasedOn)

    MERGE Itineraries AS target  
    USING (SELECT @Id, @DepartingFlight, @ReturningFlight, @CarReservation, @CarReservationDuration, @HotelReservation, @HotelReservationDuration, @RecordLocator) AS source ([Id], [DepartingFlight], [ReturningFlight], [CarReservation], [CarReservationDuration], [HotelReservation], [HotelReservationDuration], [RecordLocator])  
    ON (target.Id = source.Id)  
    WHEN MATCHED THEN   
        UPDATE SET [Id] = source.[Id], [DepartingFlight] = source.[DepartingFlight], [ReturningFlight] = source.[ReturningFlight], [CarReservation] = source.[CarReservation], [CarReservationDuration] = source.[CarReservationDuration], [HotelReservation] = source.[HotelReservation], [HotelReservationDuration] = source.[HotelReservationDuration], [RecordLocator] = source.[RecordLocator]
    WHEN NOT MATCHED THEN  
        INSERT ([Id], [DepartingFlight], [ReturningFlight], [CarReservation], [CarReservationDuration], [HotelReservation], [HotelReservationDuration], [RecordLocator])
        VALUES (source.[Id], source.[DepartingFlight], source.[ReturningFlight], source.[CarReservation], source.[CarReservationDuration], source.[HotelReservation], source.[HotelReservationDuration], source.[RecordLocator]);
GO