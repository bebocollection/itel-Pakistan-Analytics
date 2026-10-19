
USE itel_Pakistan_Analytics;
GO

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('FactSales', 'DimRegions')
ORDER BY TABLE_NAME, ORDINAL_POSITION;



USE itel_Pakistan_Analytics;
GO

-- Check FactSales imported IDs
SELECT TOP (10)
    SaleID,
    DealerID,
    ProductID,
    RegionID,
    WarehouseID
FROM dbo.FactSales;

-- Check DimRegions imported IDs
SELECT
    RegionID,
    RegionName
FROM dbo.DimRegions;


USE itel_Pakistan_Analytics;
GO

-- Check imported records
SELECT *
FROM dbo.DimRegions_Stage
ORDER BY RegionID;

-- Check number of records
SELECT COUNT(*) AS TotalRegions
FROM dbo.DimRegions_Stage;

-- Check RegionID data type
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimRegions_Stage'
  AND COLUMN_NAME = 'RegionID';



USE itel_Pakistan_Analytics;
GO

-- Check all products
SELECT *
FROM dbo.DimProducts_Stage
ORDER BY ProductID;

-- Verify row count and unique products
SELECT
    COUNT(*) AS TotalProducts,
    COUNT(DISTINCT ProductID) AS DistinctProductIDs
FROM dbo.DimProducts_Stage;

-- Verify actual column data types
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimProducts_Stage'
ORDER BY ORDINAL_POSITION;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalDealers,
    COUNT(DISTINCT DealerID) AS UniqueDealerIDs
FROM dbo.DimDealers_Stage;


SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'DimDealers_Stage'
ORDER BY ORDINAL_POSITION;



SELECT TOP (10)
    DealerID,
    DealerName,
    City,
    RegionID,
    Channel,
    Tier,
    OnboardDate
FROM dbo.DimDealers_Stage
ORDER BY DealerID;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalDealers,
    COUNT(DISTINCT DealerID) AS DistinctDealerIDs,
    COUNT(*) - COUNT(DISTINCT DealerID)
        AS DuplicateOrNullCount,
    MIN(DealerID) AS FirstDealerID,
    MAX(DealerID) AS LastDealerID
FROM dbo.DimDealers_Stage;


USE itel_Pakistan_Analytics;
GO

SELECT
    d.DealerID,
    d.DealerName,
    d.City,
    d.RegionID,
    r.RegionName
FROM dbo.DimDealers_Stage AS d
LEFT JOIN dbo.DimRegions_Stage AS r
    ON d.RegionID = r.RegionID
ORDER BY d.DealerID;



USE itel_Pakistan_Analytics;
GO

SELECT
    d.DealerID,
    d.DealerName,
    d.City,
    d.RegionID,
    r.RegionName
FROM dbo.DimDealers_Stage AS d
LEFT JOIN dbo.DimRegions_Stage AS r
    ON d.RegionID = r.RegionID
ORDER BY d.DealerID;


SELECT
    d.DealerID,
    d.DealerName,
    d.RegionID
FROM dbo.DimDealers_Stage AS d
LEFT JOIN dbo.DimRegions_Stage AS r
    ON d.RegionID = r.RegionID
WHERE r.RegionID IS NULL;


SELECT
    COUNT(*) AS TotalWarehouses,
    COUNT(DISTINCT WarehouseID) AS DistinctWarehouseIDs,
    COUNT(*) - COUNT(DISTINCT WarehouseID)
        AS DuplicateOrNullCount,
    MIN(WarehouseID) AS FirstWarehouseID,
    MAX(WarehouseID) AS LastWarehouseID
FROM dbo.DimWarehouses_Stage;


SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'DimWarehouses_Stage'
ORDER BY ORDINAL_POSITION;


SELECT
    w.WarehouseID,
    w.WarehouseName,
    w.RegionID,
    r.RegionName
FROM dbo.DimWarehouses_Stage AS w
LEFT JOIN dbo.DimRegions_Stage AS r
    ON w.RegionID = r.RegionID
ORDER BY w.WarehouseID;


SELECT
    w.WarehouseID,
    w.WarehouseName,
    w.RegionID
FROM dbo.DimWarehouses_Stage AS w
LEFT JOIN dbo.DimRegions_Stage AS r
    ON w.RegionID = r.RegionID
WHERE r.RegionID IS NULL;


USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    SaleID,
    OrderDate,
    DealerID,
    ProductID,
    RegionID,
    WarehouseID,
    UnitsSold,
    UnitPricePKR,
    DiscountPct
FROM dbo.FactSales_Stage
ORDER BY SaleID;


USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalSales,
    COUNT(DISTINCT SaleID) AS UniqueSaleIDs,
    MIN(SaleID) AS FirstSaleID,
    MAX(SaleID) AS LastSaleID
FROM dbo.FactSales_Stage;

SELECT TOP (10) *
FROM dbo.FactSales_Stage
ORDER BY SaleID;


USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    s.SaleID,
    s.DealerID,
    d.DealerName,
    d.City,
    d.RegionID
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimDealers_Stage AS d
    ON s.DealerID = d.DealerID
ORDER BY s.SaleID;


USE itel_Pakistan_Analytics;
GO

SELECT
    s.SaleID,
    s.DealerID
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimDealers_Stage AS d
    ON s.DealerID = d.DealerID
WHERE d.DealerID IS NULL;


SELECT
    COUNT(*) AS TotalSales,

    COUNT(d.DealerID) AS MatchedSales,

    COUNT(*) - COUNT(d.DealerID)
        AS UnmatchedSales

FROM dbo.FactSales_Stage AS s

LEFT JOIN dbo.DimDealers_Stage AS d
    ON s.DealerID = d.DealerID;



USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    s.SaleID,
    s.ProductID,
    p.ModelName,
    p.Series,
    s.UnitsSold,
    s.UnitPricePKR
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimProducts_Stage AS p
    ON s.ProductID = p.ProductID
ORDER BY s.SaleID;



SELECT
    s.SaleID,
    s.ProductID
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimProducts_Stage AS p
    ON s.ProductID = p.ProductID
WHERE p.ProductID IS NULL;


