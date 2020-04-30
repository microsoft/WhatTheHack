CREATE VIEW BikeBuyerTraining
AS 
SELECT  DATEDIFF(year, CAST(BirthDate AS Datetime), GETDATE()) AS Age,
        MaritalStatus,
        Gender,
        YearlyIncome,
        TotalChildren,
        NumberChildrenAtHome,
        EnglishEducation AS Education,
        EnglishOccupation AS Occupation,
        HouseOwnerFlag,
        CAST(NumberCarsOwned AS integer) AS NumberCarsOwned,
        StateProvinceCode,
        PostalCode,
        CASE WHEN BikeOrderCount IS NULL THEN 0 ELSE 1 END AS BikeBuyer
FROM [dbo].[DimCustomer] C
INNER JOIN [dbo].[DimGeography] G ON C.GeographyKey = G.GeographyKey
LEFT OUTER JOIN 
(
    SELECT  CustomerKey,
            COUNT(salesordernumber) AS BikeOrderCount
    FROM    [dbo].[FactInternetSales] f
            INNER JOIN dimproduct p ON f.productkey = p.productkey
            INNER JOIN [dbo].[DimProductSubcategory] psc ON p.productsubcategorykey = psc.productsubcategorykey
            INNER JOIN [dbo].[DimProductCategory] pc ON psc.productcategorykey = pc.productcategorykey
    WHERE   englishproductcategoryname = 'Bikes'
    GROUP BY customerkey
) F ON C.CustomerKey = F.CustomerKey
WHERE g.EnglishCountryRegionName = 'United States'