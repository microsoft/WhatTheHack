CREATE VIEW Customers
AS 
SELECT  FirstName,
        MiddleName,
        LastName,
        BirthDate,
        MaritalStatus,
        Gender,
        EmailAddress,
        YearlyIncome,
        TotalChildren,
        NumberChildrenAtHome,
        EnglishEducation as Education,
        EnglishOccupation as Occupation,
        HouseOwnerFlag
        NumberCarsOwned,
        AddressLine1,
        AddressLine2,
        City
        StateProvince,
        PostalCode,
        Phone,
        Title as Salutation
FROM [dbo].[DimCustomer] C
INNER JOIN [dbo].[DimGeography] G ON C.GeographyKey = G.GeographyKey