SELECT
    COUNT(*) AS TotalSales,

    COUNT(p.ProductID) AS MatchedSales,

    COUNT(*) - COUNT(p.ProductID)
        AS UnmatchedSales

FROM dbo.FactSales_Stage AS s

LEFT JOIN dbo.DimProducts_Stage AS p
    ON s.ProductID = p.ProductID;


USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    s.SaleID,
    s.OrderDate,
    s.RegionID,
    r.RegionName,
    r.AdminType,
    s.UnitsSold,
    s.UnitPricePKR
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimRegions_Stage AS r
    ON s.RegionID = r.RegionID
ORDER BY s.SaleID;


USE itel_Pakistan_Analytics;
GO

SELECT
    s.SaleID,
    s.RegionID
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimRegions_Stage AS r
    ON s.RegionID = r.RegionID
WHERE r.RegionID IS NULL;


SELECT
    COUNT(*) AS TotalSales,
    COUNT(r.RegionID) AS MatchedSales,
    COUNT(*) - COUNT(r.RegionID) AS UnmatchedSales
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimRegions_Stage AS r
    ON s.RegionID = r.RegionID;



USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    s.SaleID,
    s.OrderDate,
    s.WarehouseID,
    w.WarehouseName,
    w.RegionID AS WarehouseRegionID,
    s.UnitsSold,
    s.UnitPricePKR
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimWarehouses_Stage AS w
    ON s.WarehouseID = w.WarehouseID
ORDER BY s.SaleID;


USE itel_Pakistan_Analytics;
GO

SELECT
    s.SaleID,
    s.WarehouseID
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimWarehouses_Stage AS w
    ON s.WarehouseID = w.WarehouseID
WHERE w.WarehouseID IS NULL;


SELECT
    COUNT(*) AS TotalSales,
    COUNT(w.WarehouseID) AS MatchedSales,
    COUNT(*) - COUNT(w.WarehouseID) AS UnmatchedSales
FROM dbo.FactSales_Stage AS s
LEFT JOIN dbo.DimWarehouses_Stage AS w
    ON s.WarehouseID = w.WarehouseID;




USE itel_Pakistan_Analytics;
GO

SELECT
    SaleID,
    UnitsSold,
    UnitPricePKR,
    DiscountPct
FROM dbo.FactSales_Stage
WHERE
       UnitsSold IS NULL
    OR UnitsSold <= 0
    OR UnitPricePKR IS NULL
    OR UnitPricePKR <= 0
    OR DiscountPct IS NULL
    OR DiscountPct < 0
    OR DiscountPct > 1;


SELECT
    COUNT(*) AS TotalTransactions,

    SUM(CASE
        WHEN UnitsSold IS NULL OR UnitsSold <= 0
        THEN 1 ELSE 0
    END) AS InvalidUnits,

    SUM(CASE
        WHEN UnitPricePKR IS NULL OR UnitPricePKR <= 0
        THEN 1 ELSE 0
    END) AS InvalidPrices,

    SUM(CASE
        WHEN DiscountPct IS NULL
          OR DiscountPct < 0
          OR DiscountPct > 1
        THEN 1 ELSE 0
    END) AS InvalidDiscounts

FROM dbo.FactSales_Stage;

CASE
    WHEN UnitsSold <= 0 THEN 1
    ELSE 0
END

--------------------------------------------------

SELECT TOP (10)
    SaleID,
    UnitsSold,
    UnitPricePKR,

    CAST(
        UnitsSold * UnitPricePKR
        AS DECIMAL(18,2)
    ) AS GrossSalesPKR

FROM dbo.FactSales_Stage
ORDER BY SaleID;


SELECT TOP (10)
    SaleID,
    UnitsSold,
    UnitPricePKR,
    DiscountPct,

    CAST(
        UnitsSold * UnitPricePKR * DiscountPct
        AS DECIMAL(18,2)
    ) AS DiscountAmountPKR

FROM dbo.FactSales_Stage
ORDER BY SaleID;


USE itel_Pakistan_Analytics;
GO

WITH SalesBase AS
(
    SELECT
        SaleID,
        UnitsSold,
        CAST(UnitPricePKR AS DECIMAL(18,2))
            AS UnitPricePKR,
        CAST(DiscountPct AS DECIMAL(5,4))
            AS DiscountPct
    FROM dbo.FactSales_Stage
),
GrossCalculation AS
(
    SELECT *,
        CAST(
            UnitsSold * UnitPricePKR
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR
    FROM SalesBase
),
DiscountCalculation AS
(
    SELECT *,
        CAST(
            GrossSalesPKR * DiscountPct
            AS DECIMAL(18,2)
        ) AS DiscountAmountPKR
    FROM GrossCalculation
)
SELECT TOP (10)
    SaleID,
    UnitsSold,
    UnitPricePKR,
    DiscountPct,
    GrossSalesPKR,
    DiscountAmountPKR,

    GrossSalesPKR - DiscountAmountPKR
        AS NetSalesPKR

FROM DiscountCalculation
ORDER BY SaleID;

-------------

USE itel_Pakistan_Analytics;
GO

WITH SalesAmounts AS
(
    SELECT
        UnitsSold,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountAmountPKR

    FROM dbo.FactSales_Stage
)
SELECT
    COUNT(*) AS TotalTransactions,

    SUM(UnitsSold) AS TotalUnitsSold,

    SUM(GrossSalesPKR) AS TotalGrossSalesPKR,

    SUM(DiscountAmountPKR)
        AS TotalDiscountPKR,

    SUM(GrossSalesPKR - DiscountAmountPKR)
        AS TotalNetSalesPKR

FROM SalesAmounts;

-------------------------


USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    SaleID,
    OrderDate,

    DATEFROMPARTS(
        YEAR(OrderDate),
        MONTH(OrderDate),
        1
    ) AS MonthStart

FROM dbo.FactSales_Stage
ORDER BY OrderDate;

----------------


USE itel_Pakistan_Analytics;
GO

WITH SalesAmounts AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart,

        UnitsSold,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountAmountPKR

    FROM dbo.FactSales_Stage
)

