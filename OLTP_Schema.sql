CREATE DATABASE ECommerce_OLTP;
GO

USE ECommerce_OLTP;
GO

-- 2. Users Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    City NVARCHAR(50),
    Country NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 3. Categories Table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

-- 4. Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(150) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    Price DECIMAL(18,2) NOT NULL,
    StockQuantity INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 5. Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(18,2) NOT NULL,
    OrderStatus NVARCHAR(50) DEFAULT 'Pending'
);

-- 6. OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE CASCADE,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL
);

-- 7. Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE CASCADE,
    PaymentDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(18,2) NOT NULL,
    PaymentMethod NVARCHAR(50),
    PaymentStatus NVARCHAR(50)
);
GO

-- نجرب بيانات مش حقيقيه (Dummy Data)
INSERT INTO Categories (CategoryName, Description) VALUES
('Electronics', 'Smartphones, Laptops, and Electronic gadgets'),
('Clothing', 'Men and Women fashion'),
('Home & Kitchen', 'Home appliances and kitchen tools');
GO

INSERT INTO Users (FullName, Email, Phone, City, Country) VALUES
('أحمد محمد', 'ahmed.mohamed@email.com', '01012345678', 'Cairo', 'Egypt'),
('سارة علي', 'sara.ali@email.com', '01123456789', 'Alexandria', 'Egypt'),
('محمود حسن', 'mahmoud.hassan@email.com', '01234567890', 'Giza', 'Egypt');
GO

INSERT INTO Products (ProductName, CategoryID, Price, StockQuantity) VALUES
('iPhone 15 Pro', 1, 45000.00, 15),
('Samsung Galaxy S24', 1, 38000.00, 20),
('Nike Running Shoes', 2, 2500.00, 50),
('Cotton T-Shirt', 2, 450.00, 120),
('Blender Machine', 3, 1800.00, 30);
GO

INSERT INTO Orders (UserID, TotalAmount, OrderStatus) VALUES
(1, 47500.00, 'Delivered'),
(2, 2950.00, 'Shipped'),
(3, 1800.00, 'Pending');
GO

INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 45000.00),
(1, 4, 5, 500.00),
(2, 3, 1, 2500.00),
(2, 4, 1, 450.00),
(3, 5, 1, 1800.00);
GO

INSERT INTO Payments (OrderID, Amount, PaymentMethod, PaymentStatus) VALUES
(1, 47500.00, 'Credit Card', 'Success'),
(2, 2950.00, 'Cash', 'Success'),
(3, 1800.00, 'PayPal', 'Pending');
GO