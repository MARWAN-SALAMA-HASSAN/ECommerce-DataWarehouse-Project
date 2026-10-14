USE ECommerce_DW;
GO

-- 1. تقرير إجمالي المبيعات لكل منتج وتصنيفه
SELECT 
    dp.CategoryName,
    dp.ProductName,
    SUM(fs.Quantity) AS TotalUnitsSold,
    SUM(fs.TotalAmount) AS TotalRevenue
FROM Fact_Sales fs
INNER JOIN Dim_Product dp ON fs.ProductKey = dp.ProductKey
GROUP BY dp.CategoryName, dp.ProductName
ORDER BY TotalRevenue DESC;
GO

-- 2. تقرير مبيعات العملاء وأكثر العملاء شراءً
SELECT 
    dc.FullName,
    dc.City,
    COUNT(DISTINCT fs.OrderID) AS TotalOrders,
    SUM(fs.TotalAmount) AS TotalSpent
FROM Fact_Sales fs
INNER JOIN Dim_Customer dc ON fs.CustomerKey = dc.CustomerKey
GROUP BY dc.FullName, dc.City
ORDER BY TotalSpent DESC;
GO

-- 3. تقرير المبيعات الشهري
SELECT 
    d.Year,
    d.MonthName,
    SUM(fs.TotalAmount) AS MonthlyRevenue
FROM Fact_Sales fs
INNER JOIN Dim_Date d ON fs.DateKey = d.DateKey
GROUP BY d.Year, d.MonthName, d.Month
ORDER BY d.Year, d.Month;
GO