SELECT
    MonthStart,

    COUNT(*) AS TotalTransactions,

    SUM(UnitsSold) AS TotalUnitsSold,

    SUM(GrossSalesPKR) AS GrossSalesPKR,

    SUM(DiscountAmountPKR) AS DiscountPKR,

    SUM(
        GrossSalesPKR - DiscountAmountPKR
    ) AS NetSalesPKR

FROM SalesAmounts

GROUP BY MonthStart
ORDER BY MonthStart;

-------------------


USE itel_Pakistan_Analytics;
GO

-- Step 1: Calculate sales amounts
WITH SalesAmounts AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountAmountPKR

    FROM dbo.FactSales_Stage
),

-- Step 2: Monthly sales aggregation
MonthlySales AS
(
    SELECT
        MonthStart,
        SUM(
            GrossSalesPKR - DiscountAmountPKR
        ) AS NetSalesPKR
    FROM SalesAmounts
    GROUP BY MonthStart
)

-- Step 3: LAG and LEAD
SELECT
    MonthStart,
    NetSalesPKR,

    LAG(NetSalesPKR)
    OVER (ORDER BY MonthStart)
        AS PreviousMonthSalesPKR,

    LEAD(NetSalesPKR)
    OVER (ORDER BY MonthStart)
        AS NextMonthSalesPKR

FROM MonthlySales
ORDER BY MonthStart;

-----------------------------


USE itel_Pakistan_Analytics;
GO

WITH SalesAmounts AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountAmountPKR

    FROM dbo.FactSales_Stage
),
MonthlySales AS
(
    SELECT
        MonthStart,
        SUM(GrossSalesPKR - DiscountAmountPKR)
            AS NetSalesPKR
    FROM SalesAmounts
    GROUP BY MonthStart
),
SalesComparison AS
(
    SELECT
        MonthStart,
        NetSalesPKR,

        LEAD(NetSalesPKR)
        OVER (ORDER BY MonthStart)
            AS NextMonthSalesPKR

    FROM MonthlySales
)

SELECT
    MonthStart,
    NetSalesPKR,
    NextMonthSalesPKR,

    CAST(
        (NextMonthSalesPKR - NetSalesPKR)
        * 100.0 /
        NULLIF(NetSalesPKR, 0)
        AS DECIMAL(10,2)
    ) AS NextMonthGrowthPct

FROM SalesComparison
ORDER BY MonthStart;

--------------------------------------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Calculate sales amounts
WITH SalesAmounts AS
(
    SELECT
        SaleID,
        ProductID,
        UnitsSold,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountAmountPKR

    FROM dbo.FactSales_Stage
)

-- STEP 2: Product-wise aggregation
SELECT
    p.ProductID,
    p.ModelName,
    p.Series,

    COUNT(*) AS TotalTransactions,

    SUM(s.UnitsSold) AS TotalUnitsSold,

    SUM(s.GrossSalesPKR) AS GrossSalesPKR,

    SUM(s.DiscountAmountPKR) AS DiscountPKR,

    SUM(
        s.GrossSalesPKR - s.DiscountAmountPKR
    ) AS NetSalesPKR

FROM SalesAmounts AS s

INNER JOIN dbo.DimProducts_Stage AS p
    ON s.ProductID = p.ProductID

GROUP BY
    p.ProductID,
    p.ModelName,
    p.Series

ORDER BY
    NetSalesPKR DESC,
    p.ProductID;

----------------------------------------


USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(DISTINCT ProductID)
        AS TotalUniqueProducts,

    COUNT(*)
        AS TotalTransactions,

    SUM(UnitsSold)
        AS TotalUnitsSold

FROM dbo.FactSales_Stage;


---------------------------

SELECT
    p.ProductID,
    p.ModelName,
    p.Series,

    COUNT(*) AS TotalTransactions,
    SUM(s.UnitsSold) AS TotalUnitsSold

FROM dbo.FactSales_Stage AS s

INNER JOIN dbo.DimProducts_Stage AS p
    ON s.ProductID = p.ProductID

GROUP BY
    p.ProductID,
    p.ModelName,
    p.Series

-------------------------


USE itel_Pakistan_Analytics;
GO

-- Top 10 best-selling products by units

SELECT TOP (10)
    p.ProductID,
    p.ModelName,
    p.Series,

    COUNT(*) AS TotalTransactions,

    SUM(s.UnitsSold) AS TotalUnitsSold

FROM dbo.FactSales_Stage AS s

INNER JOIN dbo.DimProducts_Stage AS p
    ON s.ProductID = p.ProductID

GROUP BY
    p.ProductID,
    p.ModelName,
    p.Series

ORDER BY
    TotalUnitsSold DESC,
    p.ProductID ASC;

--------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Create sample data using a CTE
WITH ExampleSales AS
(
    SELECT *
    FROM (VALUES
        ('P001', 7000),
        ('P002', 7000),
        ('P003', 6500),
        ('P004', 6500),
        ('P005', 5000)
    ) AS x(ProductID, TotalUnitsSold)
)

-- STEP 2: Apply window functions
SELECT
    ProductID,
    TotalUnitsSold,

    ROW_NUMBER() OVER (
        ORDER BY TotalUnitsSold DESC,
                 ProductID ASC
    ) AS RowNum,

    RANK() OVER (
        ORDER BY TotalUnitsSold DESC
    ) AS SalesRank,

    DENSE_RANK() OVER (
        ORDER BY TotalUnitsSold DESC
    ) AS DenseSalesRank

FROM ExampleSales

ORDER BY TotalUnitsSold DESC, ProductID ASC;


-----------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Calculate total units per product
WITH ProductSales AS
(
    SELECT
        p.ProductID,
        p.ModelName,
        p.Series,

        SUM(s.UnitsSold) AS TotalUnitsSold

    FROM dbo.FactSales_Stage AS s

    INNER JOIN dbo.DimProducts_Stage AS p
        ON s.ProductID = p.ProductID

    GROUP BY
        p.ProductID,
        p.ModelName,
        p.Series
),

