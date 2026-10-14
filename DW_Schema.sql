CREATE DATABASE ECommerce_DW;
GO

USE ECommerce_DW;
GO

-- 1. جدول الزمني
CREATE TABLE Dim_Date (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    Day INT NOT NULL,
    Month INT NOT NULL,
    MonthName NVARCHAR(50) NOT NULL,
    Quarter INT NOT NULL,
    Year INT NOT NULL
);

-- 2. جدول بعد العملاء
CREATE TABLE Dim_Customer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    City NVARCHAR(50),
    Country NVARCHAR(50)
);

-- 3. جدول بعد المنتجات
CREATE TABLE Dim_Product (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductName NVARCHAR(150) NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL
);

-- 4. جدول الحقائق الرئيسي (Fact Sales)
CREATE TABLE Fact_Sales (
    SaleKey INT IDENTITY(1,1) PRIMARY KEY,
    DateKey INT FOREIGN KEY REFERENCES Dim_Date(DateKey),
    CustomerKey INT FOREIGN KEY REFERENCES Dim_Customer(CustomerKey),
    ProductKey INT FOREIGN KEY REFERENCES Dim_Product(ProductKey),
    OrderID INT NOT NULL,
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL
);
GO