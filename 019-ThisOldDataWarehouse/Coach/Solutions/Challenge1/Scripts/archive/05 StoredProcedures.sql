/****** Object:  StoredProcedure [Integration].[GetLastETLCutoffTime]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[GetLastETLCutoffTime] @TableName [sysname] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SELECT [Cutoff Time] AS CutoffTime
    FROM Integration.[ETL Cutoff]
    WHERE [Table Name] = @TableName;

END;
GO

/****** Object:  StoredProcedure [Integration].[GetLineageKey]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[GetLineageKey] @TableName [sysname],@NewCutoffTime [datetime2](7) AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @DataLoadStartedWhen datetime2(7) = SYSDATETIME();

    INSERT Integration.Lineage
        ([Data Load Started], [Table Name], [Data Load Completed],
         [Was Successful], [Source System Cutoff Time])
    VALUES
        (@DataLoadStartedWhen, @TableName, NULL,
         0, @NewCutoffTime);

    SELECT TOP(1) [Lineage Key] AS LineageKey
    FROM Integration.Lineage
    WHERE [Table Name] = @TableName
    AND [Data Load Started] = @DataLoadStartedWhen
    ORDER BY LineageKey DESC;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[GetLoadDate]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[GetLoadDate] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SELECT [Load_Date] AS LoadDate
    FROM Integration.[Load_Control];

END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedCityData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedCityData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'City'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    UPDATE Dimension.City
        SET City.[Valid To] = v_City_Stage.[Valid From]
    FROM Integration.v_City_Stage
    WHERE v_City_Stage.[WWI City ID] = City.[WWI City ID]
    and City.[Valid To] = @EndofTime;

    INSERT Dimension.City
        ([WWI City ID], City, [State Province], Country, Continent,
         [Sales Territory], Region, Subregion, 
         [Latest Recorded Population], [Valid From], [Valid To],
         [Lineage Key])
    SELECT [WWI City ID], City, [State Province], Country, Continent,
           [Sales Territory], Region, Subregion, 
           [Latest Recorded Population], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.City_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE [Integration].[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'City'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'City';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedCustomerData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedCustomerData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Customer'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);
	
    UPDATE Dimension.Customer
        SET Customer.[Valid To] = v_Customer_Stage.[Valid From]
    FROM Integration.v_Customer_Stage
    WHERE v_Customer_Stage.[WWI Customer ID] = Customer.[WWI Customer ID]
    and Customer.[Valid To] = @EndofTime;

    INSERT Dimension.Customer
        ([WWI Customer ID], Customer, [Bill To Customer], Category,
         [Buying Group], [Primary Contact], [Postal Code], [Valid From], [Valid To],
         [Lineage Key])
    SELECT [WWI Customer ID], Customer, [Bill To Customer], Category,
           [Buying Group], [Primary Contact], [Postal Code], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.Customer_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Customer'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Customer';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedEmployeeData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedEmployeeData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Employee'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    UPDATE Dimension.Employee
        SET Employee.[Valid To] = v_Employee_Stage.[Valid From]
    FROM Integration.v_Employee_Stage
    WHERE v_Employee_Stage.[WWI Employee ID] = Employee.[WWI Employee ID]
    and Employee.[Valid To] = @EndofTime;

    INSERT Dimension.Employee
        ([WWI Employee ID], Employee, [Preferred Name], [Is Salesperson], Photo, [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Employee ID], Employee, [Preferred Name], [Is Salesperson], Photo, [Valid From], [Valid To],
           @LineageKey
    FROM Integration.Employee_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Employee'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Employee';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedMovementData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedMovementData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Movement'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

    UPDATE Integration.Movement_Staging
        SET Integration.Movement_Staging.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = Integration.Movement_Staging.[WWI Stock Item ID]
                                           AND Integration.Movement_Staging.[Last Modifed When] > si.[Valid From]
                                           AND Integration.Movement_Staging.[Last Modifed When] <= si.[Valid To]
									       ORDER BY si.[Valid From]), 0),
            Integration.Movement_Staging.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                         FROM Dimension.Customer AS c
                                         WHERE c.[WWI Customer ID] = Integration.Movement_Staging.[WWI Customer ID]
                                         AND Integration.Movement_Staging.[Last Modifed When] > c.[Valid From]
                                         AND Integration.Movement_Staging.[Last Modifed When] <= c.[Valid To]
									     ORDER BY c.[Valid From]), 0),
            Integration.Movement_Staging.[Supplier Key] = COALESCE((SELECT TOP(1) s.[Supplier Key]
                                         FROM Dimension.Supplier AS s
                                         WHERE s.[WWI Supplier ID] = Integration.Movement_Staging.[WWI Supplier ID]
                                         AND Integration.Movement_Staging.[Last Modifed When] > s.[Valid From]
                                         AND Integration.Movement_Staging.[Last Modifed When] <= s.[Valid To]
									     ORDER BY s.[Valid From]), 0),
            Integration.Movement_Staging.[Transaction Type Key] = COALESCE((SELECT TOP(1) tt.[Transaction Type Key]
                                                 FROM Dimension.[Transaction Type] AS tt
                                                 WHERE tt.[WWI Transaction Type ID] = Integration.Movement_Staging.[WWI Transaction Type ID]
                                                 AND Integration.Movement_Staging.[Last Modifed When] > tt.[Valid From]
                                                 AND Integration.Movement_Staging.[Last Modifed When] <= tt.[Valid To]
									             ORDER BY tt.[Valid From]), 0);

    -- Update existing Fact records with latest values
	
	UPDATE FACT.MOVEMENT
	SET FACT.MOVEMENT.[Date Key] = Integration.Movement_Staging.[Date Key],
        FACT.MOVEMENT.[Stock Item Key] = Integration.Movement_Staging.[Stock Item Key],
        FACT.MOVEMENT.[Customer Key] = Integration.Movement_Staging.[Customer Key],
        FACT.MOVEMENT.[Supplier Key] = Integration.Movement_Staging.[Supplier Key],
        FACT.MOVEMENT.[Transaction Type Key] = Integration.Movement_Staging.[Transaction Type Key],
        FACT.MOVEMENT.[WWI Invoice ID] = Integration.Movement_Staging.[WWI Invoice ID],
        FACT.MOVEMENT.[WWI Purchase Order ID] = Integration.Movement_Staging.[WWI Purchase Order ID],
        FACT.MOVEMENT.Quantity = Integration.Movement_Staging.Quantity, 
        FACT.MOVEMENT.[Lineage Key] = @LineageKey
		FROM Integration.Movement_Staging
		WHERE FACT.MOVEMENT.[WWI Stock Item Transaction ID] = Integration.Movement_Staging.[WWI Stock Item Transaction ID];    

	--Insert new records into the fact table

    INSERT Fact.Movement 
			([Date Key], [Stock Item Key], [Customer Key], [Supplier Key], [Transaction Type Key],
            [WWI Stock Item Transaction ID], [WWI Invoice ID], [WWI Purchase Order ID], Quantity, [Lineage Key])
    SELECT [Date Key], [Stock Item Key], [Customer Key], [Supplier Key], [Transaction Type Key],
            [WWI Stock Item Transaction ID], [WWI Invoice ID], [WWI Purchase Order ID], Quantity, @LineageKey
			FROM Integration.Movement_Staging
			WHERE [WWI Stock Item Transaction ID] NOT IN (SELECT [WWI Stock Item Transaction ID] FROM FACT.MOVEMENT);
	
	UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Movement'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Movement';
    COMMIT;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedOrderData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedOrderData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Order'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

 UPDATE Integration.Order_Staging
        SET Integration.Order_Staging.[City Key] = COALESCE((SELECT TOP(1) c.[City Key]
                                     FROM Dimension.City AS c
                                     WHERE c.[WWI City ID] = Integration.Order_Staging.[WWI City ID]
                                     AND Integration.Order_Staging.[Last Modified When] > c.[Valid From]
                                     AND Integration.Order_Staging.[Last Modified When] <= c.[Valid To]
									 ORDER BY c.[Valid From]), 0),
            Integration.Order_Staging.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                         FROM Dimension.Customer AS c
                                         WHERE c.[WWI Customer ID] = Integration.Order_Staging.[WWI Customer ID]
                                         AND Integration.Order_Staging.[Last Modified When] > c.[Valid From]
                                         AND Integration.Order_Staging.[Last Modified When] <= c.[Valid To]
    									 ORDER BY c.[Valid From]), 0),
            Integration.Order_Staging.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = Integration.Order_Staging.[WWI Stock Item ID]
                                           AND Integration.Order_Staging.[Last Modified When] > si.[Valid From]
                                           AND Integration.Order_Staging.[Last Modified When] <= si.[Valid To]
					                       ORDER BY si.[Valid From]), 0),
            Integration.Order_Staging.[Salesperson Key] = COALESCE((SELECT TOP(1) e.[Employee Key]
                                         FROM Dimension.Employee AS e
                                         WHERE e.[WWI Employee ID] = Integration.Order_Staging.[WWI Salesperson ID]
                                         AND Integration.Order_Staging.[Last Modified When] > e.[Valid From]
                                         AND Integration.Order_Staging.[Last Modified When] <= e.[Valid To]
									     ORDER BY e.[Valid From]), 0),
            Integration.Order_Staging.[Picker Key] = COALESCE((SELECT TOP(1) e.[Employee Key]
                                       FROM Dimension.Employee AS e
                                       WHERE e.[WWI Employee ID] = Integration.Order_Staging.[WWI Picker ID]
                                       AND Integration.Order_Staging.[Last Modified When] > e.[Valid From]
                                       AND Integration.Order_Staging.[Last Modified When] <= e.[Valid To]
									   ORDER BY e.[Valid From]), 0);

    -- Remove any existing entries for any of these orders

    DELETE FROM Fact.[Order]
    WHERE [WWI Order ID] IN (SELECT [WWI Order ID] FROM Integration.Order_Staging)
	OPTION ( LABEL = N'CustomJoin', HASH JOIN ) ;

    -- Insert all current details for these orders

    INSERT Fact.[Order]
        ([City Key], [Customer Key], [Stock Item Key], [Order Date Key], [Picked Date Key],
         [Salesperson Key], [Picker Key], [WWI Order ID], [WWI Backorder ID], [Description],
         Package, Quantity, [Unit Price], [Tax Rate], [Total Excluding Tax], [Tax Amount],
         [Total Including Tax], [Lineage Key])
    SELECT [City Key], [Customer Key], [Stock Item Key], [Order Date Key], [Picked Date Key],
           [Salesperson Key], [Picker Key], [WWI Order ID], [WWI Backorder ID], [Description],
           Package, Quantity, [Unit Price], [Tax Rate], [Total Excluding Tax], [Tax Amount],
           [Total Including Tax], @LineageKey
    FROM Integration.Order_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Order'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Order';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedPaymentMethodData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedPaymentMethodData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Payment Method'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    UPDATE Dimension.[Payment Method]
        SET [Payment Method].[Valid To] = v_PaymentMethod_Stage.[Valid From]
    FROM Integration.v_PaymentMethod_Stage
    WHERE v_PaymentMethod_Stage.[WWI Payment Method ID] = [Payment Method].[WWI Payment Method ID]
    and [Payment Method].[Valid To] = @EndofTime;

    INSERT Dimension.[Payment Method]
        ([WWI Payment Method ID], [Payment Method], [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Payment Method ID], [Payment Method], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.PaymentMethod_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Payment Method'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Payment Method';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedPurchaseData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedPurchaseData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Purchase'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

    UPDATE Integration.Purchase_Staging
        SET Integration.Purchase_Staging.[Supplier Key] = COALESCE((SELECT TOP(1) s.[Supplier Key]
                                     FROM Dimension.Supplier AS s
                                     WHERE s.[WWI Supplier ID] = Integration.Purchase_Staging.[WWI Supplier ID]
                                     AND Integration.Purchase_Staging.[Last Modified When] > s.[Valid From]
                                     AND Integration.Purchase_Staging.[Last Modified When] <= s.[Valid To]
									 ORDER BY s.[Valid From]), 0),
            Integration.Purchase_Staging.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = Integration.Purchase_Staging.[WWI Stock Item ID]
                                           AND Integration.Purchase_Staging.[Last Modified When] > si.[Valid From]
                                           AND Integration.Purchase_Staging.[Last Modified When] <= si.[Valid To]
									       ORDER BY si.[Valid From]), 0);

    -- Remove any existing entries for any of these purchase orders

    DELETE FROM Fact.Purchase
    WHERE [WWI Purchase Order ID] IN (SELECT [WWI Purchase Order ID] FROM Integration.Purchase_Staging)
	OPTION ( LABEL = N'CustomJoin', HASH JOIN );  

    -- Insert all current details for these purchase orders

    INSERT Fact.Purchase
        ([Date Key], [Supplier Key], [Stock Item Key], [WWI Purchase Order ID], [Ordered Outers], [Ordered Quantity],
         [Received Outers], Package, [Is Order Finalized], [Lineage Key])
    SELECT [Date Key], [Supplier Key], [Stock Item Key], [WWI Purchase Order ID], [Ordered Outers], [Ordered Quantity],
           [Received Outers], Package, [Is Order Finalized], @LineageKey
    FROM Integration.Purchase_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Purchase'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Purchase';

    COMMIT;

   -- RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedSaleData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedSaleData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Sale'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

	-- Find the dimension keys required

	UPDATE Integration.Sale_Staging
        SET Integration.Sale_Staging.[City Key] = COALESCE((SELECT TOP(1) c.[City Key]
                                     FROM Dimension.City AS c
                                     WHERE c.[WWI City ID] = Integration.Sale_Staging.[WWI City ID]
                                     AND Integration.Sale_Staging.[Last Modified When] > c.[Valid From]
                                     AND Integration.Sale_Staging.[Last Modified When] <= c.[Valid To]
									 ORDER BY c.[Valid From]), 0),
            Integration.Sale_Staging.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                           FROM Dimension.Customer AS c
                                           WHERE c.[WWI Customer ID] = Integration.Sale_Staging.[WWI Customer ID]
                                           AND Integration.Sale_Staging.[Last Modified When] > c.[Valid From]
                                           AND Integration.Sale_Staging.[Last Modified When] <= c.[Valid To]
									       ORDER BY c.[Valid From]), 0),
            Integration.Sale_Staging.[Bill To Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                                 FROM Dimension.Customer AS c
                                                 WHERE c.[WWI Customer ID] = Integration.Sale_Staging.[WWI Bill To Customer ID]
                                                 AND Integration.Sale_Staging.[Last Modified When] > c.[Valid From]
                                                 AND Integration.Sale_Staging.[Last Modified When] <= c.[Valid To]
									             ORDER BY c.[Valid From]), 0),
            Integration.Sale_Staging.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
                                           FROM Dimension.[Stock Item] AS si
                                           WHERE si.[WWI Stock Item ID] = Integration.Sale_Staging.[WWI Stock Item ID]
                                           AND Integration.Sale_Staging.[Last Modified When] > si.[Valid From]
                                           AND Integration.Sale_Staging.[Last Modified When] <= si.[Valid To]
									       ORDER BY si.[Valid From]), 0),
            Integration.Sale_Staging.[Salesperson Key] = COALESCE((SELECT TOP(1) e.[Employee Key]
                                            FROM Dimension.Employee AS e
                                            WHERE e.[WWI Employee ID] = Integration.Sale_Staging.[WWI Salesperson ID]
                                            AND Integration.Sale_Staging.[Last Modified When] > e.[Valid From]
                                            AND Integration.Sale_Staging.[Last Modified When] <= e.[Valid To]
									        ORDER BY e.[Valid From]), 0);

    -- Remove any existing entries for any of these invoices

	DELETE FROM Fact.Sale
	WHERE [WWI Invoice ID] IN(   
	SELECT [WWI Invoice ID] FROM Integration.Sale_Staging)  
	OPTION ( LABEL = N'CustomJoin', HASH JOIN ) ;  


    -- Insert all current details for these invoices

    INSERT Fact.Sale
        ([City Key], [Customer Key], [Bill To Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key],
         [Salesperson Key], [WWI Invoice ID], [Description], Package, Quantity, [Unit Price], [Tax Rate],
         [Total Excluding Tax], [Tax Amount], Profit, [Total Including Tax], [Total Dry Items], [Total Chiller Items], [Lineage Key])
    SELECT [City Key], [Customer Key], [Bill To Customer Key], [Stock Item Key], [Invoice Date Key], [Delivery Date Key],
           [Salesperson Key], [WWI Invoice ID], [Description], Package, Quantity, [Unit Price], [Tax Rate],
           [Total Excluding Tax], [Tax Amount], Profit, [Total Including Tax], [Total Dry Items], [Total Chiller Items], @LineageKey
    FROM Integration.Sale_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Sale'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Sale';

    COMMIT;

   -- RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedStockHoldingData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedStockHoldingData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    TRUNCATE TABLE Fact.[Stock Holding];

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Stock Holding'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

	UPDATE Integration.StockHolding_Staging
    SET Integration.StockHolding_Staging.[Stock Item Key] = COALESCE((SELECT TOP(1) si.[Stock Item Key]
				                                            FROM Dimension.[Stock Item] AS si
									                        WHERE si.[WWI Stock Item ID] = Integration.StockHolding_Staging.[WWI Stock Item ID]
													        ORDER BY si.[Valid To] DESC), 0);

    -- Remove all existing holdings

    --TRUNCATE TABLE Fact.[Stock Holding];

    -- Insert all current stock holdings

    INSERT Fact.[Stock Holding]
        ([Stock Item Key], [Quantity On Hand], [Bin Location], [Last Stocktake Quantity],
         [Last Cost Price], [Reorder Level], [Target Stock Level], [Lineage Key])
    SELECT [Stock Item Key], [Quantity On Hand], [Bin Location], [Last Stocktake Quantity],
           [Last Cost Price], [Reorder Level], [Target Stock Level], @LineageKey
    FROM Integration.StockHolding_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Stock Holding'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Stock Holding';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedStockItemData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedStockItemData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Stock Item'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    UPDATE Dimension.[Stock Item]
        SET [Stock Item].[Valid To] = v_StockItem_Stage.[Valid From]
    FROM Integration.v_StockItem_Stage
    WHERE v_StockItem_Stage.[WWI Stock Item ID] = [Stock Item].[WWI Stock Item ID]
    and [Stock Item].[Valid To] = @EndofTime;

    INSERT Dimension.[Stock Item]
        ([WWI Stock Item ID], [Stock Item], Color, [Selling Package], [Buying Package],
         Brand, Size, [Lead Time Days], [Quantity Per Outer], [Is Chiller Stock],
         Barcode, [Tax Rate], [Unit Price], [Recommended Retail Price], [Typical Weight Per Unit],
         Photo, [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Stock Item ID], [Stock Item], Color, [Selling Package], [Buying Package],
           Brand, Size, [Lead Time Days], [Quantity Per Outer], [Is Chiller Stock],
           Barcode, [Tax Rate], [Unit Price], [Recommended Retail Price], [Typical Weight Per Unit],
           Photo, [Valid From], [Valid To],
           @LineageKey
    FROM Integration.StockItem_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Stock Item'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Stock Item';
    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedSupplierData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedSupplierData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Supplier'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    UPDATE Dimension.Supplier
        SET Supplier.[Valid To] = v_Supplier_Stage.[Valid From]
    FROM Integration.v_Supplier_Stage
    WHERE v_Supplier_Stage.[WWI Supplier ID] = Supplier.[WWI Supplier ID]
    and Supplier.[Valid To] = @EndofTime;

    INSERT Dimension.[Supplier]
        ([WWI Supplier ID], Supplier, Category, [Primary Contact], [Supplier Reference],
         [Payment Days], [Postal Code], [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Supplier ID], Supplier, Category, [Primary Contact], [Supplier Reference],
           [Payment Days], [Postal Code], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.Supplier_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Supplier'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Supplier';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedTransactionData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedTransactionData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Transaction'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    -- Find the dimension keys required

    UPDATE Integration.Transaction_Staging
        SET Integration.Transaction_Staging.[Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                         FROM Dimension.Customer AS c
                                         WHERE c.[WWI Customer ID] = Integration.Transaction_Staging.[WWI Customer ID]
                                         AND Integration.Transaction_Staging.[Last Modified When] > c.[Valid From]
                                         AND Integration.Transaction_Staging.[Last Modified When] <= c.[Valid To]
									     ORDER BY c.[Valid From]), 0),
            Integration.Transaction_Staging.[Bill To Customer Key] = COALESCE((SELECT TOP(1) c.[Customer Key]
                                                 FROM Dimension.Customer AS c
                                                 WHERE c.[WWI Customer ID] = Integration.Transaction_Staging.[WWI Bill To Customer ID]
                                                 AND Integration.Transaction_Staging.[Last Modified When] > c.[Valid From]
                                                 AND Integration.Transaction_Staging.[Last Modified When] <= c.[Valid To]
									             ORDER BY c.[Valid From]), 0),
            Integration.Transaction_Staging.[Supplier Key] = COALESCE((SELECT TOP(1) s.[Supplier Key]
                                         FROM Dimension.Supplier AS s
                                         WHERE s.[WWI Supplier ID] = Integration.Transaction_Staging.[WWI Supplier ID]
                                         AND Integration.Transaction_Staging.[Last Modified When] > s.[Valid From]
                                         AND Integration.Transaction_Staging.[Last Modified When] <= s.[Valid To]
									     ORDER BY s.[Valid From]), 0),
            Integration.Transaction_Staging.[Transaction Type Key] = COALESCE((SELECT TOP(1) tt.[Transaction Type Key]
                                                 FROM Dimension.[Transaction Type] AS tt
                                                 WHERE tt.[WWI Transaction Type ID] = Integration.Transaction_Staging.[WWI Transaction Type ID]
                                                 AND Integration.Transaction_Staging.[Last Modified When] > tt.[Valid From]
                                                 AND Integration.Transaction_Staging.[Last Modified When] <= tt.[Valid To]
									             ORDER BY tt.[Valid From]), 0),
            Integration.Transaction_Staging.[Payment Method Key] = COALESCE((SELECT TOP(1) pm.[Payment Method Key]
                                                 FROM Dimension.[Payment Method] AS pm
                                                 WHERE pm.[WWI Payment Method ID] = Integration.Transaction_Staging.[WWI Payment Method ID]
                                                 AND Integration.Transaction_Staging.[Last Modified When] > pm.[Valid From]
                                                 AND Integration.Transaction_Staging.[Last Modified When] <= pm.[Valid To]
									             ORDER BY pm.[Valid From]), 0);

    -- Insert all the transactions

    INSERT Fact.[Transaction]
        ([Date Key], [Customer Key], [Bill To Customer Key], [Supplier Key], [Transaction Type Key],
         [Payment Method Key], [WWI Customer Transaction ID], [WWI Supplier Transaction ID],
         [WWI Invoice ID], [WWI Purchase Order ID], [Supplier Invoice Number], [Total Excluding Tax],
         [Tax Amount], [Total Including Tax], [Outstanding Balance], [Is Finalized], [Lineage Key], [WWI Transaction ID])
    SELECT [Date Key], [Customer Key], [Bill To Customer Key], [Supplier Key], [Transaction Type Key],
         [Payment Method Key], [WWI Customer Transaction ID], [WWI Supplier Transaction ID],
         [WWI Invoice ID], [WWI Purchase Order ID], [Supplier Invoice Number], [Total Excluding Tax],
         [Tax Amount], [Total Including Tax], [Outstanding Balance], [Is Finalized], @LineageKey, case when [WWI Customer Transaction ID] IS NULL THEN [WWI Supplier Transaction ID]
	  else [WWI Customer Transaction ID] END as [WWI Transaction ID]
    FROM Integration.Transaction_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Transaction'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Transaction';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[MigrateStagedTransactionTypeData]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[MigrateStagedTransactionTypeData] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';

    BEGIN TRAN;

    DECLARE @LineageKey int = (SELECT TOP(1) [Lineage Key]
                               FROM Integration.Lineage
                               WHERE [Table Name] = N'Transaction Type'
                               AND [Data Load Completed] IS NULL
                               ORDER BY [Lineage Key] DESC);

    UPDATE Dimension.[Transaction Type]
        SET [Transaction Type].[Valid To] = v_TransactionType_Stage.[Valid From]
    FROM Integration.v_TransactionType_Stage
    WHERE v_TransactionType_Stage.[WWI Transaction Type ID] = [Transaction Type].[WWI Transaction Type ID]
    and [Transaction Type].[Valid To] = @EndofTime;

    INSERT Dimension.[Transaction Type]
        ([WWI Transaction Type ID], [Transaction Type], [Valid From], [Valid To], [Lineage Key])
    SELECT [WWI Transaction Type ID], [Transaction Type], [Valid From], [Valid To],
           @LineageKey
    FROM Integration.TransactionType_Staging;

    UPDATE Integration.Lineage
        SET [Data Load Completed] = SYSDATETIME(),
            [Was Successful] = 1
    WHERE [Lineage Key] = @LineageKey;

    UPDATE Integration.[ETL Cutoff]
    SET [Cutoff Time] = (SELECT TOP(1) [Source System Cutoff Time]
						FROM [Integration].[Lineage]
						Where [Table Name] = N'Transaction Type'
						Order By [Source System Cutoff Time] DESC)
    WHERE [Table Name] = N'Transaction Type';

    COMMIT;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[PopulateDateDimensionForYear]    Script Date: 4/9/2020 9:00:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Integration].[PopulateDateDimensionForYear] @YearNumber [int] AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @DateCounter date = DATEFROMPARTS(@YearNumber, 1, 1);

    BEGIN TRY;

        BEGIN TRAN;

        WHILE YEAR(@DateCounter) = @YearNumber
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Dimension.[Date] WHERE [Date] = @DateCounter)
            BEGIN
                INSERT Dimension.[Date]
                    ([Date], [Day Number], [Day], [Month], [Short Month],
                     [Calendar Month Number], [Calendar Month Label], [Calendar Year], [Calendar Year Label],
                     [Fiscal Month Number], [Fiscal Month Label], [Fiscal Year], [Fiscal Year Label],
                     [ISO Week Number])
				  SELECT @DateCounter AS [Date],
							  DAY(@DateCounter) AS [Day Number],
							  CAST(DATENAME(day, @DateCounter) AS nvarchar(10)) AS [Day],
							  CAST(DATENAME(month, @DateCounter) AS nvarchar(10)) AS [Month],
							  CAST(SUBSTRING(DATENAME(month, @DateCounter), 1, 3) AS nvarchar(3)) AS [Short Month],
							  MONTH(@DateCounter) AS [Calendar Month Number],
							  CAST(N'CY' + CAST(YEAR(@DateCounter) AS nvarchar(4)) + N'-' + SUBSTRING(DATENAME(month, @DateCounter), 1, 3) AS nvarchar(10)) AS [Calendar Month Label],
							  YEAR(@DateCounter) AS [Calendar Year],
							  CAST(N'CY' + CAST(YEAR(@DateCounter) AS nvarchar(4)) AS nvarchar(10)) AS [Calendar Year Label],
							  CASE WHEN MONTH(@DateCounter) IN (11, 12)
								   THEN MONTH(@DateCounter) - 10
								   ELSE MONTH(@DateCounter) + 2
							  END AS [Fiscal Month Number],
							  CAST(N'FY' + CAST(CASE WHEN MONTH(@DateCounter) IN (11, 12)
													 THEN YEAR(@DateCounter) + 1
													 ELSE YEAR(@DateCounter)
												END AS nvarchar(4)) + N'-' + SUBSTRING(DATENAME(month, @DateCounter), 1, 3) AS nvarchar(20)) AS [Fiscal Month Label],
							  CASE WHEN MONTH(@DateCounter) IN (11, 12)
								   THEN YEAR(@DateCounter) + 1
								   ELSE YEAR(@DateCounter)
							  END AS [Fiscal Year],
							  CAST(N'FY' + CAST(CASE WHEN MONTH(@DateCounter) IN (11, 12)
													 THEN YEAR(@DateCounter) + 1
													 ELSE YEAR(@DateCounter)
												END AS nvarchar(4)) AS nvarchar(10)) AS [Fiscal Year Label],
							  DATEPART(ISO_WEEK, @DateCounter) AS [ISO Week Number]
							END;
							SET @DateCounter = DATEADD(day, 1, @DateCounter);
        END;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT N'Unable to populate dates for the year';
        THROW;
        --RETURN -1;
    END CATCH;

    --RETURN 0;
END;
GO

/****** Object:  StoredProcedure [Integration].[Configuration_ReseedETL]    Script Date: 5/27/2020 9:12:56 PM ******/
DROP PROCEDURE [Integration].[Configuration_ReseedETL]
GO