-- STEP 2: Assign three different rankings
ProductRanking AS
(
    SELECT
        ProductID,
        ModelName,
        Series,
        TotalUnitsSold,

        ROW_NUMBER() OVER (
            ORDER BY TotalUnitsSold DESC,
                     ProductID ASC
        ) AS RowNum,

        RANK() OVER (
            ORDER BY TotalUnitsSold DESC
        ) AS SalesRank,

        DENSE_RANK() OVER (
            ORDER BY TotalUnitsSold DESC
        ) AS DenseSalesRank

    FROM ProductSales
)

-- STEP 3: Show ranked products

SELECT
    ProductID,
    ModelName,
    Series,
    TotalUnitsSold,
    RowNum,
    SalesRank,
    DenseSalesRank

FROM ProductRanking

ORDER BY
    TotalUnitsSold DESC,
    ProductID ASC;

----------------------------------------


USE itel_Pakistan_Analytics;
GO

SELECT
    ProductID,
    COUNT(*) AS TotalTransactions,
    SUM(UnitsSold) AS TotalUnitsSold
FROM dbo.FactSales_Stage
WHERE ProductID = 'P009'
GROUP BY ProductID;

-------------------------------------------


USE itel_Pakistan_Analytics;
GO

WITH ExampleSales AS
(
    SELECT *
    FROM (VALUES
        ('X001', 1200),
        ('X002', 1150),
        ('X003', 1100),
        ('X004', 1100),
        ('X005', 1000),
        ('X006', 950),
        ('X007', 900),
        ('X008', 850),
        ('X009', 800),
        ('X010', 750),
        ('X011', 750),
        ('X012', 700)
    ) AS x(ProductID, TotalUnitsSold)
),
ProductRanking AS
(
    SELECT
        ProductID,
        TotalUnitsSold,

        ROW_NUMBER() OVER (
            ORDER BY TotalUnitsSold DESC,
                     ProductID ASC
        ) AS RowNum,

        RANK() OVER (
            ORDER BY TotalUnitsSold DESC
        ) AS SalesRank,

        DENSE_RANK() OVER (
            ORDER BY TotalUnitsSold DESC
        ) AS DenseSalesRank

    FROM ExampleSales
)

SELECT
    ProductID,
    TotalUnitsSold,
    RowNum,
    SalesRank,
    DenseSalesRank,

    CASE
        WHEN RowNum <= 10 THEN 'YES'
        ELSE 'NO'
    END AS Top10WithoutTies,

    CASE
        WHEN SalesRank <= 10 THEN 'YES'
        ELSE 'NO'
    END AS Top10WithTies

FROM ProductRanking
ORDER BY RowNum;

------------------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Calculate product-wise units
WITH ProductSales AS
(
    SELECT
        p.ProductID,
        p.ModelName,
        p.Series,

        SUM(s.UnitsSold)
            AS TotalUnitsSold

    FROM dbo.FactSales_Stage AS s

    INNER JOIN dbo.DimProducts_Stage AS p
        ON s.ProductID = p.ProductID

    GROUP BY
        p.ProductID,
        p.ModelName,
        p.Series
),

-- STEP 2: Calculate rankings
ProductRanking AS
(
    SELECT
        ProductID,
        ModelName,
        Series,
        TotalUnitsSold,

        ROW_NUMBER() OVER (
            ORDER BY TotalUnitsSold DESC,
                     ProductID ASC
        ) AS RowNum,

        RANK() OVER (
            ORDER BY TotalUnitsSold DESC
        ) AS SalesRank,

        DENSE_RANK() OVER (
            ORDER BY TotalUnitsSold DESC
        ) AS DenseSalesRank

    FROM ProductSales
)

-- STEP 3: Top 10 WITHOUT ties
SELECT
    ProductID,
    ModelName,
    TotalUnitsSold,
    RowNum,
    SalesRank,
    DenseSalesRank

FROM ProductRanking

WHERE RowNum <= 10

ORDER BY RowNum;

------------------------------


USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    s.SaleID,
    s.OrderDate,
    s.RegionID,
    r.RegionName,
    r.AdminType,
    s.UnitsSold,
    s.UnitPricePKR

FROM dbo.FactSales_Stage AS s

INNER JOIN dbo.DimRegions_Stage AS r
    ON s.RegionID = r.RegionID

ORDER BY s.SaleID;

---------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Calculate transaction amounts
WITH SalesAmounts AS
(
    SELECT
        RegionID,
        UnitsSold,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountAmountPKR

    FROM dbo.FactSales_Stage
)

-- STEP 2: Region-wise aggregation
SELECT
    r.RegionID,
    r.RegionName,
    r.AdminType,

    COUNT(*) AS TotalTransactions,

    SUM(s.UnitsSold) AS TotalUnitsSold,

    SUM(s.GrossSalesPKR) AS GrossSalesPKR,

    SUM(s.DiscountAmountPKR) AS DiscountPKR,

    SUM(
        s.GrossSalesPKR - s.DiscountAmountPKR
    ) AS NetSalesPKR

FROM SalesAmounts AS s

INNER JOIN dbo.DimRegions_Stage AS r
    ON s.RegionID = r.RegionID

GROUP BY
    r.RegionID,
    r.RegionName,
    r.AdminType

ORDER BY
    NetSalesPKR DESC,
    r.RegionID;

----------------------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Sales calculations
WITH SalesAmounts AS
(
    SELECT
        RegionID,
        UnitsSold,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountAmountPKR

    FROM dbo.FactSales_Stage
),

-- STEP 2: Region summary
RegionSales AS
(
    SELECT
        r.RegionID,
        r.RegionName,
        r.AdminType,

        COUNT(*) AS TotalTransactions,

        SUM(s.UnitsSold) AS TotalUnitsSold,

        SUM(s.GrossSalesPKR) AS GrossSalesPKR,

        SUM(s.DiscountAmountPKR) AS DiscountPKR,

        SUM(
            s.GrossSalesPKR - s.DiscountAmountPKR
        ) AS NetSalesPKR

    FROM SalesAmounts AS s

    INNER JOIN dbo.DimRegions_Stage AS r
        ON s.RegionID = r.RegionID

    GROUP BY
        r.RegionID,
        r.RegionName,
        r.AdminType
)

