IF OBJECT_ID('[dbo].[Carts]', 'U') IS NOT NULL
DROP TABLE [dbo].[Carts]
GO
CREATE TABLE [dbo].[Carts]
(
    [Id]                        [uniqueidentifier] NOT NULL,
    [DepartingFlight]           [int] NULL,
    [ReturningFlight]           [int] NULL,
    [CarReservation]            [int] NULL,
    [CarReservationDuration]    [FLOAT] NULL,
    [HotelReservation]          [int] NULL,
    [HotelReservationDuration]  [int] NULL,
    CONSTRAINT [PK_Carts] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Carts_DepartingFlight] FOREIGN KEY (DepartingFlight) REFERENCES [dbo].[Flights] (Id),
    CONSTRAINT [FK_Carts_ReturningFlight] FOREIGN KEY (ReturningFlight) REFERENCES [dbo].[Flights] (Id),
    CONSTRAINT [FK_Carts_CarReservation] FOREIGN KEY (CarReservation) REFERENCES [dbo].[Cars] (Id),
    CONSTRAINT [FK_Carts_HotelReservation] FOREIGN KEY (HotelReservation) REFERENCES [dbo].[Hotels] (Id)
);
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'GetCartById'
)
    DROP PROCEDURE dbo.GetCartById
GO
CREATE PROCEDURE dbo.GetCartById
    @Id UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON
    SELECT  Lower(Replace(Convert(varchar(36), [Id]),'-', '')) as Id, [DepartingFlight], [ReturningFlight], [CarReservation], [CarReservationDuration], [HotelReservation], [HotelReservationDuration]  FROM Carts
    WHERE Id = @Id
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'DeleteCart'
)
    DROP PROCEDURE dbo.DeleteCart
GO
CREATE PROCEDURE dbo.DeleteCart
    @Id UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON
    DELETE FROM Carts
    WHERE Id = @Id
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'UpsertCartFlights'
)
    DROP PROCEDURE dbo.UpsertCartFlights
GO
CREATE PROCEDURE dbo.UpsertCartFlights
    @Id UNIQUEIDENTIFIER,
    @DepartingFlight [int]  null,
    @ReturningFlight [int]   null 
AS
    SET NOCOUNT ON
    MERGE CARTS AS target  
    USING (SELECT @Id, @DepartingFlight, @ReturningFlight) AS source (Id, DepartingFlight, ReturningFlight)  
    ON (target.Id = source.Id)  
    WHEN MATCHED THEN   
        UPDATE SET DepartingFlight = source.DepartingFlight, ReturningFlight = source.ReturningFlight
    WHEN NOT MATCHED THEN  
        INSERT (Id, DepartingFlight, ReturningFlight)  
        VALUES (source.Id, source.DepartingFlight, source.ReturningFlight);
GO

IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'UpsertCartCar'
)
    DROP PROCEDURE dbo.UpsertCartCar
GO
CREATE PROCEDURE dbo.UpsertCartCar
    @Id UNIQUEIDENTIFIER,
    @CarReservation [int]  null,
    @CarReservationDuration [FLOAT]  null 
AS
    SET NOCOUNT ON
    MERGE CARTS AS target  
    USING (SELECT @Id, @CarReservation, @CarReservationDuration) AS source (Id, CarReservation, CarReservationDuration)  
    ON (target.Id = source.Id)  
    WHEN MATCHED THEN   
        UPDATE SET CarReservation = source.CarReservation, CarReservationDuration = source.CarReservationDuration
    WHEN NOT MATCHED THEN  
        INSERT (Id, CarReservation, CarReservationDuration)  
        VALUES (source.Id, source.CarReservation, source.CarReservationDuration);        
GO


IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'UpsertCartHotel'
)
    DROP PROCEDURE dbo.UpsertCartHotel
GO
CREATE PROCEDURE dbo.UpsertCartHotel
    @Id UNIQUEIDENTIFIER,
    @HotelReservation [int] null,
    @HotelReservationDuration [int]  null   
AS
    SET NOCOUNT ON

    MERGE CARTS AS target  
    USING (SELECT @Id, @HotelReservation, @HotelReservationDuration) AS source (Id, HotelReservation, HotelReservationDuration)  
    ON (target.Id = source.Id)  
    WHEN MATCHED THEN   
        UPDATE SET HotelReservation = source.HotelReservation, HotelReservationDuration = source.HotelReservationDuration
    WHEN NOT MATCHED THEN  
        INSERT (Id, HotelReservation, HotelReservationDuration)  
        VALUES (source.Id, source.HotelReservation, source.HotelReservationDuration);          
GO