/****** Object:  StoredProcedure [Integration].[Configuration_ReseedETL]    Script Date: 6/03/2020 5:08:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Integration].[Configuration_ReseedETL] AS

BEGIN

	SET NOCOUNT ON;



	DECLARE @StartingETLCutoffTime datetime2(7) = '20121231';

	DECLARE @EndingETLCutoffTime datetime2(7) = '20200101';

	DECLARE @StartOfTime datetime2(7) = '20130101';

	DECLARE @EndOfTime datetime2(7) =  '99991231 23:59:59.9999999';



IF EXISTS(select * from [Integration].[Load_Control])
   update Integration.[Load_Control] 
		SET [Load_Date] = @EndingETLCutoffTime
ELSE
   insert into Integration.[Load_Control] values(@EndingETLCutoffTime);


	UPDATE Integration.[ETL Cutoff]

		SET [Cutoff Time] = @StartingETLCutoffTime;


	TRUNCATE TABLE Fact.Movement;

	TRUNCATE TABLE Fact.[Order];

	TRUNCATE TABLE Fact.Purchase;

	TRUNCATE TABLE Fact.Sale;

	TRUNCATE TABLE Fact.[Stock Holding];

	TRUNCATE TABLE Fact.[Transaction];

	TRUNCATE TABLE INtegration.City_Staging;

	TRUNCATE TABLE INtegration.Customer_Staging;

	TRUNCATE TABLE INtegration.Employee_Staging;

	TRUNCATE TABLE INtegration.Movement_Staging;

	TRUNCATE TABLE INtegration.Order_Staging;

	TRUNCATE TABLE INtegration.PaymentMethod_Staging;

	TRUNCATE TABLE INtegration.Purchase_Staging;

	TRUNCATE TABLE INtegration.Sale_Staging;

	TRUNCATE TABLE INtegration.StockHolding_Staging;

	TRUNCATE TABLE INtegration.StockItem_Staging;

	TRUNCATE TABLE INtegration.Supplier_Staging;

	TRUNCATE TABLE INtegration.Transaction_Staging;

	TRUNCATE TABLE Integration.TransactionType_Staging;

	DELETE Dimension.City;

	DELETE Dimension.Customer;

	DELETE Dimension.Employee;

	DELETE Dimension.[Payment Method];

	DELETE Dimension.[Stock Item];

	DELETE Dimension.Supplier;

	DELETE Dimension.[Transaction Type];


	SET IDENTITY_INSERT Dimension.City ON;
    INSERT Dimension.City

        ([City Key], [WWI City ID], City, [State Province], Country, Continent, [Sales Territory], Region, Subregion,

         [Latest Recorded Population], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A', N'N/A', N'N/A', N'N/A', N'N/A', N'N/A',

         0, @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.City OFF;

	SET IDENTITY_INSERT Dimension.Customer ON;
    INSERT Dimension.Customer

        ([Customer Key], [WWI Customer ID], [Customer], [Bill To Customer], Category, [Buying Group],

         [Primary Contact], [Postal Code], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A', N'N/A', N'N/A',

         N'N/A', N'N/A', @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.Customer OFF;

	SET IDENTITY_INSERT Dimension.Employee ON;
    INSERT Dimension.Employee

        ([Employee Key], [WWI Employee ID], Employee, [Preferred Name],

         [Is Salesperson], Photo, [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A',
         0, NULL, @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.Employee OFF;

	SET IDENTITY_INSERT Dimension.[Payment Method] ON;
    INSERT Dimension.[Payment Method]

        ([Payment Method Key], [WWI Payment Method ID], [Payment Method], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.[Payment Method] OFF;

	SET IDENTITY_INSERT Dimension.[Stock Item] ON;
    INSERT Dimension.[Stock Item]

        ([Stock Item Key], [WWI Stock Item ID], [Stock Item], Color, [Selling Package], [Buying Package],

         Brand, Size, [Lead Time Days], [Quantity Per Outer], [Is Chiller Stock],

         Barcode, [Tax Rate], [Unit Price], [Recommended Retail Price], [Typical Weight Per Unit],

         Photo, [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A', N'N/A', N'N/A',

         N'N/A', N'N/A', 0, 0, 0,

         N'N/A', 0, 0, 0, 0,

         NULL, @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.[Stock Item] OFF

	SET IDENTITY_INSERT Dimension.[Supplier] ON;
    INSERT Dimension.[Supplier]

        ([Supplier Key], [WWI Supplier ID], Supplier, Category, [Primary Contact], [Supplier Reference],

         [Payment Days], [Postal Code], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', N'N/A', N'N/A', N'N/A',

         0, N'N/A', @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.[Supplier] OFF

	SET IDENTITY_INSERT Dimension.[Transaction Type] ON;
    INSERT Dimension.[Transaction Type]

        ([Transaction Type Key], [WWI Transaction Type ID], [Transaction Type], [Valid From], [Valid To], [Lineage Key])

    VALUES

        (0, 0, N'Unknown', @StartOfTime, @EndOfTime, 0);
	SET IDENTITY_INSERT Dimension.[Transaction Type] OFF;

END;
GO

/****** Object:  StoredProcedure [Integration].[GetLastETLCutoffTime]    Script Date: 4/8/2020 7:20:40 PM ******/
DROP PROCEDURE [Integration].[GetLoadDate]
GO

/****** Object:  StoredProcedure [Integration].[GetLastETLCutoffTime]    Script Date: 4/8/2020 7:20:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Integration].[GetLoadDate]
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SELECT [Load_Date] AS LoadDate
    FROM Integration.[Load_Control];

END;
GO