-- STEP 3: Rank regions
SELECT
    RegionID,
    RegionName,
    AdminType,
    TotalTransactions,
    TotalUnitsSold,
    GrossSalesPKR,
    DiscountPKR,
    NetSalesPKR,

    ROW_NUMBER() OVER (
        ORDER BY NetSalesPKR DESC,
                 RegionID ASC
    ) AS RowNum,

    RANK() OVER (
        ORDER BY NetSalesPKR DESC
    ) AS RevenueRank,

    DENSE_RANK() OVER (
        ORDER BY NetSalesPKR DESC
    ) AS DenseRevenueRank

FROM RegionSales

ORDER BY
    NetSalesPKR DESC,
    RegionID ASC;


---------------------------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Calculate sales amounts
WITH SalesAmounts AS
(
    SELECT
        RegionID,
        UnitsSold,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountPKR

    FROM dbo.FactSales_Stage
)

-- STEP 2: Region summary + Grand Total
SELECT
    CASE
        WHEN GROUPING(r.RegionID) = 1
            THEN 'ALL'
        ELSE r.RegionID
    END AS RegionID,

    CASE
        WHEN GROUPING(r.RegionID) = 1
            THEN 'GRAND TOTAL'
        ELSE r.RegionName
    END AS RegionName,

    COUNT(*) AS TotalTransactions,

    SUM(s.UnitsSold) AS TotalUnitsSold,

    SUM(s.GrossSalesPKR) AS GrossSalesPKR,

    SUM(s.DiscountPKR) AS DiscountPKR,

    SUM(
        s.GrossSalesPKR - s.DiscountPKR
    ) AS NetSalesPKR,

    GROUPING(r.RegionID) AS IsGrandTotal

FROM SalesAmounts AS s

INNER JOIN dbo.DimRegions_Stage AS r
    ON s.RegionID = r.RegionID

GROUP BY GROUPING SETS
(
    (r.RegionID, r.RegionName),
    ()
)

ORDER BY
    IsGrandTotal ASC,
    NetSalesPKR DESC;

-----------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Calculate transaction amounts
WITH SalesAmounts AS
(
    SELECT
        RegionID,
        UnitsSold,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountPKR

    FROM dbo.FactSales_Stage
),

-- STEP 2: Calculate sales by region
RegionSales AS
(
    SELECT
        r.RegionID,
        r.RegionName,

        COUNT(*) AS TotalTransactions,

        SUM(s.UnitsSold) AS TotalUnitsSold,

        SUM(s.GrossSalesPKR) AS GrossSalesPKR,

        SUM(s.DiscountPKR) AS DiscountPKR,

        SUM(
            s.GrossSalesPKR - s.DiscountPKR
        ) AS NetSalesPKR

    FROM SalesAmounts AS s

    INNER JOIN dbo.DimRegions_Stage AS r
        ON s.RegionID = r.RegionID

    GROUP BY
        r.RegionID,
        r.RegionName
)

-- STEP 3: Calculate revenue contribution %
SELECT
    RegionID,
    RegionName,
    TotalTransactions,
    TotalUnitsSold,
    GrossSalesPKR,
    DiscountPKR,
    NetSalesPKR,

    SUM(NetSalesPKR) OVER ()
        AS CompanyNetSalesPKR,

    CAST(
        NetSalesPKR * 100.0 /
        NULLIF(SUM(NetSalesPKR) OVER (), 0)
        AS DECIMAL(10,2)
    ) AS RevenueContributionPct,

    RANK() OVER (
        ORDER BY NetSalesPKR DESC
    ) AS RevenueRank

FROM RegionSales

ORDER BY
    NetSalesPKR DESC,
    RegionID ASC;

    -----------------------------------------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Transaction-level net sales
WITH SalesAmounts AS
(
    SELECT
        RegionID,

        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        )
        -
        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS NetSalesPKR

    FROM dbo.FactSales_Stage
),

-- STEP 2: Monthly sales per region
RegionMonthlySales AS
(
    SELECT
        RegionID,
        MonthStart,
        SUM(NetSalesPKR) AS NetSalesPKR
    FROM SalesAmounts
    GROUP BY RegionID, MonthStart
)

-- STEP 3: Previous month using PARTITION BY
SELECT
    m.RegionID,
    r.RegionName,
    m.MonthStart,
    m.NetSalesPKR,

    LAG(m.NetSalesPKR) OVER (
        PARTITION BY m.RegionID
        ORDER BY m.MonthStart
    ) AS PreviousMonthNetSalesPKR

FROM RegionMonthlySales AS m

INNER JOIN dbo.DimRegions_Stage AS r
    ON m.RegionID = r.RegionID

ORDER BY
    m.RegionID,
    m.MonthStart;

----------------------------------------------------------------


USE itel_Pakistan_Analytics;
GO

-- STEP 1: Calculate sales amounts
WITH SalesAmounts AS
(
    SELECT
        RegionID,

        DATEFROMPARTS(
            YEAR(OrderDate),
            MONTH(OrderDate),
            1
        ) AS MonthStart,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2))
            AS DECIMAL(18,2)
        ) AS GrossSalesPKR,

        CAST(
            UnitsSold *
            CAST(UnitPricePKR AS DECIMAL(18,2)) *
            CAST(DiscountPct AS DECIMAL(5,4))
            AS DECIMAL(18,2)
        ) AS DiscountPKR

    FROM dbo.FactSales_Stage
),

-- STEP 2: Monthly sales for each region
RegionMonthlySales AS
(
    SELECT
        RegionID,
        MonthStart,

        SUM(
            GrossSalesPKR - DiscountPKR
        ) AS NetSalesPKR

    FROM SalesAmounts

    GROUP BY RegionID, MonthStart
),

-- STEP 3: Previous month sales per region
MonthlyComparison AS
(
    SELECT
        RegionID,
        MonthStart,
        NetSalesPKR,

        LAG(NetSalesPKR) OVER
        (
            PARTITION BY RegionID
            ORDER BY MonthStart
        ) AS PreviousMonthSalesPKR

    FROM RegionMonthlySales
)

