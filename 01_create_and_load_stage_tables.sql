/* REPRODUCTION HELPER (fresh DB only): created from synthetic source starter script.
   Uses _Stage table names to match the five-page Power BI report.
   IMPORTANT: requires access to the nine source CSVs, update BULK INSERT paths.
   Existing itel_Pakistan_Analytics production/working database is NOT modified.
   Run only once in an empty reproduction database.
*/
/* itel Pakistan — SYNTHETIC data only. Microsoft SQL Server 2019+ / Azure SQL (wizard import).
   Place all CSV files in a folder readable by the SQL SERVER SERVICE ACCOUNT.
   Replace C:\itel_pakistan_data\ with the actual SQL Server-side absolute path.
   On many remote/managed SQL environments use Import Flat File or SSIS instead of BULK INSERT.
*/
IF DB_ID(N'itel_Pakistan_Portfolio_Repro') IS NULL
    CREATE DATABASE itel_Pakistan_Portfolio_Repro;
GO
USE itel_Pakistan_Portfolio_Repro;
GO
CREATE TABLE dbo.DimRegions_Stage (
  RegionID varchar(3) NOT NULL PRIMARY KEY, RegionName nvarchar(80) NOT NULL,
  AdminType nvarchar(40) NOT NULL, Country nvarchar(40) NOT NULL
);
CREATE TABLE dbo.DimProducts_Stage (
  ProductID varchar(4) NOT NULL PRIMARY KEY, ModelName nvarchar(70) NOT NULL,
  Series nvarchar(30) NOT NULL, StorageGB smallint NOT NULL,
  ReferencePricePKR decimal(14,2) NOT NULL, UnitCostPKR decimal(14,2) NOT NULL,
  SimulatedAvailableFrom date NOT NULL
);
CREATE TABLE dbo.DimDealers_Stage (
  DealerID varchar(5) NOT NULL PRIMARY KEY, DealerName nvarchar(80) NOT NULL,
  City nvarchar(80) NOT NULL, RegionID varchar(3) NOT NULL,
  Channel varchar(20) NOT NULL, Tier varchar(12) NOT NULL, OnboardDate date NOT NULL,
  CONSTRAINT FK_DealerRegion FOREIGN KEY (RegionID) REFERENCES dbo.DimRegions_Stage(RegionID)
);
CREATE TABLE dbo.DimWarehouses_Stage (
  WarehouseID varchar(3) NOT NULL PRIMARY KEY, RegionID varchar(3) NOT NULL,
  WarehouseName nvarchar(100) NOT NULL, RegionLabel nvarchar(80) NOT NULL,
  CONSTRAINT FK_WarehouseRegion FOREIGN KEY (RegionID) REFERENCES dbo.DimRegions_Stage(RegionID)
);
CREATE TABLE dbo.DimDate_Stage (
  [Date] date NOT NULL PRIMARY KEY, [Year] smallint NOT NULL, QuarterNumber tinyint NOT NULL,
  MonthNumber tinyint NOT NULL, MonthName varchar(12) NOT NULL, YearMonth char(7) NOT NULL,
  MonthStart date NOT NULL, DayName varchar(12) NOT NULL, IsWeekend bit NOT NULL
);
CREATE TABLE dbo.FactSales_Stage (
  SaleID varchar(7) NOT NULL PRIMARY KEY, OrderDate date NOT NULL,
  DealerID varchar(5) NOT NULL, ProductID varchar(4) NOT NULL,
  RegionID varchar(3) NOT NULL, WarehouseID varchar(3) NOT NULL,
  UnitsSold int NOT NULL, UnitPricePKR decimal(14,2) NOT NULL, DiscountPct decimal(5,4) NOT NULL,
  CONSTRAINT FK_SalesDate FOREIGN KEY (OrderDate) REFERENCES dbo.DimDate_Stage([Date]),
  CONSTRAINT FK_SalesDealer FOREIGN KEY (DealerID) REFERENCES dbo.DimDealers_Stage(DealerID),
  CONSTRAINT FK_SalesProduct FOREIGN KEY (ProductID) REFERENCES dbo.DimProducts_Stage(ProductID),
  CONSTRAINT FK_SalesRegion FOREIGN KEY (RegionID) REFERENCES dbo.DimRegions_Stage(RegionID),
  CONSTRAINT FK_SalesWarehouse FOREIGN KEY (WarehouseID) REFERENCES dbo.DimWarehouses_Stage(WarehouseID),
  CONSTRAINT CK_SalesPositive CHECK (UnitsSold>0 AND UnitPricePKR>0 AND DiscountPct BETWEEN 0 AND 0.50)
);
CREATE TABLE dbo.FactReturns_Stage (
  ReturnID varchar(7) NOT NULL PRIMARY KEY, SaleID varchar(7) NOT NULL UNIQUE,
  ReturnDate date NOT NULL, DealerID varchar(5) NOT NULL, ProductID varchar(4) NOT NULL,
  RegionID varchar(3) NOT NULL, WarehouseID varchar(3) NOT NULL, ReturnQty int NOT NULL,
  RefundAmountPKR decimal(16,2) NOT NULL, ReturnReason nvarchar(50) NOT NULL,
  Restockable bit NOT NULL,
  CONSTRAINT FK_ReturnsSale FOREIGN KEY (SaleID) REFERENCES dbo.FactSales_Stage(SaleID),
  CONSTRAINT FK_ReturnsDate FOREIGN KEY (ReturnDate) REFERENCES dbo.DimDate_Stage([Date]),
  CONSTRAINT FK_ReturnsDealer FOREIGN KEY (DealerID) REFERENCES dbo.DimDealers_Stage(DealerID),
  CONSTRAINT FK_ReturnsProduct FOREIGN KEY (ProductID) REFERENCES dbo.DimProducts_Stage(ProductID),
  CONSTRAINT FK_ReturnsRegion FOREIGN KEY (RegionID) REFERENCES dbo.DimRegions_Stage(RegionID),
  CONSTRAINT FK_ReturnsWarehouse FOREIGN KEY (WarehouseID) REFERENCES dbo.DimWarehouses_Stage(WarehouseID),
  CONSTRAINT CK_ReturnsPositive CHECK(ReturnQty>0 AND RefundAmountPKR>=0)
);
CREATE TABLE dbo.FactInventory_Stage (
  SnapshotID varchar(6) NOT NULL PRIMARY KEY, SnapshotDate date NOT NULL,
  WarehouseID varchar(3) NOT NULL, ProductID varchar(4) NOT NULL, RegionID varchar(3) NOT NULL,
  OpeningStockUnits int NOT NULL, ReceivedUnits int NOT NULL,
  SoldUnits int NOT NULL, RestockedReturnUnits int NOT NULL, ClosingStockUnits int NOT NULL,
  ReorderPointUnits int NOT NULL,
  CONSTRAINT UQ_InventoryMonth UNIQUE (SnapshotDate,WarehouseID,ProductID),
  CONSTRAINT FK_InventoryDate FOREIGN KEY (SnapshotDate) REFERENCES dbo.DimDate_Stage([Date]),
  CONSTRAINT FK_InventoryWarehouse FOREIGN KEY (WarehouseID) REFERENCES dbo.DimWarehouses_Stage(WarehouseID),
  CONSTRAINT FK_InventoryProduct FOREIGN KEY (ProductID) REFERENCES dbo.DimProducts_Stage(ProductID),
  CONSTRAINT FK_InventoryRegion FOREIGN KEY (RegionID) REFERENCES dbo.DimRegions_Stage(RegionID),
  CONSTRAINT CK_StockBalance CHECK (
     ClosingStockUnits=OpeningStockUnits+ReceivedUnits-SoldUnits+RestockedReturnUnits
     AND ClosingStockUnits>=0)
);
CREATE TABLE dbo.FactTargets_Stage (
  TargetID varchar(5) NOT NULL PRIMARY KEY, MonthStart date NOT NULL,
  RegionID varchar(3) NOT NULL, RevenueTargetPKR decimal(18,2) NOT NULL,
  UnitsTarget int NOT NULL,
  CONSTRAINT UQ_TargetRegionMonth UNIQUE (MonthStart, RegionID),
  CONSTRAINT FK_TargetDate FOREIGN KEY (MonthStart) REFERENCES dbo.DimDate_Stage([Date]),
  CONSTRAINT FK_TargetRegion FOREIGN KEY (RegionID) REFERENCES dbo.DimRegions_Stage(RegionID),
  CONSTRAINT CK_TargetPositive CHECK (RevenueTargetPKR>0 AND UnitsTarget>0)
);
GO
/* Load dimension tables first, then facts. CSV files have an LF line ending.
   Edit the shared root path below in EVERY BULK INSERT statement. */
