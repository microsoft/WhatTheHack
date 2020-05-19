CREATE VIEW Products
AS
SELECT  ProductKey,
        WeightUnitMeasureCode,
        SizeUnitMeasureCode,
        EnglishProductName as ProductName,
        EnglishProductSubCategoryName as ProductSubCategoryName,
        EnglishProductCategoryName as ProductCategoryName,
        StandardCost,
        FinishedGoodsFlag,
        Color,
        ListPrice,
        Size,
        SizeRange,
        Weight,
        DaysToManufacture,
        ProductLine,
        DealerPrice,
        Class,
        Style,
        ModelName,
        LargePhoto,
        EnglishDescription as Description,
        StartDate,
        EndDate,
        Status
FROM dimproduct p 
    inner join [dbo].[DimProductSubcategory] psc on p.productsubcategorykey = psc.productsubcategorykey
    inner join [dbo].[DimProductCategory] pc on psc.productcategorykey = pc.productcategorykey