-- STEP 4: Calculate MoM Growth
SELECT
    m.RegionID,
    r.RegionName,
    m.MonthStart,
    m.NetSalesPKR,
    m.PreviousMonthSalesPKR,

    CAST(
        (
            m.NetSalesPKR
            - m.PreviousMonthSalesPKR
        ) * 100.0
        / NULLIF(m.PreviousMonthSalesPKR, 0)
        AS DECIMAL(10,2)
    ) AS MoMGrowthPct,

    CASE
        WHEN m.PreviousMonthSalesPKR IS NULL
            THEN 'First Month'

        WHEN m.PreviousMonthSalesPKR = 0
            THEN 'No Baseline'

        WHEN m.NetSalesPKR > m.PreviousMonthSalesPKR
            THEN 'Growth'

        WHEN m.NetSalesPKR < m.PreviousMonthSalesPKR
            THEN 'Decline'

        ELSE 'No Change'
    END AS SalesTrend

FROM MonthlyComparison AS m

INNER JOIN dbo.DimRegions_Stage AS r
    ON m.RegionID = r.RegionID

ORDER BY
    m.RegionID,
    m.MonthStart;


-----------------------

USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalReturns,
    COUNT(DISTINCT ReturnID) AS UniqueReturnIDs,
    MIN(ReturnID) AS FirstReturnID,
    MAX(ReturnID) AS LastReturnID
FROM dbo.FactReturns_Stage;

SELECT TOP (10)
    ReturnID,
    SaleID,
    ReturnDate,
    DealerID,
    ProductID,
    RegionID,
    WarehouseID,
    ReturnQty,
    RefundAmountPKR,
    ReturnReason,
    Restockable
FROM dbo.FactReturns_Stage
ORDER BY ReturnID;



SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'FactReturns_Stage'
ORDER BY ORDINAL_POSITION;

-----------------------------------


USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    r.ReturnID,
    r.SaleID,
    r.ReturnDate,
    r.ReturnQty,
    r.RefundAmountPKR,

    s.OrderDate,
    s.UnitsSold,
    s.UnitPricePKR

FROM dbo.FactReturns_Stage AS r

LEFT JOIN dbo.FactSales_Stage AS s
    ON r.SaleID = s.SaleID

ORDER BY r.ReturnID;



USE itel_Pakistan_Analytics;
GO

SELECT
    r.ReturnID,
    r.SaleID,
    r.ReturnDate,
    r.ReturnQty,
    r.RefundAmountPKR

FROM dbo.FactReturns_Stage AS r

LEFT JOIN dbo.FactSales_Stage AS s
    ON r.SaleID = s.SaleID

WHERE s.SaleID IS NULL;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalReturns,

    COUNT(s.SaleID) AS MatchedReturns,

    COUNT(*) - COUNT(s.SaleID)
        AS UnmatchedReturns

FROM dbo.FactReturns_Stage AS r

LEFT JOIN dbo.FactSales_Stage AS s
    ON r.SaleID = s.SaleID;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalReturns,

    SUM(ReturnQty) AS TotalReturnedUnits,

    SUM(RefundAmountPKR) AS TotalRefundPKR,

    SUM(CASE
        WHEN ReturnQty IS NULL OR ReturnQty <= 0
        THEN 1 ELSE 0
    END) AS InvalidReturnQty,

    SUM(CASE
        WHEN RefundAmountPKR IS NULL
          OR RefundAmountPKR <= 0
        THEN 1 ELSE 0
    END) AS InvalidRefundAmount

FROM dbo.FactReturns_Stage;



SELECT
    COUNT(*) AS TotalReturns,

    SUM(CASE
        WHEN r.ReturnQty > s.UnitsSold
        THEN 1 ELSE 0
    END) AS InvalidReturnQtyVsSale,

    SUM(CASE
        WHEN r.ReturnDate < s.OrderDate
        THEN 1 ELSE 0
    END) AS InvalidReturnDate,

    SUM(CASE
        WHEN r.DealerID <> s.DealerID
          OR r.ProductID <> s.ProductID
          OR r.RegionID <> s.RegionID
          OR r.WarehouseID <> s.WarehouseID
        THEN 1 ELSE 0
    END) AS SaleDetailsMismatch

FROM dbo.FactReturns_Stage AS r

INNER JOIN dbo.FactSales_Stage AS s
    ON r.SaleID = s.SaleID;



WITH RefundCheck AS
(
    SELECT
        r.ReturnID,

        CAST(
            r.RefundAmountPKR AS DECIMAL(18,2)
        ) AS ActualRefundPKR,

        CAST(
            r.ReturnQty
            * CAST(s.UnitPricePKR AS DECIMAL(18,2))
            * (1 - CAST(s.DiscountPct AS DECIMAL(5,4)))
            AS DECIMAL(18,2)
        ) AS ExpectedRefundPKR

    FROM dbo.FactReturns_Stage AS r

    INNER JOIN dbo.FactSales_Stage AS s
        ON r.SaleID = s.SaleID
)

SELECT
    COUNT(*) AS TotalReturns,

    SUM(ActualRefundPKR)
        AS TotalActualRefundPKR,

    SUM(ExpectedRefundPKR)
        AS TotalExpectedRefundPKR,

    SUM(CASE
        WHEN ABS(
            ActualRefundPKR - ExpectedRefundPKR
        ) > 0.01
        THEN 1 ELSE 0
    END) AS RefundMismatchCount

FROM RefundCheck;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalInventoryRecords,

    COUNT(DISTINCT SnapshotID)
        AS UniqueSnapshotIDs,

    COUNT(*) - COUNT(DISTINCT SnapshotID)
        AS DuplicateOrNullCount,

    MIN(SnapshotID) AS FirstSnapshotID,

    MAX(SnapshotID) AS LastSnapshotID,

    MIN(SnapshotDate) AS FirstSnapshotDate,

    MAX(SnapshotDate) AS LastSnapshotDate,

    COUNT(DISTINCT SnapshotDate)
        AS UniqueSnapshotDates

FROM dbo.FactInventory_Stage;



USE itel_Pakistan_Analytics;
GO

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE

FROM INFORMATION_SCHEMA.COLUMNS

WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'FactInventory_Stage'

