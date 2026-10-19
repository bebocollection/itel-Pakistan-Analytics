/* itel synthetic reproduction checks — run after sql/01_create_and_load_stage_tables.sql */
USE itel_Pakistan_Portfolio_Repro;
GO
-- 1. Sales figures and row count (per-sale discount rounded to 2 decimal places)
SELECT COUNT(*) AS TotalTransactions,
       SUM(UnitsSold) AS TotalUnitsSold,
       SUM(CAST(ROUND(UnitsSold * UnitPricePKR, 2) AS decimal(18,2))) AS GrossSalesPKR,
       SUM(CAST(ROUND(UnitsSold * UnitPricePKR * DiscountPct, 2) AS decimal(18,2))) AS DiscountPKR
FROM dbo.FactSales_Stage;
-- Reference: 12,000; 75,825; 2,071,389,250.00; 53,192,840.50

-- 2. Returns
SELECT COUNT(*) AS ReturnRecords,
       SUM(ReturnQty) AS ReturnedUnits,
       SUM(RefundAmountPKR) AS RefundPKR
FROM dbo.FactReturns_Stage;
-- Reference: 496; 826; 21,819,630.00

-- 3. Most recent monthly inventory snapshot
DECLARE @LatestSnapshot date = (SELECT MAX(SnapshotDate) FROM dbo.FactInventory_Stage);
SELECT @LatestSnapshot AS LatestSnapshotDate,
       SUM(ClosingStockUnits) AS ClosingStockUnits,
       SUM(ReorderPointUnits) AS ReorderPointUnits,
       COUNT(DISTINCT CASE WHEN ClosingStockUnits <= ReorderPointUnits THEN ProductID END)
          AS LowStockProducts,
       SUM(CASE WHEN ClosingStockUnits < ReorderPointUnits
                 THEN ReorderPointUnits-ClosingStockUnits ELSE 0 END) AS ShortageUnits
FROM dbo.FactInventory_Stage
WHERE SnapshotDate = @LatestSnapshot;
-- Reference: 2026-09-30; 31,886; 18,170; 4; 107

-- 4. Inventory stock identity — should return zero rows
SELECT SnapshotID, SnapshotDate, ProductID, WarehouseID
FROM dbo.FactInventory_Stage
WHERE ClosingStockUnits <> OpeningStockUnits + ReceivedUnits - SoldUnits + RestockedReturnUnits;

-- 5. Missing dimension references in sales — should return zero rows
SELECT s.SaleID FROM dbo.FactSales_Stage s
LEFT JOIN dbo.DimProducts_Stage p ON p.ProductID=s.ProductID
LEFT JOIN dbo.DimRegions_Stage r ON r.RegionID=s.RegionID
LEFT JOIN dbo.DimDealers_Stage d ON d.DealerID=s.DealerID
LEFT JOIN dbo.DimWarehouses_Stage w ON w.WarehouseID=s.WarehouseID
LEFT JOIN dbo.DimDate_Stage dt ON dt.[Date]=s.OrderDate
WHERE p.ProductID IS NULL OR r.RegionID IS NULL OR d.DealerID IS NULL OR w.WarehouseID IS NULL OR dt.[Date] IS NULL;

-- 6. Target completeness check: 7 regions x 21 months = 147 records
SELECT COUNT(*) AS TargetRecords,
       COUNT(DISTINCT RegionID) AS TargetRegions,
       COUNT(DISTINCT MonthStart) AS TargetMonths
FROM dbo.FactTargets_Stage;
-- Reference: 147; 7; 21
