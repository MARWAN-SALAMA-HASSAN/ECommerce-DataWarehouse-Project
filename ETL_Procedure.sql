USE ECommerce_DW;
GO

CREATE OR ALTER PROCEDURE SP_Load_ECommerce_DW
AS
BEGIN
    -- 1. نقل بيانات التاريخ
    INSERT INTO Dim_Date (DateKey, FullDate, Day, Month, MonthName, Quarter, Year)
    SELECT DISTINCT 
        CAST(FORMAT(o.OrderDate, 'yyyyMMdd') AS INT) AS DateKey,
        CAST(o.OrderDate AS DATE) AS FullDate,
        DAY(o.OrderDate) AS Day,
        MONTH(o.OrderDate) AS Month,
        DATENAME(month, o.OrderDate) AS MonthName,
        DATEPART(quarter, o.OrderDate) AS Quarter,
        YEAR(o.OrderDate) AS Year
    FROM ECommerce_OLTP.dbo.Orders o
    WHERE NOT EXISTS (
        SELECT 1 FROM Dim_Date d 
        WHERE d.DateKey = CAST(FORMAT(o.OrderDate, 'yyyyMMdd') AS INT)
    );

    -- 2. نقل بيانات العملاء
    INSERT INTO Dim_Customer (CustomerID, FullName, City, Country)
    SELECT 
        u.UserID,
        u.FullName,
        u.City,
        u.Country
    FROM ECommerce_OLTP.dbo.Users u
    WHERE NOT EXISTS (
        SELECT 1 FROM Dim_Customer c 
        WHERE c.CustomerID = u.UserID
    );

    -- 3. نقل بيانات المنتجات
    INSERT INTO Dim_Product (ProductID, ProductName, CategoryName, UnitPrice)
    SELECT 
        p.ProductID,
        p.ProductName,
        cat.CategoryName,
        p.Price
    FROM ECommerce_OLTP.dbo.Products p
    INNER JOIN ECommerce_OLTP.dbo.Categories cat ON p.CategoryID = cat.CategoryID
    WHERE NOT EXISTS (
        SELECT 1 FROM Dim_Product dp 
        WHERE dp.ProductID = p.ProductID
    );

    -- 4. نقل المبيعات لجدول الحقائق
    INSERT INTO Fact_Sales (DateKey, CustomerKey, ProductKey, OrderID, Quantity, TotalAmount)
    SELECT 
        CAST(FORMAT(o.OrderDate, 'yyyyMMdd') AS INT) AS DateKey,
        dc.CustomerKey,
        dp.ProductKey,
        o.OrderID,
        oi.Quantity,
        (oi.Quantity * oi.UnitPrice) AS TotalAmount
    FROM ECommerce_OLTP.dbo.Orders o
    INNER JOIN ECommerce_OLTP.dbo.OrderItems oi ON o.OrderID = oi.OrderID
    INNER JOIN Dim_Customer dc ON o.UserID = dc.CustomerID
    INNER JOIN Dim_Product dp ON oi.ProductID = dp.ProductID
    WHERE NOT EXISTS (
        SELECT 1 FROM Fact_Sales fs 
        WHERE fs.OrderID = o.OrderID AND fs.ProductKey = dp.ProductKey
    );

    PRINT 'ETL Process Loaded Successfully into Data Warehouse!';
END;
GO