ORDER BY ORDINAL_POSITION;



USE itel_Pakistan_Analytics;
GO

SELECT TOP (10)
    SnapshotID,
    SnapshotDate,
    WarehouseID,
    ProductID,

    OpeningStockUnits,
    ReceivedUnits,
    SoldUnits,
    RestockedReturnUnits,

    ClosingStockUnits,

    (
        OpeningStockUnits
        + ReceivedUnits
        - SoldUnits
        + RestockedReturnUnits
    ) AS CalculatedClosingStock

FROM dbo.FactInventory_Stage

ORDER BY SnapshotID;



USE itel_Pakistan_Analytics;
GO

WITH StockAudit AS
(
    SELECT
        SnapshotID,
        ClosingStockUnits,

        (
            OpeningStockUnits
            + ReceivedUnits
            - SoldUnits
            + RestockedReturnUnits
        ) AS CalculatedClosingStock

    FROM dbo.FactInventory_Stage
)

SELECT
    COUNT(*) AS TotalInventoryRecords,

    SUM(
        CASE
            WHEN ClosingStockUnits
                 = CalculatedClosingStock
            THEN 1
            ELSE 0
        END
    ) AS MatchedStockRecords,

    SUM(
        CASE
            WHEN ClosingStockUnits IS NULL
              OR CalculatedClosingStock IS NULL
              OR ClosingStockUnits
                 <> CalculatedClosingStock
            THEN 1
            ELSE 0
        END
    ) AS StockMismatchCount

FROM StockAudit;




USE itel_Pakistan_Analytics;
GO

SELECT
    SnapshotID,
    SnapshotDate,
    WarehouseID,
    ProductID,
    OpeningStockUnits,
    ReceivedUnits,
    SoldUnits,
    RestockedReturnUnits,
    ClosingStockUnits,
    ReorderPointUnits

FROM dbo.FactInventory_Stage

WHERE OpeningStockUnits IS NULL
   OR OpeningStockUnits < 0
   OR ReceivedUnits IS NULL
   OR ReceivedUnits < 0
   OR SoldUnits IS NULL
   OR SoldUnits < 0
   OR RestockedReturnUnits IS NULL
   OR RestockedReturnUnits < 0
   OR ClosingStockUnits IS NULL
   OR ClosingStockUnits < 0
   OR ReorderPointUnits IS NULL
   OR ReorderPointUnits < 0

ORDER BY SnapshotID;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalInventoryRecords,

    COUNT(w.WarehouseID) AS MatchedWarehouses,

    COUNT(*) - COUNT(w.WarehouseID)
        AS UnmatchedWarehouses

FROM dbo.FactInventory_Stage AS i

LEFT JOIN dbo.DimWarehouses_Stage AS w
    ON i.WarehouseID = w.WarehouseID;



SELECT
    COUNT(*) AS TotalInventoryRecords,

    COUNT(p.ProductID) AS MatchedProducts,

    COUNT(*) - COUNT(p.ProductID)
        AS UnmatchedProducts

FROM dbo.FactInventory_Stage AS i

LEFT JOIN dbo.DimProducts_Stage AS p
    ON i.ProductID = p.ProductID;



SELECT
    COUNT(*) AS TotalInventoryRecords,

    COUNT(r.RegionID) AS MatchedRegions,

    COUNT(*) - COUNT(r.RegionID)
        AS UnmatchedRegions

FROM dbo.FactInventory_Stage AS i

LEFT JOIN dbo.DimRegions_Stage AS r
    ON i.RegionID = r.RegionID;


SELECT
    i.SnapshotID,
    i.WarehouseID,
    i.ProductID,
    i.RegionID
FROM dbo.FactInventory_Stage AS i

LEFT JOIN dbo.DimWarehouses_Stage AS w
    ON i.WarehouseID = w.WarehouseID

WHERE w.WarehouseID IS NULL;


USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalInventoryRecords,

    SUM(
        CASE
            WHEN i.RegionID = w.RegionID
            THEN 1
            ELSE 0
        END
    ) AS MatchedWarehouseRegions,

    SUM(
        CASE
            WHEN w.WarehouseID IS NULL
              OR i.RegionID IS NULL
              OR w.RegionID IS NULL
              OR i.RegionID <> w.RegionID
            THEN 1
            ELSE 0
        END
    ) AS RegionMismatchCount

FROM dbo.FactInventory_Stage AS i

LEFT JOIN dbo.DimWarehouses_Stage AS w
    ON i.WarehouseID = w.WarehouseID;
    


SELECT
    i.SnapshotID,
    i.WarehouseID,
    i.RegionID AS InventoryRegionID,
    w.RegionID AS WarehouseRegionID

FROM dbo.FactInventory_Stage AS i

LEFT JOIN dbo.DimWarehouses_Stage AS w
    ON i.WarehouseID = w.WarehouseID

WHERE w.WarehouseID IS NULL
   OR i.RegionID IS NULL
   OR w.RegionID IS NULL
   OR i.RegionID <> w.RegionID;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalTargetRecords,

    COUNT(DISTINCT TargetID) AS UniqueTargetIDs,

    COUNT(*) - COUNT(DISTINCT TargetID)
        AS DuplicateOrNullCount,

    MIN(TargetID) AS FirstTargetID,
    MAX(TargetID) AS LastTargetID,

    MIN(MonthStart) AS FirstMonth,
    MAX(MonthStart) AS LastMonth,

    COUNT(DISTINCT MonthStart)
        AS TotalMonths,

    COUNT(DISTINCT RegionID)
        AS TotalRegions

FROM dbo.FactTargets_Stage;



USE itel_Pakistan_Analytics;
GO

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE

FROM INFORMATION_SCHEMA.COLUMNS

WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'FactTargets_Stage'

ORDER BY ORDINAL_POSITION;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalDateRecords,
    COUNT(DISTINCT [Date]) AS UniqueDates,

    COUNT(*) - COUNT(DISTINCT [Date])
        AS DuplicateOrNullDates,

    MIN([Date]) AS FirstDate,
    MAX([Date]) AS LastDate,

    COUNT(DISTINCT YearMonth) AS TotalMonths,

    DATEDIFF(
        DAY,
        MIN([Date]),
        MAX([Date])
    ) + 1 AS ExpectedCalendarDays