BULK INSERT dbo.DimRegions_Stage FROM 'C:\itel_pakistan_data\DimRegions.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
BULK INSERT dbo.DimProducts_Stage FROM 'C:\itel_pakistan_data\DimProducts.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
BULK INSERT dbo.DimDealers_Stage FROM 'C:\itel_pakistan_data\DimDealers.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
BULK INSERT dbo.DimWarehouses_Stage FROM 'C:\itel_pakistan_data\DimWarehouses.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
BULK INSERT dbo.DimDate_Stage FROM 'C:\itel_pakistan_data\DimDate.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
BULK INSERT dbo.FactSales_Stage FROM 'C:\itel_pakistan_data\FactSales.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
BULK INSERT dbo.FactReturns_Stage FROM 'C:\itel_pakistan_data\FactReturns.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
BULK INSERT dbo.FactInventory_Stage FROM 'C:\itel_pakistan_data\FactInventory.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
BULK INSERT dbo.FactTargets_Stage FROM 'C:\itel_pakistan_data\FactTargets.csv'
  WITH(FORMAT='CSV', FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', CODEPAGE='65001', TABLOCK);
GO
CREATE INDEX IX_Sales_OrderDate ON dbo.FactSales_Stage(OrderDate);
CREATE INDEX IX_Sales_RegionProduct ON dbo.FactSales_Stage(RegionID,ProductID);
CREATE INDEX IX_Sales_Dealer ON dbo.FactSales_Stage(DealerID);
CREATE INDEX IX_Returns_Date ON dbo.FactReturns_Stage(ReturnDate);
CREATE INDEX IX_Inventory_DateRegion ON dbo.FactInventory_Stage(SnapshotDate,RegionID);
CREATE INDEX IX_Targets_DateRegion ON dbo.FactTargets_Stage(MonthStart,RegionID);
GO
CREATE OR ALTER VIEW dbo.vw_SalesDetail AS
SELECT s.SaleID,s.OrderDate,r.RegionName,d.City,d.Channel,d.DealerName,
       p.Series,p.ModelName,s.UnitsSold,s.UnitPricePKR,s.DiscountPct,
       CAST(s.UnitsSold*s.UnitPricePKR AS decimal(18,2)) AS GrossSalesPKR,
       CAST(s.UnitsSold*s.UnitPricePKR*s.DiscountPct AS decimal(18,2)) AS DiscountAmountPKR,
       CAST(s.UnitsSold*s.UnitPricePKR*(1-s.DiscountPct) AS decimal(18,2)) AS BilledRevenuePKR,
       CAST(s.UnitsSold*p.UnitCostPKR AS decimal(18,2)) AS COGSPKR,
       CAST(s.UnitsSold*(s.UnitPricePKR*(1-s.DiscountPct)-p.UnitCostPKR) AS decimal(18,2)) AS PreReturnGrossProfitPKR
FROM dbo.FactSales_Stage s JOIN dbo.DimProducts_Stage p ON s.ProductID=p.ProductID
JOIN dbo.DimDealers_Stage d ON s.DealerID=d.DealerID
JOIN dbo.DimRegions_Stage r ON s.RegionID=r.RegionID;
GO
CREATE OR ALTER VIEW dbo.vw_RegionMonthPerformance AS
WITH sales_month AS (
 SELECT s.RegionID,DATEFROMPARTS(YEAR(s.OrderDate),MONTH(s.OrderDate),1) AS MonthStart,
        SUM(s.UnitsSold) AS SoldUnits,
        SUM(s.UnitsSold*s.UnitPricePKR*(1-s.DiscountPct)) AS BilledRevenuePKR,
        SUM(s.UnitsSold*p.UnitCostPKR) AS GrossCOGSPKR
 FROM dbo.FactSales_Stage s JOIN dbo.DimProducts_Stage p ON s.ProductID=p.ProductID
 GROUP BY s.RegionID,DATEFROMPARTS(YEAR(s.OrderDate),MONTH(s.OrderDate),1)
), returns_month AS (
 SELECT RegionID, DATEFROMPARTS(YEAR(ReturnDate),MONTH(ReturnDate),1) AS MonthStart,
        SUM(RefundAmountPKR) AS RefundPKR, SUM(ReturnQty) AS ReturnedUnits
 FROM dbo.FactReturns_Stage
 GROUP BY RegionID,DATEFROMPARTS(YEAR(ReturnDate),MONTH(ReturnDate),1)
)
SELECT t.MonthStart,r.RegionName,t.RegionID,t.RevenueTargetPKR,t.UnitsTarget,
       COALESCE(s.SoldUnits,0) AS SoldUnits,
       CAST(COALESCE(s.BilledRevenuePKR,0)-COALESCE(x.RefundPKR,0) AS decimal(18,2)) AS NetRevenuePKR,
       COALESCE(x.ReturnedUnits,0) AS ReturnedUnits,
       CAST((COALESCE(s.BilledRevenuePKR,0)-COALESCE(x.RefundPKR,0))/NULLIF(t.RevenueTargetPKR,0) AS decimal(14,4)) AS TargetAchievementRatio
FROM dbo.FactTargets_Stage t JOIN dbo.DimRegions_Stage r ON t.RegionID=r.RegionID
LEFT JOIN sales_month s ON t.RegionID=s.RegionID AND t.MonthStart=s.MonthStart
LEFT JOIN returns_month x ON t.RegionID=x.RegionID AND t.MonthStart=x.MonthStart;
GO
-- Starter analysis: month trend
SELECT MonthStart, SUM(NetRevenuePKR) AS NetRevenuePKR,
       SUM(RevenueTargetPKR) AS RevenueTargetPKR
FROM dbo.vw_RegionMonthPerformance GROUP BY MonthStart ORDER BY MonthStart;
-- Starter analysis: top-selling product families
SELECT TOP (10) Series,ModelName,SUM(UnitsSold) AS Units,
       SUM(BilledRevenuePKR) AS BilledRevenuePKR
FROM dbo.vw_SalesDetail GROUP BY Series,ModelName ORDER BY BilledRevenuePKR DESC;
-- Data quality checks: all queries should return zero rows unless the check returns totals.
SELECT r.ReturnID FROM dbo.FactReturns_Stage r JOIN dbo.FactSales_Stage s ON r.SaleID=s.SaleID
WHERE r.ReturnQty>s.UnitsSold OR r.ReturnDate<s.OrderDate
   OR r.DealerID<>s.DealerID OR r.ProductID<>s.ProductID OR r.WarehouseID<>s.WarehouseID;
SELECT i.SnapshotDate,i.WarehouseID,i.ProductID,i.SoldUnits,COALESCE(s.SoldUnits,0) AS SalesUnits
FROM dbo.FactInventory_Stage i LEFT JOIN (
   SELECT EOMONTH(OrderDate) AS SnapshotDate,WarehouseID,ProductID,SUM(UnitsSold) AS SoldUnits
   FROM dbo.FactSales_Stage GROUP BY EOMONTH(OrderDate),WarehouseID,ProductID
) s ON i.SnapshotDate=s.SnapshotDate AND i.WarehouseID=s.WarehouseID AND i.ProductID=s.ProductID
WHERE i.SoldUnits<>COALESCE(s.SoldUnits,0);