FROM dbo.DimDate_Stage;



SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'DimDate_Stage'
ORDER BY ORDINAL_POSITION;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalDates,

    SUM(CASE
        WHEN [Year] <> YEAR([Date])
          OR QuarterNumber <> DATEPART(QUARTER, [Date])
          OR MonthNumber <> MONTH([Date])
          OR MonthStart <> DATEFROMPARTS(
              YEAR([Date]), MONTH([Date]), 1
          )
          OR YearMonth <> CONVERT(CHAR(7), [Date], 120)
          OR IsWeekend <>
             CASE
                 WHEN DATEDIFF(
                     DAY, '19000101', [Date]
                 ) % 7 IN (5, 6)
                 THEN 1 ELSE 0
             END
        THEN 1 ELSE 0
    END) AS InvalidDateAttributes

FROM dbo.DimDate_Stage;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalDates,

    SUM(CASE
        WHEN [Year] <> YEAR([Date])
        THEN 1 ELSE 0
    END) AS WrongYear,

    SUM(CASE
        WHEN QuarterNumber <> DATEPART(QUARTER, [Date])
        THEN 1 ELSE 0
    END) AS WrongQuarter,

    SUM(CASE
        WHEN MonthNumber <> MONTH([Date])
        THEN 1 ELSE 0
    END) AS WrongMonthNumber,

    SUM(CASE
        WHEN MonthStart <>
             DATEFROMPARTS(YEAR([Date]), MONTH([Date]), 1)
        THEN 1 ELSE 0
    END) AS WrongMonthStart,

    SUM(CASE
        WHEN YearMonth <> CONVERT(CHAR(7), [Date], 120)
        THEN 1 ELSE 0
    END) AS WrongYearMonth,

    SUM(CASE
        WHEN IsWeekend <>
             CASE
                 WHEN DATEDIFF(DAY, '19000101', [Date])
                      % 7 IN (5, 6)
                 THEN 1 ELSE 0
             END
        THEN 1 ELSE 0
    END) AS WrongWeekend

FROM dbo.DimDate_Stage;



SELECT TOP (10)
    [Date],
    MonthStart AS ImportedMonthStart,

    DATEFROMPARTS(
        YEAR([Date]),
        MONTH([Date]),
        1
    ) AS ExpectedMonthStart,

    MonthNumber,
    YearMonth

FROM dbo.DimDate_Stage

WHERE MonthStart <>
      DATEFROMPARTS(YEAR([Date]), MONTH([Date]), 1)

ORDER BY [Date];




USE itel_Pakistan_Analytics;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE dbo.DimDate_Stage

    SET MonthStart = DATEFROMPARTS(
        YEAR([Date]),
        MONTH([Date]),
        1
    )

    WHERE MonthStart IS NULL
       OR MonthStart <>
          DATEFROMPARTS(
              YEAR([Date]),
              MONTH([Date]),
              1
          );

    DECLARE @CorrectedRows INT = @@ROWCOUNT;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.DimDate_Stage
        WHERE [Date] IS NULL
           OR MonthStart IS NULL
           OR MonthStart <>
              DATEFROMPARTS(
                  YEAR([Date]),
                  MONTH([Date]),
                  1
              )
    )
    BEGIN
        ROLLBACK TRANSACTION;

        SELECT
            @CorrectedRows AS AttemptedCorrections,
            'ROLLED BACK' AS Status;
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION;

        SELECT
            @CorrectedRows AS CorrectedRows,
            'PASS' AS Status;
    END

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalDates,

    SUM(
        CASE
            WHEN MonthStart IS NULL
              OR MonthStart <>
                 DATEFROMPARTS(
                     YEAR([Date]),
                     MONTH([Date]),
                     1
                 )
            THEN 1
            ELSE 0
        END
    ) AS WrongMonthStart

FROM dbo.DimDate_Stage;



USE itel_Pakistan_Analytics;
GO

SELECT
    COUNT(*) AS TotalDates,

    SUM(CASE
        WHEN [Date] IS NULL
          OR [Year] IS NULL
          OR QuarterNumber IS NULL
          OR MonthNumber IS NULL
          OR MonthStart IS NULL
          OR YearMonth IS NULL
          OR IsWeekend IS NULL
          OR [Year] <> YEAR([Date])
          OR QuarterNumber <> DATEPART(QUARTER, [Date])
          OR MonthNumber <> MONTH([Date])
          OR MonthStart <> DATEFROMPARTS(
              YEAR([Date]), MONTH([Date]), 1
          )
          OR YearMonth <> CONVERT(CHAR(7), [Date], 120)
          OR IsWeekend <>
             CASE
                 WHEN DATEDIFF(DAY, '19000101', [Date])
                      % 7 IN (5, 6)
                 THEN 1 ELSE 0
             END
        THEN 1 ELSE 0
    END) AS InvalidDateAttributes

FROM dbo.DimDate_Stage;



USE itel_Pakistan_Analytics;
GO

SELECT
    (SELECT COUNT(*)
     FROM dbo.FactSales_Stage s
     LEFT JOIN dbo.DimDate_Stage d
         ON s.OrderDate = d.[Date]
     WHERE d.[Date] IS NULL
    ) AS MissingSalesDates,

    (SELECT COUNT(*)
     FROM dbo.FactReturns_Stage r
     LEFT JOIN dbo.DimDate_Stage d
         ON r.ReturnDate = d.[Date]
     WHERE d.[Date] IS NULL
    ) AS MissingReturnDates,

    (SELECT COUNT(*)
     FROM dbo.FactInventory_Stage i
     LEFT JOIN dbo.DimDate_Stage d
         ON i.SnapshotDate = d.[Date]
     WHERE d.[Date] IS NULL
    ) AS MissingInventoryDates,

    (SELECT COUNT(*)
     FROM dbo.FactTargets_Stage t
     LEFT JOIN dbo.DimDate_Stage d
         ON t.MonthStart = d.[Date]
     WHERE d.[Date] IS NULL
    ) AS MissingTargetDates;
